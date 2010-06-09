package
{
	
	public class Job implements IJob
	{
		// The worker object which is currently processing this job.
		public var worker:String;
		
		//This job's associated payload object.
		public var queue:String
		
		// # This job's associated payload object.
		public var payload:Object;
		
		public funciton Job(queue:String, payload:Object)	
		{ 
			this.queue = queue;
			this.payload = payload;
		}
		
		// Creates a job by placing it on a queue. Expects a string queue
    // name, a string class name, and an optional array of arguments to
   	// pass to the class' `perform` method.

    // Raises an exception if no queue or class is given.
		public static function create(queue:String, klass, ... args):void
		{
			if ( queue == '' || queue == null )
			{
				throw new Error ("Jobs must be placed onto a queue")
			}
			
			if (klass == null )
			{
				throw new Error("Jobs must be given a class.")
			}
			
			Resque.push(queue, klass.toString(), args);
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
		public static function destroy(queue:String, klass, ... args):int
		{
			var _klass:String = klass.toString();
			queue = "queue:" + queue;
			
			var _destroyed:int = 0;
			/*
			redis.lrange(queue, 0, -1).each do |string|
        json   = decode(string)

        match  = json['class'] == klass
        match &= json['args'] == args unless args.empty?

        if match
          destroyed += redis.lrem(queue, 0, string).to_i
        end
      end
			*/
			return _destroyed;
		}
		
		/**
		* Given a string queue name, returns an instance of Job
		* if any jobs are available. If not, returns null.
		*
		**/
		public static function reserve(queue):void
		{
		}
		
		/**
		* Attempts to perform the work represented by this job instance.
		* Calls perform() on the class given in the payload with the
		* arguments given in the payload
		*
		**/
		public perform(... args):void
		{			
		}
		
		
	}
}