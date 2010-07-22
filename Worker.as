package com.redique
{
	import com.codeazur.as3redis.*;
	
	import flash.utils.getQualifiedClassName;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Worker extends EventDispatcher
	{
		public var 	queues:Array = new Array();
		public var 	workers:String;
		private var _paused:Boolean;
		
		public var  shutdown:Boolean;
		
		private var _shutdown:Boolean;
		private var redis:Redis;
		private var redique:Redique;
		private var timer:Timer;
		private var interval:int;
		private var job:Job;
		
		/**
		 * sets the Worker to pause
		 */
		public function pause():void
		{
			_paused = !_paused;
			timer.reset();
		}
		/**
		 * Gets the Worker going again.
		 */
		public function start():void
		{
			_paused  = !_paused;
			timer.start();
		}
		/**
		 * Workers should be initialized with an array of string queue
		 * names. The order is important: A Worker will check the first
		 * queue given for a job. If none is found, it will be processed.
		 * Upon completion, the Worker will again check the first queue
		 * list passed to a Worker on startup defines the priorities of
		 * queues
		 *
		 */
		public function Worker(queues:Array, redique:Redique)
		{
			this.queues = queues;
			this.redis = redique.redis;
			this.redique = redique;
			validateQueues();
		}	
		
		/**
		 * The work method gets the Worker started.
		 */
		public function work(interval:int=5000):void
		{
			startup();
			timer = new Timer(interval);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, onWork)			
		}
		/**
		 * Attempts to grab a job off  one of the provided queues. Returns
		 * null if no job can be found.
		 */
		private function reserve():void
		{
			if ( queues.length > 0 )
			{
				timer.reset();
				_paused = false;
				redique.addEventListener(RediqueEvent.REDIQUE_UPDATED, onRedisUpdated);
				for ( var i:int = 0; i < queues.length; i++ )
				{
					redique.reserve(queues[i].queue);
					queues.splice(i, 1);
				}
			}
		}
		
		/**
		 * Fired when redis has updated data.
		 */
		private function onRedisUpdated(e:RediqueEvent):void
		{
			redique.removeEventListener(RediqueEvent.REDIQUE_UPDATED, onRedisUpdated);
			timer.start();
		}
		
		private function onWork(e:TimerEvent):void
		{
			reserve()
		}
		
		/**
		 * Given a job, tells Redis we're working on it. Useful for seeing
		 * what workers are doing  and when
		 *
		 */
		private function workingOn(job:Object):void
		{
			job.worker = this;
			var data:Object = new Object();
			data.queue = job.queue;
			data.run_at = new Date();
			data.payload = job.payload;
			redis.sendSET("worker:"+getQualifiedClassName(this), Helpers.encode(data));
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
			var klassName:String = getQualifiedClassName(this)
			redis.sendSADD("workers", klassName);
			setStarted();
			
			trace("Start running.")
		}
				
		/**
		 * Tell Redis we started
		 */
		private function setStarted():void
		{
			var klassName:String = getQualifiedClassName(this)
			redis.sendSET("worker:"+klassName+":started", String(new Date()));
		}
		
		/**
		 * What time did this Worker start? Returns an instance of 'Date'
		 */
		private function getStarted():String
		{
			return redis.sendGET("worker:"+getQualifiedClassName(this)).toString();
		}
		
		/**
		 * A Worker must be given a queue, otherwise it won't know what to
		 * do with itself.
		 * 
		 * You probably never need to call this
		 */
		private function validateQueues():void
		{
			if ( queues != null && queues.length == 0 )
			{
				throw new Error("Please give each worker at least one queue.")
			}
		}
		
		
	}
}