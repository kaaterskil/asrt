/**
 * Alert_window.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080111
 * @package com.kaaterskil.utilities
 */

/**
 * This class creates a modal window equivalent to alert the
 * user to a condition or ask for confirmation or input. The
 * window is positioned in the center of the stage and fades in.
 *
 * @params	Requires an object with the following parameters:
 *				headline_text:String
 *				body_text:String
 *				is_confirm:Boolean
 *				confirm_list:Array of field names (Optional)
 */
 
package com.kaaterskil.utilities{
	import fl.controls.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	import com.kaaterskil.components.*;
	
	dynamic public class Alert_window extends Sprite{
		/**
		 * Containers
		 */
		private var _container:Sprite;
		private var _form_container:Sprite;
		
		/**
		 * Trackers
		 */
		private var _params:Object;
		public var _fields:Array;
		
		/**
		 * Parameters
		 */
		private var _headline:TextField;
		private var _message_body:TextField;
		private var _ok_btn:Button;
		private var _other_btn:Button;
		private var _cancel_btn:Button;
		private var _radio_element:int;
		
		/**
		 * User defined (nonvisible) properties
		 */
		public var _props:Object;
		
		/**
		 * Text formats
		 */
		private var _format_headline:TextFormat;
		private var _format_body:TextFormat;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 * @param obj	An object containing the alert parameters.
		 */
		public function Alert_window(obj:Object, props:Object = undefined):void{
			_params = obj;
			_props = props;
			this.alpha = 0;
			init();
		}
		
		/**
		 * Initialization
		 */
		private function init():void{
			set_formats();
			create_container();
			draw_body();
			draw_background();
			fade_in();
		}
		
		/**
		 * Draws the body for the alert. The coordinate object's 
		 * values are within the inner_container coordinate system.
		 */
		private function draw_body():void{
			draw_headline();
			draw_message_body();
			if(_params.window_type != 'Alert'){
				draw_form();
			}
			draw_ok_btn();
			if(_props != null){
				draw_other_btn();
			}
			if(_params.window_type != 'Alert'){
				draw_cancel_btn();
			}
		}
		
		/**
		 * Draws confirm/prompt form
		 */
		private function draw_form():void{
			draw_form_container();
			
			_fields = new Array();
			_radio_element = 0;
			for(var i:int = 0; i < _params.form_items.length; i++){
				draw_confirm_item(_params.form_items[i]);
			}
			position_form_fields();
		}
		
		/**
		 * Fade in the window
		 */
		private function fade_in():void{
			var tween:Tween = new Tween(this, 'alpha', None.easeOut, 0, 1, 4);
		}
		
		/*------------------------------------------------------------
		DRAWING METHODS
		------------------------------------------------------------*/
		/**
		 * Create container
		 */
		private function create_container():void{
			_container = new Sprite();
			_container.name = 'alert_container';
			addChild(_container);
		}
		
		/**
		 * Draw background
		 */
		private function draw_background():void{
			var h:Number = _ok_btn.y + _ok_btn.height + 20;
			
			var ground:Shape = new Shape();
			ground.name = 'alert_background';
			ground.graphics.beginFill(0xffffff, 1);
			ground.graphics.lineStyle(3, 0x339900, 1);
			ground.graphics.drawRect(0, 0, 400, h);
			ground.graphics.endFill();
			_container.addChild(ground);
			_container.swapChildrenAt(0, _container.numChildren - 1);
		}
		
		/**
		 * Draws headline
		 */
		private function draw_headline():void{
			var params:Object = {format:_format_headline,
								 name:'headline',
								 text:_params.headline_text,
								 x:20,
								 y:20,
								 width:360
								 };
			draw_text_field(params);
		}
		
		/**
		 * Draws the message body
		 */
		private function draw_message_body():void{
			var coords:Rectangle = get_coords('headline');
			var x_coord:Number = coords.x + 4;
			var y_coord:Number = coords.y + coords.height + 4
			
			var params:Object = {format:_format_body,
								 name:'message_body',
								 htmlText:_params.body_text,
								 x:x_coord,
								 y:y_coord,
								 width:360
								 };
			draw_text_field(params);
		}
		
		/**
		 * Draw form container
		 */
		private function draw_form_container():void{
			var coords:Rectangle = get_coords('message_body');
			var x_coord:Number = coords.x;
			var y_coord:Number = coords.y + coords.height + 4;
			
			_form_container = new Sprite();
			_form_container.name = 'form_container';
			_form_container.x = x_coord;
			_form_container.y = y_coord;
			_container.addChild(_form_container);
		}
		
		/**
		 * Draw confirm or prompt item
		 * @param obj	An object with the following properties:
		 *				type	The type of item
		 *				prams	The format and value parameters
		 *						for the class of item
		 */
		private function draw_confirm_item(obj:Object):void{
			var form_type:String	= obj.form_type;
			
			switch(form_type){
				case 'confirm':
					var confirm_obj:Text_field = new Text_field(obj);
					_fields.push(confirm_obj);
					break;
				case 'text':
					var txt_obj:Text_input = new Text_input(obj);
					_fields.push(txt_obj);
					break;
				case 'radio_button':
					var radio_obj:Radio_button = new Radio_button(obj, _radio_element);
					_fields.push(radio_obj);
					_radio_element++;
					break;
				case 'check_box':
					//NEED CODE HERE
					break;
			}
		}
		
		/**
		 * Align form fields
		 */
		private function position_form_fields():void{
			//get maximum label width
			var w_label_test:Number = 0;
			for(var i:int = 0; i < _fields.length; i++){
				if(_fields[i].hasOwnProperty('_label')){
					var m:TextLineMetrics = _fields[i].get_label_metrics();
					var w_label:Number = m.width;
					w_label_test = Math.max(w_label_test, w_label);
				}
			}
			
			//set geometry
			var x_coord:Number = 0;
			var y_coord:Number = 0;
			for(i = 0; i < _fields.length; i++){
				//add to display list
				_form_container.addChild(_fields[i]);
				
				//set positiona nd label width
				_fields[i].x = x_coord;
				_fields[i].y = y_coord;
				if(_fields[i].hasOwnProperty('_label')){
					//set label dimensions according to local coordinates
					var obj1:Object = {x:0, y:0, width:w_label_test};
					_fields[i].set_label_coords(obj1);
					
					//set field position according to local coordinates
					var obj2:Object = {x:w_label_test + 10, y:0};
					_fields[i].set_field_coords(obj2);
				}
				
				//increment y coordinate
				if(_fields[i].hasOwnProperty('_field')){
					y_coord += _fields[i]._field.height + 4;
				}else{
					y_coord += _fields[i].height + 4;
				}
			}
		}
		
		/**
		 * Draws OK button
		 * @param obj	An object with positioning parameters.
		 */
		private function draw_ok_btn():void{
			if(_params.window_type != 'Alert' && _form_container != null){
				var coords:Rectangle = get_coords('form_container');
			}else{
				coords = get_coords('message_body');
			}
			var x_coord:Number = 280;
			//var y_coord:Number = 160;
			var y_coord:Number = coords.y + coords.height + 10;
			
			_ok_btn = new Button();
			_ok_btn.x		= x_coord;
			_ok_btn.y		= y_coord;
			_ok_btn.label	= 'OK';
			_ok_btn.name	= 'ok_btn';
			_ok_btn.width	= 80;
			_ok_btn.addEventListener(MouseEvent.CLICK, ok_handler);
			_container.addChild(_ok_btn);
		}
		
		/**
		 * Draws 'other' button
		 * NOTE: The button text is from the 'props' property
		 */
		private function draw_other_btn():void{
			var x_coord:Number = _ok_btn.x - 110;
			var y_coord:Number = _ok_btn.y;
			
			_other_btn = new Button();
			_other_btn.x		= x_coord;
			_other_btn.y		= y_coord;
			_other_btn.label	= this._props.button_txt;
			_other_btn.name	= 'other_btn';
			_other_btn.width	= 100;
			_other_btn.addEventListener(MouseEvent.CLICK, other_handler);
			_container.addChild(_other_btn);
		}
		
		/**
		 * Draws cancel button
		 * @param obj	An object with positioning parameters.
		 */
		private function draw_cancel_btn():void{
			var x_coord:Number = _ok_btn.x - 90;
			if(_other_btn != null){
				x_coord = _other_btn.x - 90;
			}
			var y_coord:Number = _ok_btn.y;
			
			_cancel_btn = new Button();
			_cancel_btn.x		= x_coord;
			_cancel_btn.y		= y_coord;
			_cancel_btn.label	= 'Cancel';
			_cancel_btn.name	= 'cancel_btn';
			_cancel_btn.width	= 80;
			_cancel_btn.addEventListener(MouseEvent.CLICK, cancel_handler);
			_container.addChild(_cancel_btn);
		}
		
		/*------------------------------------------------------------
		LISTENER METHODS
		------------------------------------------------------------*/
		/**
		 * Handles clicks to the OK button
		 */
		private function ok_handler(e:MouseEvent):void{
			dispatchEvent(new Event('alert_confirmed'));
		}
		
		/**
		 * Handles clicks to the Other button
		 */
		private function other_handler(e:MouseEvent):void{
			dispatchEvent(new Event('alert_ignored'));
		}
		
		/**
		 * Handles clicks to the Cancel button
		 */
		private function cancel_handler(e:MouseEvent):void{
			dispatchEvent(new Event('alert_cancelled'));
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		private function set_formats():void{
			_format_body = new TextFormat();
			_format_body.font	= 'Tahoma';
			_format_body.size	= 11;
			_format_body.color	= 0x000000;
			
			_format_headline = new TextFormat();
			_format_headline.font	= 'Gill Sans MT Condensed';
			_format_headline.size	= 20;
			_format_headline.color	= 0x000000;
		}
		
		/**
		 * Draws text field.
		 * @param obj	Object containing field parameters.
		 */
		private function draw_text_field(obj:Object):void{
			var txt:TextField = new TextField();
			txt.type				= TextFieldType.DYNAMIC;
			txt.antiAliasType		= AntiAliasType.ADVANCED,
			txt.autoSize			= TextFieldAutoSize.LEFT;
			txt.background			= true;
			txt.defaultTextFormat	= obj.format;	
			txt.embedFonts			= true;
			txt.multiline			= true;
			txt.name				= obj.name;
			if(obj.text != null){
				txt.text = obj.text;
			}else if(obj.htmlText != null){
				txt.htmlText = obj.htmlText;
			}
			txt.wordWrap			= true;
			txt.width				= obj.width;
			txt.x					= obj.x;
			txt.y					= obj.y;
			txt.setTextFormat(obj.format);
			_container.addChild(txt);
		}
		
		/**
		 * Updates the coordinate tracker
		 * @param str	The name of the display object to take the 
		 *				coordinates from. If the parameter is an empty
		 *				string, then the return value is the highest
		 *				values of all the existing display objects.
		 */
		private function get_coords(str:String):Rectangle{
			var r:Rectangle;
			if(str != ''){
				for(var i:int = 0; i < _container.numChildren; i++){
					var child = _container.getChildAt(i);
					if(child.name == str){
						r = child.getBounds(_container);
						break;
					}
				}
			}else{
				var x_test:Number = 0;
				var y_test:Number = 0;
				var w_test:Number = 0;
				var h_test:Number = 0;
				for(i = 0; i < _container.numChildren; i++){
					child = _container.getChildAt(i);
					x_test = child.x > x_test ? child.x : x_test;
					y_test = child.y > y_test ? child.y : y_test;
					w_test = child.width > w_test ? child.width : w_test;
					h_test = child.height > h_test ? child.height : h_test;
					r = new Rectangle(x_test, y_test, w_test, h_test);
				}
			}
			return r;
		}
	}
}