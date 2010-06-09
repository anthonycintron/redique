package 
{
	
	public class Redique
	{
		private var _redis:Redis;
		
		public function Redique()
		{
		}
		
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
		
		public function redis(server:ServerConfig):void
		{
			//Redis
		}
		
		public function workers():void
		{
			// return Worker.all
		}
		
		public function push(queue:Queue,):void
		{
		}
		
		public function pop(queue:Queue):void
		{
		}
	
	}
}