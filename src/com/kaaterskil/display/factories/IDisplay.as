﻿/**
 * IDisplay.as
 *
 * Interface definition
 * @description	This interface describes a factory pattern by
 * 				which data is presented to the screen, either
 *				as text, images, movies, etc.
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080416
 * @package		com.kaaterskil.display.factories
 */

package com.kaaterskil.display.factories{
	import flash.display.*;
	import flash.geom.Point;
	
	public interface IDisplay{
		//loads the product's parameters and begins the drawing process
		function init(prams:Object, container:DisplayObjectContainer = null):void;
		
		//set the product's x/y coordinates
		function set_position(point:Point):void;
	}
}