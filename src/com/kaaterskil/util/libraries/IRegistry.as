/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.libraries
 * @copyright	2008 Kaaterskil Management, LLC
 */

package com.kaaterskil.utilities.libraries{
	/**
	 * IRegistry interface
	 *
	 * @description	A registry pattern interface
	 * @package		com.kaaterskil.utilities.libraries
	 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
	 * @version		080521
	 */
	public interface IRegistry{
		/**
		 * Add an item to the registry.
		 */
		function register(key:String, object:Object):void;
		
		/**
		 * Remove an item from the registry.
		 */
		function unregister(key:String):Boolean;
		
		/**
		 * Return a registry item.
		 */
		function get_item(key:String):Object;
		
		/**
		 * Return true if item exists in registry.
		 */
		function has(key:String):Boolean;
	}
}