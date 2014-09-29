/**
 * Story_image_product.as
 *
 * Class definition
 * @description	A factory method product.
 * @inheritance	Story_image_product -> AContent_display
 *				-> ADisplay -> Sprite
 * @interface	IContent_display -> IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080417
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
	
	public class Story_image_product extends AContent_display{
		/**
		 * Containers
		 */
		public var	_text:Text_product;
		private var _image:Image_loader;
		
		/**
		 * Parameters
		 */
		private var _href:String;
		private var _description:String;
		private var _format:TextFormat;
		private var _position:Number;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Story_image_product():void{}

		/**
		 * Initialization
		 */
		override public function init(prams:Object, container:DisplayObjectContainer = null):void{
			this.name		= 'story_image_' + prams.src;
			_href			= prams.src;
			_description	= prams.description;
			_position		= prams.position != undefined ? prams.position : 0;
			_format			= prams.format;
			
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
		
		/**
		 * Get layout position
		 */
		override public function get_layout():int{
			return _position;
		}
		
		/*------------------------------------------------------------
		DRAWING METHODS
		------------------------------------------------------------*/
		/**
		 * Draw description text
		 */
		private function draw_text():void{
			 var obj:Object = new Object();
			 obj.x		= 0;
			 obj.y		= _image.height + 2;
			 obj.name	= 'image_description';
			 obj.prams = new Object();
			 obj.prams.props = {antiAliasType:		AntiAliasType.ADVANCED,
							    autoSize:			TextFieldAutoSize.CENTER,
								background:			true,
								backgroundColor:	0xffffff,
								embedFonts:			true,
								multiline:			true,
								selectable:			false,
								text:				_description,
								width:				_image.width,
								wordWrap:			true
								};
			obj.prams.format = _format;
			
			var factory:Display_factory = new Display_factory();
			factory.init(obj, this, Display_factory.TEXT_FIELD);
			_text = factory._instance as Text_product;
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Load image
		 */
		private function load_image():void{
			_image = new Image_loader();
			_image.addEventListener(Image_loader.INIT_EVENT, set_text);
			_image.process_load(_href);
			addChild(_image);
		}
		
		/**
		 * Set text
		 */
		private function set_text(e:Event):void{
			e.target.removeEventListener(Image_loader.INIT_EVENT, set_text);
			dispatchEvent(new Event(Event.INIT));
			if(_description != ''){
				draw_text();
			}
		}
	}
}