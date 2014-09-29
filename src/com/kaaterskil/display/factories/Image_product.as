/**
 * Image_product.as
 *
 * Class definition
 * @description	A factory method product.
 * @inheritance	Image_product -> ADisplay -> Sprite
 * @interface	IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080522
 * @package		com.kaaterskil.display.factories
 */

package com.kaaterskil.display.factories{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	
	import com.kaaterskil.utilities.*;
	import com.kaaterskil.utilities.loaders.*;
	
	public class Image_product extends ADisplay{
		/**
		 * Containers
		 */
		private var _image:Image_loader;
		
		/**
		 * Parameters
		 */
		private var _href:String;
		private var _position:Number;
		
		/**
		 * Constructor
		 */
		public function Image_product():void{}

		/*------------------------------------------------------------
		PUBLIC METHODS
		------------------------------------------------------------*/
		/**
		 * Initialization
		 */
		override public function init(prams:Object, container:DisplayObjectContainer = null):void{
			this.name		= 'image_' + prams.filename;
			_href			= prams.src;
			_position		= prams.position != undefined ? prams.position : 0;
			
			load_image();
		}
		
		/**
		 * Set position
		 */
		override public function set_position(point:Point):void{
			this.x = point.x;
			this.y = point.y
			//Common.trace_point(this);
		}
		
		/*------------------------------------------------------------
		PRIVATE METHODS
		------------------------------------------------------------*/
		/**
		 * Load image
		 */
		private function load_image():void{
			_image = new Image_loader();
			_image.addEventListener(Image_loader.INIT_EVENT, on_initialized_handler);
			_image.process_load(_href);
			addChild(_image);
		}
		
		/**
		 * Broadcast load event
		 */
		private function on_initialized_handler(e:Event):void{
			_image.removeEventListener(Image_loader.INIT_EVENT, on_initialized_handler);
			dispatchEvent(new Event('image_initialized'));
		}
	}
}