/**
 * Kaaterskil Library
 * 
 * @version	$Id: $
 */
package com.kaaterskil.event {
	import flash.events.Event;
	
	/**
	 * The LoadEvent class defines event that are associatedd 
	 * with the Loader object.
	 * 
	 * @author Blair
	 */
	public final class LoadEvent extends Event {
		private var name : String;
		
		function LoadEvent(name : String) : void {
			super(name);
			this.name = name;
		}
		
		override public function toString() : String {
			return this.name;
		}
		
		/**
		 * The Loader is initializing
		 */
		public static const INIT : LoadEvent = new LoadEvent('INIT');
		
		/**
		 * The loader is opening the target object
		 */
		public static const OPEN : LoadEvent = new LoadEvent('OPEN');
		
		/**
		 * the loader is issuing a progress event
		 */
		public static const PROGRESS : LoadEvent = new LoadEvent('PROGRESS');
		
		/**
		 * the loader has completed the load process
		 */
		public static const COMPLETE : LoadEvent = new LoadEvent('COMPLETE');
		
		/**
		 * The loader is unloading the loaded object
		 */
		public static const UNLOAD : LoadEvent = new LoadEvent('UNLOAD');
		
		/**
		 * The loader has eperienced an HTTP event
		 */
		public static const HTTP_STATUS : LoadEvent = new LoadEvent('HTTP_STATUS');
		
		/**
		 * Tloader has experienced an error.
		 */
		public static const FAILED : LoadEvent = new LoadEvent('FAILED');
	}
}
