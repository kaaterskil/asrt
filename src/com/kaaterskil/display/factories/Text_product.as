/**
 * Text_product.as
 *
 * Class definition
 * @description	A factory method product.
 * @inheritance	Text_product -> ADisplay -> Sprite
 * @interface	IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080417
 * @package		com.kaaterskil.display.factories
 */

package com.kaaterskil.display.factories{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.geom.*;
	
	import com.kaaterskil.utilities.Common;
	
	public class Text_product extends ADisplay{
		/**
		 * Display objects
		 */
		private var _field:TextField;
		
		/**
		 * Parameters
		 */
		private var _on_focus_out:String;
		Font_embedder;
		
		/**
		 * Constructor
		 */
		public function Text_product():void{}
		
		/*------------------------------------------------------------
		GETTER / SETTER METHODS
		------------------------------------------------------------*/
		/**
		 * Gets any TextField property
		 */
		public function get_field_property(prop:String):*{
			if(_field.hasOwnProperty(prop)){
				return _field[prop];
			}
			return null;
		}
		
		/**
		 * Gets any Text_field property
		 */
		public function get_property(prop:String):*{
			if(this.hasOwnProperty(prop)){
				return this[prop];
			}
			return null;
		}
		
		/**
		 * Get line metrics
		 */
		public function get_line_metrics(i:int):TextLineMetrics{
			return _field.getLineMetrics(i);
		}
		
		/**
		 * Get line offset
		 */
		public function get_line_offset(i:int):int{
			return _field.getLineOffset(i);
		}
		
		/**
		 * Get the 1-based line index of the last text line
		 */
		public function get last_line_index():int{
			return _field.getLineIndexOfChar(_field.length - 1) + 1;
		}
		
		/**
		 * Set name
		 */
		public function set_name(str:String):void{
			this.name = str;
		}
		
		/**
		 * Set text format (for appends)
		 */
		public function reset_format(format, start_index:int, end_index:int = -1):void{
			_field.setTextFormat(format, start_index, end_index);
		}
		
		/**
		 * Append text
		 */
		public function append(str:String):void{
			_field.appendText(str);
		}
		
		/**
		 * Replace text
		 */
		public function replace_text(start_index:int, end_index:int, str:String):void{
			_field.replaceText(start_index, end_index, str);
		}
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Initialization
		 */
		override public function init(obj:Object, container:DisplayObjectContainer = null):void{
			this.name = obj.name;
			if(obj.hasOwnProperty('on_focus_out')){
				_on_focus_out = obj.on_focus_out;
			}
			
			draw_field(obj.prams);
			if(container != null){
				container.addChild(this);
			}
			
			var point:Point = new Point();
			if(obj.x != undefined && obj.y != undefined){
				point = new Point(obj.x, obj.y);
			}
			set_position(point);
		}
		
		/**
		 * Set position
		 */
		override public function set_position(point:Point):void{
			this.x = point.x;
			this.y = point.y;
		}
		
		/**
		 * Returns layout position on screen
		 */
		public function get_layout():int{
			return -1;
		}
		
		/*------------------------------------------------------------
		DRAWING METHODS
		------------------------------------------------------------*/
		/**
		 * Set parameters
		 */
		private function draw_field(prams:Object):void{
			_field		= new TextField();
			_field.name	= 'tf_' + this.name;
			
			if(prams.props != undefined){
				set_properties(prams.props);
			}
			if(prams.format != undefined){
				set_format(prams.format);
			}
			if(prams.hasOwnProperty('on_change')){
				_field.addEventListener(Event.CHANGE, on_change_handler);
			}
			_field.addEventListener(FocusEvent.FOCUS_OUT, on_focus_out_handler);
			addChild(_field);
		}
				
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Set properties
		 */
		private function set_properties(prams:Object):void{
			for(var prop:* in prams){
				if(_field.hasOwnProperty(prop)){
					if(prop == 'restrict'){
						_field.restrict = set_restrictions(prams[prop]);
					}else{
						_field[prop] = prams[prop];
					}
				}
			}
		}
		
		/**
		 * Set format
		 */
		private function set_format(tf:TextFormat):void{
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
		EVENT HANDLER METHODS
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