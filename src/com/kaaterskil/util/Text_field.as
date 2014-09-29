/**
 * Text_field.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080122
 * @package com.kaaterskil.utilities
 */

package com.kaaterskil.utilities{
	import flash.display.Sprite;
	import flash.text.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import com.kaaterskil.utilities.Common;
	
	public class Text_field extends Sprite{
		/**
		 * Display objects
		 */
		public var _field:TextField;
		
		/**
		 * On losing focus param
		 */
		public var _on_focus_out:String;
		
		/*------------------------------------------------------------
		CREATION METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Text_field(obj:Object):void{
			init(obj);
		}
		
		/**
		 * Initialization.Loops through all the parameters passed to
		 * the constructor and sets the appropriate property.
		 */
		private function init(obj:Object):void{
			this.name		= obj.name;
			_on_focus_out	= obj.on_focus_out != undefined ? obj.on_focus_out : '';
			if(obj.x != undefined && obj.y != undefined){
				set_coords(obj.x, obj.y);
			}
			set_field(obj.prams);
		}
		
		/*------------------------------------------------------------
		GETTER METHODS
		------------------------------------------------------------*/
		/**
		 * Returns the text field's metrics
		 */
		public function get_metrics():TextLineMetrics{
			return _field.getLineMetrics(0);
		}
		
		/**
		 * Returns the instance bounds
		 */
		public function get_instance_dims():Rectangle{
			return this.getBounds(this.parent);
		}
		
		/*------------------------------------------------------------
		SETTER METHODS
		------------------------------------------------------------*/
		/**
		 * Sets the instance coordinates
		 */
		public function set_coords(x_coord:Number, y_coord:Number){
			this.x = x_coord;
			this.y = y_coord;
		}
		
		/**
		 * Set field parameters
		 */
		private function set_field(obj:Object):void{
			_field = new TextField();
			_field.name = 'tf_' + this.name;
			
			if(obj.props != undefined){
				set_properties(obj.props);
			}
			if(obj.format != undefined){
				set_format(obj.format);
			}
			if(obj.on_change != undefined){
				_field.addEventListener(Event.CHANGE, on_change_handler);
			}
			_field.addEventListener(FocusEvent.FOCUS_OUT, on_focus_out_handler);
			addChild(_field);
		}
		
		/**
		 * Set properties
		 */
		private function set_properties(obj:Object):void{
			for(var key:* in obj){
				if(_field.hasOwnProperty(key)){
					if(key == 'restrict'){
						_field.restrict = set_restrictions(obj[key]);
					}else{
						_field[key] = obj[key];
					}
				}
			}//end for
		}
		
		/**
		 * Set format
		 */
		public function set_format(tf:TextFormat):void{
			_field.defaultTextFormat = tf;
			_field.setTextFormat(tf);
		}
		
		/**
		 * Set character restrictions
		 */
		private function set_restrictions(pattern:String):String{
			var r = '';
			switch(pattern){
				case 'char':
				case 'varchar':
				case 'text':
					r = "a-zA-Z0-9 \\_\\-\\.\\'";
					break;
				case 'int':
				case 'integer':
					r = "0-9";
					break;
				case 'float':
					r = "0-9\\.";
					break;
				case 'telephone':
					r = "0-9";
					break;
				case 'email':
					r = "a-zA-Z0-9\\_\\-\\.@";
					break;
				case 'date':
					r = "0-9 \\-\\.\u0020\u002F";
					break;
			}
			return r;
		}
		
		/*------------------------------------------------------------
		LISTENER METHODS
		------------------------------------------------------------*/
		/**
		 * Handles change events
		 */
		private function on_change_handler(e:Event):void{
			dispatchEvent(new Event('text_input_changed'));
		}
		
		/**
		 * Handles losing focus
		 */
		private function on_focus_out_handler(e:FocusEvent):void{
			if(_on_focus_out != '' && e.target.text != ''){
				switch(_on_focus_out){
					case 'format_telephone':
						e.target.text = Common.format_telephone(e.target.text);
						break;
					case 'validate_date':
						e.target.text = Common.validate_date(e.target.text);
						break;
					case 'validate_email':
						e.target.text = Common.validate_email(e.target.text);
						break;
				}
			}
		}
	}
}