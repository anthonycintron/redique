package com.redique
{
	import com.codeazur.as3redis.*;
	
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
		
		public function redis(host:String="127.0.0.1", port:int=6379):void
		{
			//Redis
		}
		
		public function workers():void
		{
			// return Worker.all
		}
		
		public static function push(queue:Queue):void
		{
		}
		
		public static function pop(queue:Queue):void
		{
		}
	
	}
}