package com.redique
{
	
	import com.codeazur.as3redis.*;
	import com.codeazur.as3redis.events.RedisMonitorDataEvent;
	import com.codeazur.as3redis.commands.INFO;
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class Redique extends EventDispatcher
	{
		public var queues:String;
		public var redis:Redis;
		
		private var job:Object;
		private var requestingJob:Boolean;
		
		public function Redique(){}
		/**
		 * job shortcuts
		 *
		 *
		 * This method can be used to conveniently add a job to a queue.
		 * It assumes the class you're passing it is a real AS Class
		 * a) has a queue
		 * b) responds to 'queue'
		 *
		 *
		 * If either of those conditions are met, it will use the value obtained
		 * from performing one of the above operations to determine the queue.
		 * 
		 * If no queue can be inferred this method will raise an Error
		 * 
		 */
		public function enqueue(job:Object, ... args):void
		{
			job.redique = this;
			job.create();
			this.job = job;
		}
		
		public function dequeue(job:Object, ... args):void
		{
			// Job.destroy
		}
		
		/**
		 * request for a job pertaining to the applied queue
		 */
		public function reserve(queue:String):void
		{
				job.reserve(queue);
		}
		
		/**
		 * start Redis connection and monitor all commands.
		 */
		public function start(host:String="127.0.0.1", port:int=6379):void
		{
			redis = new Redis(host, port);
			redis.sendMONITOR().addSimpleResponder(
				function(cmd:RedisCommand):void 
				{
						if ( requestingJob )
						{
							dispatchEvent(new RediqueEvent(RediqueEvent.REDIQUE_UPDATED, true, true, cmd.responseBulkAsStrings[0]));
							requestingJob = false;
						}
				}
			);
		}
		/**
		 * Returns a list of workers as an Array()
		 */
		public function workers():Array
		{
			return RediqueManager.instance.workers;
		}
		
		/**
		 * Pushes a job onto a queue. Queue name should be a string and the
		 * item should be any JSON-able Object.
		 */
		public function push(queue:String, item:Object):void
		{
			watchQueue(queue)
			redis.sendRPUSH("queue:"+queue, Helpers.encode(item));
		}
		
		/**
		 * Pops a job off a queue. Queue name should be a string
		 * Returns an Object
		 */
		public function pop(queue:String):void
		{
			requestingJob = true;
			redis.sendLPOP("queue:"+queue)
		}		
				
		/**
		 * gives the size of the queue.
		 */
		public function size(queue:String):void
		{
			redis.sendLLEN("queue:"+queue);
		}
		
		private function onResult(e:RedisCommand):void
		{
			trace("<<<< onResult() >>>>> " + e)
		}
		
		/**
		 * Used internally to keep track of which queues we've created.
		 * Don't call this directly.
		 */
		private function watchQueue(queue:String):void
		{
			// @TODO -  take hard code out
			redis.sendSADD("com.redique::Worker", queue);
		}
	
	}
}