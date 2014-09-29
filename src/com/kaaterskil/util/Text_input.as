/**
 * Text_input.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080121
 * @package com.kaaterskil.utilities
 */

package com.kaaterskil.utilities{
	import fl.controls.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.Rectangle;
	import com.kaaterskil.utilities.Common;
	
	public class Text_input extends Sprite{
		/**
		 * Display objects
		 */
		public var _field:TextInput;
		public var _label:Label;
		private var _mask:Sprite;
		
		/**
		 * On losing focus param
		 */
		public var _on_focus_out:String;
		
		/**
		 * The form column
		 */
		public var _column:Number;
		
		/**
		 * Tests whether the field is required for validation
		 */
		public var _required:Boolean;
		
		/*------------------------------------------------------------
		CREATION METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Text_input(obj:Object):void{
			init(obj);
		}
		
		/**
		 * Initialization.Loops through all the parameters passed to
		 * the constructor and sets the appropriate property.
		 */
		private function init(obj:Object):void{
			this.name		= obj.field_name;
			_column			= obj.column != undefined ? obj.column : 0;
			_required		= obj.required != undefined ? obj.required : false;
			_on_focus_out	= obj.on_focus_out;
			
			set_label(obj.label_params);
			set_field(obj.field_params);
			set_starting_position();
		}
		
		/**
		 * Set label parameters
		 */
		private function set_label(obj:Object):void{
			_label = new Label();
			_label.name = 'lb_' + this.name;
			
			if(obj.props != undefined){
				set_properties(_label, obj.props);
			}
			if(obj.format != undefined){
				set_format(_label, obj.format);
			}
			if(obj.styles != undefined){
				set_styles(_label, obj.styles);
			}
			addChild(_label);
		}
		
		/**
		 * Set field parameters
		 */
		private function set_field(obj:Object):void{
			_field = new TextInput();
			_field.name = 'ti_' + this.name;
			
			if(obj.props != undefined){
				set_properties(_field, obj.props);
			}
			if(obj.format != undefined){
				set_format(_field, obj.format);
			}
			if(obj.styles != undefined){
				set_styles(_field, obj.styles);
			}
			_field.addEventListener(FocusEvent.FOCUS_OUT, on_focus_out_handler);
			addChild(_field);
		}
		
		/*------------------------------------------------------------
		GETTER METHODS
		------------------------------------------------------------*/
		/**
		 * Gets label width
		 */
		public function get_label_metrics():TextLineMetrics{
			return _label.textField.getLineMetrics(0);
		}
		
		/**
		 * Gets field width
		 */
		public function get_field_width():Number{
			return _field.width;
		}
		
		/**
		 * Get instance dimensions
		 */
		public function get_instance_width():Number{
			return this.width;
		}
		
		/*------------------------------------------------------------
		SETTER METHODS - PARAMETERS
		------------------------------------------------------------*/
		/**
		 * Set properties
		 */
		private function set_properties(obj:Object, param:Object):void{
			for(var key:* in param){
				//set wrapper property (Label or TextInput)
				if(obj.hasOwnProperty(key)){
					if(key == 'restrict'){
						obj.restrict = get_restrictions(param[key]);
					}else{
						obj[key] = param[key];
					}
				}
				//set internal TextField property, too!
				if(obj.textField.hasOwnProperty(key)){
					if(key == 'restrict'){
						obj.textField.restrict = get_restrictions(param[key]);
					}else{
						obj.textField[key] = param[key];
					}
				}
			}//end for
		}
		
		/**
		 * Set format
		 */
		private function set_format(obj:Object, format:TextFormat):void{
			obj.textField.defaultTextFormat = format;
			obj.textField.setTextFormat(format);
		}
		
		/**
		 * Set styles
		 */
		private function set_styles(obj:Object, styles:Array):void{
			for(var i:int = 0; i < styles.length; i++){
				obj.setStyle(styles[i][0], styles[i][1]);
			}
		}
		
		/**
		 * Set character restrictions
		 */
		private function get_restrictions(pattern:String):String{
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
				case 'decimal':
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
		SETTER METHODS - GEOMETRY AND DISPLAY
		------------------------------------------------------------*/
		/**
		 * Set initial geometry
		 */
		private function set_starting_position():void{
			//set label position
			_label.x = 0;
			_label.y = 0;
			
			//set TextInput width
			set_field_width();
			
			//set textInput position based on label width
			var w_label:Number = _label.getBounds(this).width;
			var obj:Object = {x:_label.x + w_label + 4, y:0};
			set_field_coords(obj);
		}
		
		/**
		 * Set field width. This method first computes the maximum
		 * number of visible characters, i.e. the smaller of either
		 * the textInput's internal textField maxChar property or 20 
		 * (35 for emails). The method then creates a text string to
		 * that length, computes the width and sets both the TextInput
		 * and the internal TextField to that width. Then the method
		 * resets the autoSize property to NONE to fix the size (the
		 * containing Sprite has now lost its default 100 x 100 size),
		 * and resets the text string to null.
		 */
		private function set_field_width():void{
			//set the number of visible characters
			var n:int = _field.maxChars;
			if(_field.name.toLowerCase().indexOf('email') != -1){
				n = Math.min(_field.maxChars, 30);
			}else{
				n = Math.min(_field.maxChars, 20);
			}
			
			//put any existing text in a temporary variable
			var str:String = _field.text;
			
			//compute width based on temporary text
			_field.text = Common.str_repeat('x', n);
			var w_field:Number = _field.getBounds(this).width;
			_field.textField.width = w_field;
			_field.width = w_field;
			
			//set autoSize property to NONE to fields won't resize back
			_field.textField.autoSize = TextFieldAutoSize.NONE;
			
			//replace text with original
			_field.text = str;
		}
		
		/**
		 * Sets label position
		 */
		public function set_label_coords(obj:Object):void{
			_label.x		= obj.x;
			_label.y		= obj.y;
			if(obj.width != undefined){
				_label.width = obj.width;
			}
			if(obj.height != undefined){
				_label.height = obj.height;
			}
		}
		
		/**
		 * Sets field position
		 */
		public function set_field_coords(obj:Object):void{
			_field.x = obj.x;
			_field.y = obj.y;
		}
		
		/**
		 * Set the caret insertion point to the first character
		 */
		public function set_caret_index():void{
			_field.setSelection(0, 0);
		}
		
		/*------------------------------------------------------------
		LISTENER METHODS
		------------------------------------------------------------*/
		/**
		 * Handles on change
		 */
		private function on_change_handler(e:Event):void{
			//do something here
		}
		
		/**
		 * On gaining focus handler
		 */
		private function on_focus_in_handler(e:FocusEvent):void{
			set_caret_index();
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