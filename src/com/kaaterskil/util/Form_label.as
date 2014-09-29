/**
 * Form_label.as
 *
 * Class definition
 * @copyright 2007 Kaaterskil Management, LLC
 * @version 071220
 * @package com.kaaterskil.utilities
 */

/**
 * Basic class for a form label.
 * @param obj	An object containing the label parameters.
 */
 
package com.kaaterskil.utilities{
	import fl.controls.*;
	import flash.display.Sprite;
	import flash.text.*;
	
	public class Form_label extends Sprite{
		public var _label:TextField;
		private var _params:Object;
		private var _format:TextFormat;
		
		/**
		 * Constructor
		 */
		public function Form_label(obj:Object):void{
			_params = obj;
			set_text_format();
			draw_label();
			addChild(_label);
		}
		
		/**
		 * Getter functions
		 */
		public function get_column():Number{
			return _params.column;
		}
		
		public function get_width():Number{
			return _label.width;
		}
		
		/**
		 * Setter functions
		 */
		public function set_x(v:Number):void{
			_label.x = v;
		}
		
		public function set_y(v:Number):void{
			_label.y = v;
		}
		
		public function set_width(v:Number):void{
			_label.width = v;
		}
		
		/**
		 * Draws the label. Note that the method that calls this class
		 * should explicitly add the class instance to the display list.
		 * This class definition does not, so as to allow the creation
		 * of container objects.
		 */
		private function draw_label():void{
			_label = new TextField();
			_label.autoSize		= TextFieldAutoSize.LEFT;
			_label.embedFonts	= true;
			_label.multiline	= false;
			_label.name			= _params.field_name + '_lbl';
			_label.selectable	= false;
			_label.text			= _params.form_label;
			_label.type			= TextFieldType.DYNAMIC;
			_label.wordWrap		= false;
			_label.setTextFormat(_format);
		}
		
		/**
		 * Set the label format
		 */
		private function set_text_format():void{
			_format = _params.label_format;
		}
	}
}