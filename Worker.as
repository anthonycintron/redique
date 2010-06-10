package com.redique
{
	public class Worker
	{
		public var queues:String;
		
		/**
		 * Workers should be initialized with an array of string queue
		 * names. The order is important: A Worker will check the first
		 * queue given for a job. If none is found, it will be processed.
		 * Upon completion, the Worker will again check the first queue
		 * list passed to a Worker on startup defines the priorities of
		 * queues
		 *
		 */
		public function Worker(queues:String)
		{
			this.queues = queues;
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
		
		
	}
}