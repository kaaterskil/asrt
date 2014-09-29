/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.libraries
 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
 */

package com.kaaterskil.utilities.libraries{
	import com.kaaterskil.utilities.iterators.*;
	
	/**
	 * ILibrary interface
	 *
	 * @package		com.kaaterskil.utilities.libraries
	 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
	 * @version		080415
	 */
	public interface ILibrary{
		function iterator(type:String = null):IIterator;
		function get_size():int;
	}
}