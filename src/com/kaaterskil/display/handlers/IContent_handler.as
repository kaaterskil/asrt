/**
 * IContent_handler.as
 *
 * Interface definition
 * @description	This is an interface for a series of content 
 *				rendering classes.
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080416
 * @package		com.kaaterskil.display.handlers
 */

package com.kaaterskil.display.handlers{
	import flash.geom.Point;
	
	public interface IContent_handler{
		//renders content item to the screen
		function render(point:Point, menu_id:int):void;
		
		//removes content from the screen
		function remove():void;
	}
}