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
	
	public interface IMenu_handler{
		function get menu_id():int
		function get story_coords():Point;
		function render():void;
		function remove():void;
	}
}