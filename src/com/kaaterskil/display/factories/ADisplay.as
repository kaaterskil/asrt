/**
 * ADisplay.as
 *
 * Class definition
 * @description	The abstract class of factory products.
 * @inheritance	ADisplay -> Sprite
 * @interface	IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080423
 * @package		com.kaaterskil.display.factories
 */
 
package com.kaaterskil.display.factories{
	import flash.display.*;
	import flash.errors.*;
	import flash.geom.Point;
	
	public class ADisplay extends Sprite implements IDisplay{
		public function init(prams:Object, container:DisplayObjectContainer = null):void{
			throw new IllegalOperationError('Abstract method init() must be overridden by a subclass.');
		}
		
		public function set_position(point:Point):void{
			throw new IllegalOperationError('Abstract method set_position() must be overridden by a subclass.');
		}
	}
}