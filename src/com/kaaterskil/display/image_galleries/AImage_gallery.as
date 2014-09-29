/**
 * AImage_gallery.as
 *
 * Class defintion
 * @description	This is an abtract decorator class and provides
 *				base functionality to other decorated classes.
 * @inheritance	AImage_gallery -> AContent_display -> ADisplay -> Sprite
 * @interface	IImage_gallery -> IContent_display -> IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080420
 * @package		com.kaaterskil.display.image_galleries
 */

package com.kaaterskil.display.image_galleries{
	import flash.display.*;
	import flash.errors.*;
	import flash.events.*;
	import flash.geom.Point;
	
	import com.kaaterskil.display.factories.*;
	import com.kaaterskil.utilities.iterators.*;
	
	public class AImage_gallery extends AContent_display implements IImage_gallery{
		/**
		 * Constructor
		 */
		public function AImage_gallery():void{};
		
		/**
		 * Loads the product's parameters and begins the drawing 
		 * process. Required by interface IDisplay.
		 */
		override public function init(prams:Object, container:DisplayObjectContainer = null):void{
			throw new IllegalOperationError('Abstract method init() must be overridden by a subclass.');
		}
		
		/**
		 * Sets the product's x/y coordinates. Required by 
		 * interface IDisplay
		 */
		override public function set_position(point:Point):void{
			throw new IllegalOperationError('Abstract method set_position() must be overridden by a subclass.');
		}
		
		/**
		 * Sets the product's x/y coordinates. Required by 
		 * interface IContent_display
		 */
		override public function get_layout():int{
			throw new IllegalOperationError('Abstract method get_layout() must be overridden by a subclass.');
		}
		
		/**
		 * Gets the product's x/y coordinates. Required by 
		 * interface IImage_gallery
		 */
		public function get_position():Point{
			throw new IllegalOperationError('Abstract method get_position() must be overridden by a subclass.');
		}
		
		/**
		 * Gets the product's image index. Required by 
		 * interface IImage_gallery
		 */
		public function get_index():IIterator{
			throw new IllegalOperationError('Abstract method get_index() must be overridden by a subclass.');
		}
		
		/**
		 * Returns the number of images in the index. Required by 
		 * interface IImage_gallery
		 */
		public function get index_length():int{
			throw new IllegalOperationError('Abstract method get index_length() must be overridden by a subclass.');
		}
		
		/**
		 * Gets the product's display container. Required by 
		 * interface IImage_gallery
		 */
		public function get_container():DisplayObjectContainer{
			throw new IllegalOperationError('Abstract method get_container() must be overridden by a subclass.');
		}
		
		public function stop_timer(e:Event):void{
			throw new IllegalOperationError('Abstract method stop_timer() must be overridden by a subclass.');
		}
	}
}