/**
 * AContent_display.as
 *
 * Class definition
 * @description	The abstract class of factory products.
 * @inheritance	AContent_display -> ADisplay -> Sprite
 * @interface	IContent_display -> IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080423
 * @package		com.kaaterskil.display.factories
 */
 
package com.kaaterskil.display.factories{
	import flash.display.*;
	import flash.errors.*;
	import flash.geom.Point;
	
	public class AContent_display extends ADisplay implements IContent_display{
		public function AContent_display():void{}
		
		public function get_layout():int{
			throw new IllegalOperationError('Abstract method get_layout() must be overridden by a subclass.');
		}
	}
}