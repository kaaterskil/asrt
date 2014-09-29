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
	
	public class Alert_window extends Sprite{
		/**
		 * Containers
		 */
		private var _container:Sprite;
		
		/**
		 * Trackers
		 */
		private var _params:Object;
		private var _fields:Array;
		
		private var _headline:TextField;
		private var _message_body:TextField;
		private var _ok_btn:Button;
		private var _cancel_btn:Button;
		
		public var props:Object;
		
		/**
		 * Text formats
		 */
		private var _format_label:TextFormat;
		private var _format_field:TextFormat;
		private var _format_body:TextFormat;
		private var _format_headline:TextFormat;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 * @param obj	An object containing the alert parameters.
		 */
		public function Alert_window(obj:Object):void{
			_params = obj;
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
			if(_params.is_confirm){
				for(var i:int = 0; i < _params.confirm_list.length; i++){
					draw_confirm(_params.confirm_list[i]);
				}
			}
			draw_ok_btn();
			if(_params.window_type != 'Alert'){
				draw_cancel_btn();
			}
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
			addChild(_container);
		}
		
		/**
		 * Draw background
		 */
		private function draw_background():void{
			var h:Number = _ok_btn.y + _ok_btn.height + 20;
			
			var ground:Shape = new Shape();
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
			var coords = get_coords('headline');
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
		 * Draws confirmation input fields
		 */
		private function draw_confirm(obj:Object):void{
			draw_label(obj);
			draw_field(obj);
		}
		
		/**
		 * Draws confirmation label for an input field
		 * @param obj	An object with parameter properties
		 */
		private function draw_label(obj:Object):void{
			var coords = get_coords('');
			var x_coord:Number = 0;
			var y_coord:Number = coords.y + coords.height + 4;
			
			var params:Object = {format:_format_label,
								 name:obj.name + '_lbl',
								 text:obj.name + ':',
								 x:x_coord,
								 y:y_coord,
								 width:150
								 };
			draw_text_field(params);
		}
		
		/**
		 * Draws confirmation input field
		 * @param obj	An object with parameter properties
		 */
		private function draw_field(obj):void{
			var coords = get_coords(obj.name + '_lbl');
			var x_coord:Number = coords.x + coords.width + 4;
			var y_coord:Number = coords.y;
			
			var params:Object = {format:_format_field,
								 name:obj.name,
								 text:'',
								 x:x_coord,
								 y:y_coord,
								 width:200
								 };
			draw_input_field(params);
		}
		
		/**
		 * Draws OK button
		 * @param obj	An object with positioning parameters.
		 */
		private function draw_ok_btn():void{
			if(_params.is_confirm){
				var obj:Object = _params.confirm_list[_params.confirm_list.length - 1];
				var coords:Rectangle = get_coords(obj.name);
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
		 * Draws cancel button
		 * @param obj	An object with positioning parameters.
		 */
		private function draw_cancel_btn():void{
			var x_coord:Number = _ok_btn.x - 90;
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
			e.target.removeEventListener(MouseEvent.CLICK, ok_handler);
			dispatchEvent(new Event('alert_confirmed'));
		}
		
		/**
		 * Handles clicks to the Cancel button
		 */
		private function cancel_handler(e:MouseEvent):void{
			e.target.removeEventListener(MouseEvent.CLICK, cancel_handler);
			dispatchEvent(new Event('alert_cancelled'));
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		private function set_formats():void{
			_format_label = new TextFormat();
			_format_label.font	= 'Tahoma';
			_format_label.size	= 11;
			_format_label.color = 0x666666;
			
			_format_field = new TextFormat();
			_format_field.font			= 'Courier New';
			_format_field.size			= 12;
			_format_field.color			= 0x000000;
			_format_field.leftMargin	= 2;
			_format_field.leading		= 0;
			
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
		 * Draws text input field
		 */
		private function draw_input_field(obj:Object):void{
			var txt:TextField = new TextField();
			txt.type				= TextFieldType.INPUT;
			txt.antiAliasType		= AntiAliasType.ADVANCED,
			txt.autoSize			= TextFieldAutoSize.NONE;
			txt.border				= true;
			txt.borderColor			= 0x999999;
			txt.background			= true;
			txt.backgroundColor		= 0xFFFFFF;
			txt.multiline			= false;
			txt.defaultTextFormat	= obj.format;	
			txt.embedFonts			= true;
			txt.name				= obj.name;
			txt.text				= obj.text;
			txt.wordWrap			= false;
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