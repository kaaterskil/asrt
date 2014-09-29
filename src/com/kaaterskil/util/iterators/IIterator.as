/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.iterators
 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
 */

package com.kaaterskil.utilities.iterators{
	/**
	 * IIterator interface
	 *
	 * @package		com.kaaterskil.utilities.iterators
	 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
	 * @version		080415
	 */
	public interface IIterator{
		function reset():void;
		function has_next():Boolean;
		function next():Object;
	}
}