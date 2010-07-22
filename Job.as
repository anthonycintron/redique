package com.redique
{
	import flash.utils.getQualifiedClassName;
	/**
	 * A Redique Job represents a unit of work. Each job lives on a
	 * single queue and has an associated payload object. The payload
	 * is a hash with two attributes: `class` and `args`. The `class` is
	 * the name of the Ruby class which should be used to run the
`	 * job. The `args` are an array of arguments which should be passed
	 * to the class's `perform` class-level method.
	 */
	public class Job implements IJob
	{
		// The worker object which is currently processing this job.
		public var worker:Object;
		
		//This job's associated payload object.
		public var queue:String
		
		// # This job's associated payload object.
		public var payload:Object;
		
		public var redique:Redique;
		
		private var klass:Object;
		
		public function Job(queue:String, klass:Object, ... args)	
		{ 
			this.queue = queue;
			this.payload = args;
			this.klass = klass;
		}
		
		/**
		 * Creates a job by placing it on a queue. Expects a string queue
     * name, a string class name, and an optional array of arguments to
   	 * pass to the class' `perform` method.

     * Raises an exception if no queue or class is given.
		 */
		public function create(... args):void
		{
			if ( queue.length == 0 )
				throw new Error("Jobs must be placed onto a queue.");
			
			if ( klass == null )
				throw new Error("Jobs must be given a class.");

			redique.push( queue, klass );
		}
		
		/**
		* Removes a job from a queue. Expects a string queue name, a string
		* class name, and, optionally, args.
		* 
		* Returns the number of jobs destroyed.
		*
		* If no args are provided, it will remove all jobs of the class
		* provided
		*
		* That is, for these two jobs:
		* { 'class' => 'UpdateGraph', 'args' => ['defunkt'] }
		* { 'class' => 'UpdateGraph', 'args' => ['mojombo'] }
		*
		* The following call will remove both:
		* Job.destroy(queue, 'UpdateGraph')
		* 
		* Whereas specifying args will only remove the 2nd job:
		*
		* Job.destroy(queue, 'UpdateGraph', 'mojombo')
		*
		*
		* This method can be potenially very slow and memory intensive,
		* depending on the size of your queue, as it loads all jobs into an ArrayyCollection
		* before processing.
		*
		**/
		public static function destroy(queue:String, klass:Class, ... args):int
		{
			var _destroyed:int;
			return _destroyed;
		}
		
		/**
		* Given a string queue name, returns an instance of Job
		* if any jobs are available. If not, returns null.
		*
		**/
		public function reserve(queue:String):void
		{
		 	redique.pop(queue);
		}
		
		/**
		* Attempts to perform the work represented by this job instance.
		* Calls perform() on the class given in the payload with the
		* arguments given in the payload
		*
		**/
		public function perform(... args):void
		{
			trace("Job.perform()")
		}
		
	}
}