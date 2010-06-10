package com.redique
{
	import com.codeazur.as3redis.*;
	import com.codeazur.as3redis.events.RedisMonitorDataEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class Redique extends EventDispatcher
	{
		public var queues:String;
		
		public var redis:Redis;
		
		public function enqueue(job:Job, ... args):void
		{
			// Job.create
		}
		
		public function dequeue(job:IJob, ... args):void
		{
			// Job.destroy
		}
		
		public function reserve(queue:String):void
		{
			// Job.reserve
		}
		
		public function startRedis(host:String="127.0.0.1", port:int=6379):void
		{
			redis = new Redis(host, port);
			redis.sendMONITOR().addSimpleResponder( 
				function(cmd:RedisCommand):void
				{
					redis.addEventListener(RedisMonitorDataEvent.MONITOR_DATA, monitorDataHandler);
				}
			 );
			dispatchEvent(new Event("rediqueReady"));
		}
		
		private function monitorDataHandler(event:RedisMonitorDataEvent):void
		{
			trace(event.command);
		}
		
		private function onResponse(cmd:RedisCommand):void
		{
			
		}
		
		public function workers():void
		{
			// return Worker.all
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
			redis.sendLPOP("queue:"+queue);
		}
		
		
		public function size(queue:String):void
		{
			redis.sendLLEN("queue:"+queue);
		}
		
		private function watchQueue(queue:String):void
		{
			redis.sendSADD(queues, queue);
		}
	
	}
}