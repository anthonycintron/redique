package com.redique
{
	import com.maccherone.json.JSON;
	
	public class Helpers
	{
		/**
		 * Given a string, returns an Object
		 */
		public static function decode(value:String):Object
		{
			return JSON.decode(value, true);
		}
	
		/**
		 * Given an Object, returns a string suitable for storage in a 
		 * queue.
		 */
		public static function encode(value:Object):String
		{
			return JSON.encode(value);
		}
	}
}