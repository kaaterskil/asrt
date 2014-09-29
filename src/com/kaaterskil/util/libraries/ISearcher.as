/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.libraries
 * @copyright	Copyright (c) 2008 Kaateskil Management, LLC
 */

package com.kaaterskil.utilities.libraries{
	/**
	 * ISearcher interface
	 *
	 * @package		com.kaaterskil.utilities.libraries
	 * @copyright	Copyright (c) 2008 Kaateskil Management, LLC
	 * @version		080415
	 */
	public interface ISearcher{
		function get_element(prop:String, val:*):Object;
		function get_property(prop1:String, val:*, prop2:String):*;
	}
}