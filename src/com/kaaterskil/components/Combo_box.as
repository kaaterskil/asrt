/**
 * Combo_box.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080127
 * @package com.kaaterskil.components
 */

package com.kaaterskil.components{
	import fl.controls.*;
	import fl.data.DataProvider;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.text.*;
	
	import com.kaaterskil.utilities.Common;
	
	public class Combo_box extends Sprite{
		/**
		 * Display objects
		 */
		 public var _field:ComboBox;
		 public var _label:Label;
		
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
		public function Combo_box(obj:Object):void{
			init(obj);
		}
		
		/**
		 * Initialization.Loops through allt he parameters passed to
		 * the constructor and sets the appropriate property.
		 */
		private function init(obj:Object):void{
			this.name		= obj.field_name;
			this.x			= obj.x != undefined ? obj.x : 0;
			this.y			= obj.y != undefined ? obj.y : 0;
			_column 		= obj.column != undefined ? obj.column : 0;
			_required		= obj.required != undefined ? obj.required : false;
			_on_focus_out	= '';
			
			set_label(obj.label_params);
			set_field(obj.field_params);
			set_field_width();
			set_starting_position();
			_field.selectedIndex = -1;
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
			//set text field properties
			if(obj.props.autoSize != undefined){
				_label.textField.autoSize = obj.props.autoSize;
			}else{
				_label.textField.autoSize = TextFieldAutoSize.LEFT;
			}
			if(obj.props.wordWrap != undefined){
				_label.textField.wordWrap = obj.props.wordWrap;
			}else{
				_label.wordWrap = false;
			}
			addChild(_label);
		}
		
		/**
		 * Set field parameters
		 */
		private function set_field(obj:Object):void{
			_field = new ComboBox();
			_field.name = 'cb_' + this.name;
			
			//set data
			if(obj.dp != null){
				set_data_provider(obj.dp);
			}
			if(obj.data_items != null){
				add_data(obj.data_items);
			}
			
			//set properties
			if(obj.props != undefined){
				set_properties(_field, obj.props);
			}
			if(obj.format != undefined){
				set_format(_field, obj.format);
			}
			if(obj.styles != undefined){
				set_styles(_field, obj.styles);
			}
			if(obj.on_change != undefined){
				_field.addEventListener(Event.CHANGE, on_change_handler);
			}
			
			//set text field properties
			if(obj.props.autoSize != undefined){
				_field.textField.textField.autoSize = obj.props.autoSize;
			}else{
				_field.textField.textField.autoSize = TextFieldAutoSize.LEFT;
			}
			if(obj.props.wordWrap != undefined){
				_field.textField.textField.wordWrap = obj.props.wordWrap;
			}else{
				_field.textField.textField.wordWrap = false;
			}
			//set drop-down width
			
			_field.selectedIndex = -1;
			
			_field.addEventListener(FocusEvent.FOCUS_OUT, on_losing_focus_handler);
			addChild(_field);
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Sets initial positions
		 */
		private function set_starting_position():void{
			_label.x = 0;
			_label.y = 0;
			
			var metrics:TextLineMetrics = _label.textField.getLineMetrics(0);
			var w_label:Number = metrics.width > 0 ? metrics.width + 4 : 0;
			var obj:Object = {x:_label.x + w_label, y:0};
			set_field_coords(obj);
		}
		/**
		 * Gets label width
		 */
		public function get_label_metrics():TextLineMetrics{
			return _label.textField.getLineMetrics(0);
		}
		
		/**
		 * Gets label width
		 */
		public function get_label_width():Number{
			return _label.width;
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
		public function get_instance_dims():Rectangle{
			return this.getBounds(this.parent);
		}
		
		/**
		 * Sets label position
		 */
		public function set_label_coords(obj:Object):void{
			_label.x		= obj.x;
			_label.y		= obj.y;
			if(obj.width != null){
				_label.width = obj.width;
			}
			if(obj.height != null){
				_label.height = obj.height;
			}
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
		 * Sets field width
		 */
		private function set_field_width():void{
			var w_test:Number = 0;
			
			//get the prompt width
			_field.selectedIndex = -1
			_field.drawNow();
			var w_prompt:Number = _field.textField.textWidth;
			w_test = Math.max(w_test, w_prompt);
			
			//loop through all the data and compute the greatest width
			for(var i:int = 0; i < _field.length; i++){
				_field.selectedIndex = i;
				_field.drawNow();
				var w_item:Number = _field.textField.textWidth;
				w_test = Math.max(w_test, w_item);
			}
			
			//set the widths
			_field.dropdownWidth = w_test + 30;
			_field.width = w_test + 30;
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Set data provider
		 */
		private function set_data_provider(dp:DataProvider):void{
			_field.dataProvider = dp;
		}
		
		/**
		 * Add line items
		 */
		private function add_data(arr:Array):void{
			for(var i:int = 0; i < arr.length; i++){
				_field.addItem({label:arr[i][0], data:arr[i][1]});
			}
		}
		
		/**
		 * Set properties
		 */
		private function set_properties(obj:Object, param:Object):void{
			for(var key:* in param){
				if(obj.hasOwnProperty(key)){
					if(key == 'on_focus_out'){
						//do something here
					}else{
						obj[key] = param[key];
					}
				}
			}
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
		
		/*------------------------------------------------------------
		LISTENER METHODS
		------------------------------------------------------------*/
		/**
		 * Handles click events
		 */
		private function on_change_handler(e:MouseEvent):void{
			//do something here
		}
		
		/**
		 * Handles losing focus
		 */
		private function on_losing_focus_handler(e:FocusEvent):void{
			//do something here
		}
	}
}