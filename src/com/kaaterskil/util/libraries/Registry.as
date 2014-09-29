/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.libraries
 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
 */

package com.kaaterskil.utilities.libraries{
	import com.kaaterskil.utilities.Common;
		
	/**
	 * Registry class
	 *
	 * @description	A registry singleton class.
	 * @package		com.kaaterskil.utilities.libraries
	 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
	 * @version		080521
	 */
	public class Registry implements IRegistry{
		private static var _instance:Registry	= null;
		private var _store:Object 				= {};
		
		/**
		 * Constructor
		 */
		public function Registry(singleton:Singleton_enforcer){}
		
		public static function get_instance():Registry{
			if(Registry._instance == null){
				Registry._instance = new Registry(new Singleton_enforcer());
			}
			return Registry._instance;
		}
		
		/*------------------------------------------------------------
		PUBLIC METHODS
		------------------------------------------------------------*/
		/**
		 * Add an item to the registry.
		 */
		public function register(key:String, val:Object):void{
			_store[key] = val;
		}
		
		/**
		 * Remove an item from the registry
		 * 
		 * Returns true on success, false if the property wasn't defined.
		 */
		public function unregister(key:String):Boolean{
			if(key != null){
				for(var item:* in _store){
					if(item == key){
						_store[key] = null;
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * Return a registry item.
		 */
		public function get_item(key:String):Object{
			if(key != null){
				for(var item:* in _store){
					if(item == key){
						return _store[item];
					}
				}
			}
			return null;
		}
		
		/**
		 * Return true if item exists in registry.
		 */
		public function has(key:String):Boolean{
			return Common.obj_property_exists(key, _store, true);
		}
	}
}

class Singleton_enforcer{}
