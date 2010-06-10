package com.redique
{
	import com.codeazur.as3redis.*;
	public class Worker
	{
		public var 	queues:String;
		public var 	workers:String;
		private var _shutdown:Boolean;
		private var redis:Redis;
		/**
		 * Workers should be initialized with an array of string queue
		 * names. The order is important: A Worker will check the first
		 * queue given for a job. If none is found, it will be processed.
		 * Upon completion, the Worker will again check the first queue
		 * list passed to a Worker on startup defines the priorities of
		 * queues
		 *
		 */
		public function Worker(queues:String, redis:Redis)
		{
			this.queues = queues;
			this.redis = redis;
			validateQueues();
		}
		/**
		 * A Worker must be given a queue, otherwise it won't know what to
		 * do with itself.
		 * 
		 * You probably never need to call this
		 */
		private function validateQueues():void
		{
			if ( queues == null || queues == '' )
			{
				throw new Error("Please give each worker at least one queue.")
			}
		}
		
		public function work(interval:int=50000):void
		{
			startup();
		}
		
		/**
		 * Runs all the methods needed when a worker begins its lifecycle.
		 */
		private function startup():void
		{
			// @todo - pruneDeadWorkers();
			registerWorker();
			
		}
		/**
		 * Registers ourself as worker. Useful when entering the worker
		 * lifecycle on startup.
		 */
		private function registerWorker():void
		{
			redis.sendSADD("worker", "this");
			redis.sendSET("worker:"+this+":started", new Date());
			trace("Started running.")
		}
	
		
	}
}