/**
 * IContent_display.as
 *
 * Interface definition
 * @description	This interface describes a factory pattern by
 * 				which data is presented to the screen, either
 *				as text, images, movies, etc. It extends the 
 *				IDisplay interface by adding a method by with
 *				an application can retrieve the product's user-
 *				defined position, i.e. top left, bottom right,
 *				center, etc.
 * @inheritance	IContent_display -> IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080416
 * @package		com.kaaterskil.display.factories
 */

package com.kaaterskil.display.factories{
	import flash.display.*;
	import flash.geom.Point;
	
	public interface IContent_display extends IDisplay{
		//retrieves the product's layout position on the
		//screen (if any)
		function get_layout():int;
	}
}