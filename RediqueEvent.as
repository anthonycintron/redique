package com.redique
{	
	import flash.events.Event;
	
	public class RediqueEvent extends Event 
	{
		public static const REDIQUE_UPDATED:String = 'redisUpdated';
		
		public var job:String;

		public function RediqueEvent(type:String, bubbles:Boolean, cancelable:Boolean, job:String)
		{
			super(type, bubbles, cancelable);
			this.job = job;
		}
		
		override public function clone():Event
		{			
			return new RediqueEvent(type, bubbles, cancelable, job);
		}
		
	}
}