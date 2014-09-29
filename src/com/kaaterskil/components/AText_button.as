/**
 * AText_button.as
 *
 * Class definition
 * @description	This is a base text button class. It contains no
 *				functionality other than to change the text format on
 *				rollover or rollout. Otherwise, it expects that its
 *				onClick handler to be overwritten in any extended class,
 *				or to be decorated by any decorator class.
 * @inheritance	AButton -> Sprite
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080523
 * @package		com.kaaterskil.components
 */

package com.kaaterskil.components{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.*;
	
	import com.kaaterskil.display.factories.*;
	
	public class AText_button extends Sprite{
		private var _container:Text_product;
		protected var _formats:Object;
		private var _text:String;
		
		/**
		 * Constructor
		 * @params obj	A parameterized object. This class expects that
		 * the object contains at least two properties, format and text.
		 * The format property should be an object with at least three
		 * TextFormat properties entitled rollout, rollover and click.
		 * The text property should be a string containing the button text.
		 */
		public function AText_button(obj:Object):void{
			_formats	= obj.format;
			_text		= obj.text;
			
			if(_text != null){
				draw_text();
			}
		}
		
		/*------------------------------------------------------------
		PUBLIC METHODS
		------------------------------------------------------------*/
		/**
		 * Set position
		 */
		public function set_position(point:Point):void{
			if(point == null){
				point = new Point();
			}
			this.x = point.x;
			this.y = point.y;
		}
		
		/*------------------------------------------------------------
		PROTECTED METHODS
		------------------------------------------------------------*/
		/**
		 * Set text format.
		 */
		protected function set_format(fmt:TextFormat):void{
			var len:int = _container.get_field_property('length');
			_container.reset_format(fmt, 0, len);
		}
		
		/**
		 * onClick handler. This method expects to be overridden by an
		 * extended class.
		 */
		protected function click_handler(e:MouseEvent):void{
			set_format(_formats.click);
		}
		
		/*------------------------------------------------------------
		PRIVATE METHODS
		------------------------------------------------------------*/
		/**
		 * Draw button text
		 */
		private function draw_text():void{
			//build parameters
			var props:Object		= {AntiAliasType:	AntiAliasType.ADVANCED, 
									   autoSize:		TextFieldAutoSize.LEFT, 
									   embedFonts:		true, 
									   text:			_text, 
									   selectable:		false
									   };
			var format:TextFormat	= _formats.rollout;
			var obj:Object			= {name:	'btn_text', 
									   prams:	{props:props, format:format}
									   };
							  
			//create text field
			_container = new Text_product();
			_container.init(obj, this);
			_container.addEventListener(MouseEvent.CLICK,		click_handler);
			_container.addEventListener(MouseEvent.ROLL_OVER,	rollover_handler);
			_container.addEventListener(MouseEvent.ROLL_OUT,	rollout_handler);
		}
		
		/**
		 * onRollOver handler
		 */
		private function rollover_handler(e:MouseEvent):void{
			set_format(_formats.rollover);
		}
		
		/**
		 * onRollOut handler
		 */
		private function rollout_handler(e:MouseEvent):void{
			set_format(_formats.rollout);
		}
	}
}