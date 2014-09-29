/**
 * IImage_gallery.as
 *
 * Interface defintion
 * @description	This is an interface for a decorated pattern
 *				that renders galleries of images.
 * @inheritance	IImage_gallery -> IContent_display -> IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080420
 * @package		com.kaaterskil.display.image_galleries
 */

package com.kaaterskil.display.image_galleries{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	import com.kaaterskil.display.factories.*;
	import com.kaaterskil.utilities.iterators.*;
	
	public interface IImage_gallery extends IContent_display{
		function get_position():Point;
		function get_index():IIterator;
		function get index_length():int;
		function get_container():DisplayObjectContainer;
		function stop_timer(e:Event):void;
	}
}