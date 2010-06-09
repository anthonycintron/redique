package com.redique
{
	import com.codeazur.as3redis.*;
	import com.codeazur.as3redis.events.RedisMonitorDataEvent;
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
			_redis = new Redis(host, port);
			
			_redis.sendMONITOR().addSimpleResponder( 
				function(cmd:RedisCommand):void
				{
					_redis.addEventListener(RedisMonitorDataEvent.MONITOR_DATA, monitorDataHandler);
				}
			 );
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
		
		public static function push(queue:Queue):void
		{
		}
		
		public static function pop(queue:Queue):void
		{
		}
	
	}
}