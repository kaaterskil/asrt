/**
 * Radio_button.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080121
 * @package com.kaaterskil.utilities
 */

package com.kaaterskil.utilities{
	import fl.controls.*;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.*;
	import flash.geom.Rectangle;
	
	public class Radio_button extends Sprite{
		/**
		 * Display objects
		 */
		public var _field:RadioButton;
		
		/**
		 * The form column
		 */
		public var _column:Number;
		
		/**
		 * Tests whether the field is required for validation
		 */
		public var _required:Boolean;
		
		/**
		 * On losing focus param
		 */
		public var _on_focus_out:String;
		
		/**
		 * The radio button element number
		 */
		private var _element:int;
		
		/**
		 * The original TextFormat color
		 */
		private var _color:Number;
		
		/*------------------------------------------------------------
		CREATION METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Radio_button(obj:Object, element:int):void{
			init(obj, element);
		}
		
		/**
		 * Initialization.Loops through all the parameters passed to
		 * the constructor and sets the appropriate property.
		 */
		private function init(obj:Object, element:int):void{
			_element	= element;
			_column		= obj.column != undefined ? obj.column : 0;
			_required	= obj.required != undefined ? obj.required : false;
			_on_focus_out	= obj.on_focus_out != undefined ? obj.on_focus_out : '';
			
			//append the element number to the name
			//this will enable the Flash_form tracker to get
			//and clear values.
			this.name	= obj.field_name + '_' + _element;
			
			set_field(obj.field_params);
		}
		
		/**
		 * Set field parameters
		 */
		private function set_field(obj:Object):void{
			_field = new RadioButton();
			_field.name = 'rb_' + this.name;
			
			if(obj.props != undefined){
				set_properties(obj.props);
			}
			if(obj.format != undefined){
				set_format(obj.format);
			}
			if(obj.styles != undefined){
				set_styles(obj.styles);
			}
			//set textfield properties
			if(obj.props.autoSize != undefined){
				_field.textField.autoSize = obj.props.autoSize;
			}else{
				_field.textField.autoSize = TextFieldAutoSize.LEFT;
			}
			if(obj.props.wordWrap != undefined){
				_field.textField.wordWrap = obj.props.wordWrap;
			}else{
				_field.textField.wordWrap = false;
			}
			
			//get default color
			var format:Object = _field.getStyle('textFormat');
			_color = format.color;
			
			//set listeners
			_field.addEventListener(MouseEvent.CLICK, click_handler);
			_field.addEventListener(Event.CHANGE, change_handler);
			addChild(_field);
		}
		
		/**
		 * Set properties
		 */
		private function set_properties(obj:Object):void{
			for(var key:* in obj){
				if(_field.hasOwnProperty(key)){
					if(key == 'selected' && _element == 0){
						//ensure that the first radio button element is selected
						_field[key] = true;
					}else if(key == 'tabIndex'){
						//set the tab index based on the element number
						_field[key] = _element + 1;
					}else{
						_field[key] = obj[key];
					}
				}
			}//end for
		}
		
		/**
		 * Set text format
		 */
		private function set_format(format:TextFormat):void{
			_field.textField.defaultTextFormat = format;
			_field.textField.setTextFormat(format);
		}
		
		/**
		 * Set styles
		 */
		private function set_styles(styles:Array):void{
			for(var i:int = 0; i < styles.length; i++){
				_field.setStyle(styles[i][0], styles[i][1]);
			}
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Get instance dimensions
		 */
		public function get_instance_dims():Rectangle{
			return this.getBounds(this.parent);
		}
		
		/**
		 * Sets field position
		 */
		public function set_field_coords(obj:Object):void{
			_field.x = obj.x;
			_field.y = obj.y;
			if(obj.width != null){
				_field.width = obj.width;
			}
			if(obj.height != null){
				_field.height = obj.height;
			}
		}
		
		/**
		 * Resets the text color
		 * @param t		Highlight (true) or default (false)
		 */
		public function highlight_text(t:Boolean = false):void{
			var format:TextFormat = _field.textField.getTextFormat();
			if(t){
				format.color = 0xFF0000;
			}else{
				format.color = _color;
			}
			_field.setStyle('textFormat', format);
		}
		
		/*------------------------------------------------------------
		LISTENER METHODS
		------------------------------------------------------------*/
		/**
		 * Handles click events
		 */
		private function click_handler(e:MouseEvent):void{
			if(_on_focus_out != ''){
				dispatchEvent(new Event(_on_focus_out));
			}
		}
		
		/**
		 * Handles change events
		 */
		private function change_handler(e:Event):void{
			//do something here
		}
	}
}