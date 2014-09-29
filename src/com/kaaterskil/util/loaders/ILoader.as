/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.loaders
 * @copyright	2008 Kaaterskil Management, LLC
 */

package com.kaaterskil.utilities.loaders{
	/**
	 * ILoader interface
	 *
	 * @package		com.kaaterskil.utilities.loaders
	 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
	 * @version		080417
	 */
	public interface ILoader{
		function get is_loaded():Boolean;
		function process_load(src:String):void;
	}
}