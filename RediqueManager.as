package com.redique
{
	import com.paperlesspost.card.CardModel;
	import flash.events.EventDispatcher;
	
	public class RediqueManager extends EventDispatcher
	{
		public var queues:Array;
		public var workers:Array;
		
		
		private static var _instance:RediqueManager;
		
		public function RediqueManager()
		{
			super();
			if ( _instance != null )
			{
				throw new Error ("Error:ApplicationModel already initialized.");
			}
			
			if ( _instance == null )
			{
				_instance = this;
			}
		}
		
		public static function get instance():RediqueManager
		{
			return initialize();
		}
		
		public static function initialize():RediqueManager
		{
			if ( _instance == null )
			{
				_instance = new RediqueManager();
			}
			return _instance;
		}
	}
}