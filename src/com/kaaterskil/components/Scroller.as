/**
 * Scroller.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080209
 * @package com.kaaterskil.components
 */
 
package com.kaaterskil.components{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class Scroller extends Sprite{
		/**
		 * Constants
		 */
		private static const SCROLL_DISTANCE = 15;
		
		/**
		 * Containers
		 */
		private var _container:Sprite;
		private var _track:Shape;
		private var _handle:Sprite;
		private var _up_arrow:Sprite;
		private var _dn_arrow:Sprite;
		private var _story_container:Sprite;
		
		/**
		 * Trackers
		 */
		private var _timer:Timer;
		
		/**
		 * Parameters
		 */
		private var _track_height:Number;
		private var _handle_height:Number;
		private var _avail_height:Number;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 * @param obj	An object with sizing information.
		 */
		public function Scroller(obj:Object):void{
			init(obj);
		}
		
		/**
		 * Initialization
		 */
		private function init(obj:Object):void{
			_track_height	= obj.track_height - 30;	//subtract up and down arrows
			_handle_height	= obj.handle_height;
			_avail_height	= _track_height - _handle_height;
			
			this.x		= obj.x;
			this.y		= obj.y;
			this.name	= 'scroller';
			
			create_container();
			draw_track();
			draw_handle();
			draw_up_arrow();
			draw_down_arrow();
		}
		
		/*------------------------------------------------------------
		DRAWING METHODS
		------------------------------------------------------------*/
		/**
		 * Create container
		 */
		private function create_container():void{
			_container = new Sprite();
			_container.name = 'scroller_container';
			addChild(_container);
		}
		
		/**
		 * Draw scroll track
		 */
		private function draw_track():void{
			_track = new Shape();
			_track.graphics.clear();
			_track.graphics.lineStyle(1, 0xeeeeee, 1);
			_track.graphics.beginFill(0xeeeeee, 1);
			_track.graphics.drawRect(0, 15, 15, _track_height);
			_track.graphics.endFill();
			_container.addChild(_track);
		}
		
		/**
		 * Draw scroll handle
		 */
		private function draw_handle():void{
			var center:Number = _handle_height / 2;
			
			_handle = new Sprite();
			_handle.x = 0;
			_handle.y = 15;
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, handle_down_handler);
			_handle.addEventListener(MouseEvent.MOUSE_UP, handle_up_handler);
			_handle.addEventListener(MouseEvent.MOUSE_OUT, handle_out_handler);
			_handle.addEventListener(MouseEvent.ROLL_OVER, handle_over_handler);
			_handle.addEventListener(MouseEvent.MOUSE_MOVE, handle_move_handler);
			
			//draw button
			var button:Shape = new Shape();
			button.graphics.clear();
			button.graphics.lineStyle(1, 0xcccccc, 1);
			button.graphics.beginFill(0xcccccc, 1);
			button.graphics.drawRect(0, 0, 15, _handle_height);
			button.graphics.endFill();
			_handle.addChild(button);
			
			//draw highlights and shading
			var light:Shape = new Shape();
			light.graphics.clear();
			light.graphics.lineStyle(1, 0xffffff, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER, 3);
			light.graphics.moveTo(1, _handle_height - 2);
			light.graphics.lineTo(1, 1);
			light.graphics.lineTo(13, 1);
			_handle.addChild(light);
			
			var dark:Shape = new Shape();
			dark.graphics.clear();
			dark.graphics.lineStyle(1, 0x999999, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER, 3);
			dark.graphics.moveTo(1, _handle_height - 1);
			dark.graphics.lineTo(14, _handle_height - 1);
			dark.graphics.lineTo(14, 1);
			_handle.addChild(dark);
			
			var darker:Shape = new Shape();
			darker.graphics.clear();
			darker.graphics.lineStyle(1, 0x666666, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER, 3);
			darker.graphics.moveTo(0, _handle_height);
			darker.graphics.lineTo(15, _handle_height);
			darker.graphics.lineTo(15, 0);
			_handle.addChild(darker);
			
			_container.addChild(_handle);
		}
		
		/**
		 * Draw up arrow
		 */
		private function draw_up_arrow():void{
			_up_arrow = new Sprite();
			_up_arrow.x = 0;
			_up_arrow.y = 0;
			_up_arrow.name = 'up_arrow';
			_up_arrow.addEventListener(MouseEvent.MOUSE_DOWN, arrow_down_handler);
			_up_arrow.addEventListener(MouseEvent.MOUSE_UP, arrow_up_handler);
			_up_arrow.addEventListener(MouseEvent.CLICK, arrow_click_handler);
			
			var square1:Shape = new Shape();
			square1.graphics.clear();
			square1.graphics.lineStyle(0, 0xcccccc, 0);
			square1.graphics.beginFill(0xcccccc, 1);
			square1.graphics.drawRect(0, 0, 15, 15);
			_up_arrow.addChild(square1);
			
			var light1:Shape = new Shape();
			light1.graphics.clear();
			light1.graphics.lineStyle(1, 0xffffff, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER, 3);
			light1.graphics.moveTo(1, 13);
			light1.graphics.lineTo(1, 1);
			light1.graphics.lineTo(13, 1);
			_up_arrow.addChild(light1);
			
			var dark1:Shape = new Shape();
			dark1.graphics.clear();
			dark1.graphics.lineStyle(1, 0x999999, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER, 3);
			dark1.graphics.moveTo(1, 14);
			dark1.graphics.lineTo(14, 14);
			dark1.graphics.lineTo(14, 1);
			_up_arrow.addChild(dark1);
			
			var darker1:Shape = new Shape();
			darker1.graphics.clear();
			darker1.graphics.lineStyle(1, 0x666666, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER, 3);
			darker1.graphics.moveTo(0, 15);
			darker1.graphics.lineTo(15, 15);
			darker1.graphics.lineTo(15, 0);
			_up_arrow.addChild(darker1);
			
			var triangle1:Shape = new Shape();
			triangle1.graphics.clear();
			triangle1.graphics.lineStyle(0, 0x000000, 0);
			triangle1.graphics.beginFill(0x000000, 1);
			triangle1.graphics.moveTo(4, 10);
			triangle1.graphics.lineTo(7, 6);
			triangle1.graphics.lineTo(11, 10);
			triangle1.graphics.lineTo(4, 10);
			triangle1.graphics.endFill();
			_up_arrow.addChild(triangle1);
			
			_container.addChild(_up_arrow);
		}
		
		/**
		 * Draw up arrow
		 */
		private function draw_down_arrow():void{
			var y_bottom:Number = _track_height + 15;
			
			_dn_arrow = new Sprite();
			_dn_arrow.x = 0;
			_dn_arrow.y = y_bottom;
			_dn_arrow.name = 'dn_arrow';
			_dn_arrow.addEventListener(MouseEvent.MOUSE_DOWN, arrow_down_handler);
			_dn_arrow.addEventListener(MouseEvent.MOUSE_UP, arrow_up_handler);
			_dn_arrow.addEventListener(MouseEvent.CLICK, arrow_click_handler);
			
			var square2:Shape = new Shape();
			square2.graphics.clear();
			square2.graphics.lineStyle(0, 0xcccccc, 0);
			square2.graphics.beginFill(0xcccccc, 1);
			square2.graphics.drawRect(0, 0, 15, 15);
			_dn_arrow.addChild(square2);
			
			var light2:Shape = new Shape();
			light2.graphics.clear();
			light2.graphics.lineStyle(1, 0xffffff, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER, 3);
			light2.graphics.moveTo(1, 13);
			light2.graphics.lineTo(1, 1);
			light2.graphics.lineTo(13, 1);
			_dn_arrow.addChild(light2);
			
			var dark2:Shape = new Shape();
			dark2.graphics.clear();
			dark2.graphics.lineStyle(1, 0x999999, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER, 3);
			dark2.graphics.moveTo(1, 14);
			dark2.graphics.lineTo(14, 14);
			dark2.graphics.lineTo(14, 1);
			_dn_arrow.addChild(dark2);
			
			var darker2:Shape = new Shape();
			darker2.graphics.clear();
			darker2.graphics.lineStyle(1, 0x666666, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER, 3);
			darker2.graphics.moveTo(0, 15);
			darker2.graphics.lineTo(15, 15);
			darker2.graphics.lineTo(15, 0);
			_dn_arrow.addChild(darker2);
			
			var triangle2:Shape = new Shape();
			triangle2.graphics.clear();
			triangle2.graphics.lineStyle(0, 0x000000, 0);
			triangle2.graphics.beginFill(0x000000, 1);
			triangle2.graphics.moveTo(4, 6);
			triangle2.graphics.lineTo(11, 6);
			triangle2.graphics.lineTo(7, 10);
			triangle2.graphics.lineTo(4, 6);
			triangle2.graphics.endFill();
			_dn_arrow.addChild(triangle2);
			
			_container.addChild(_dn_arrow);
		}
		
		/*------------------------------------------------------------
		LISTENER METHODS
		------------------------------------------------------------*/
		/**
		 * Mouse down handler
		 */
		private function handle_down_handler(e:MouseEvent):void{
			var bounds:Rectangle	= new Rectangle(0, 15, 0, _avail_height);
			e.target.startDrag(false, bounds);
		}
		
		/**
		 * Mouse up handler
		 */
		private function handle_up_handler(e:MouseEvent):void{
			e.target.stopDrag();
		}
		
		/**
		 * Mouse out handler
		 */
		private function handle_out_handler(e:MouseEvent):void{
			//e.target.stopDrag();
		}
		
		/**
		 * Mouse over handler
		 */
		private function handle_over_handler(e:MouseEvent):void{
			e.target.stopDrag();
		}
		
		/**
		 * Mouse move handler
		 */
		private function handle_move_handler(e:MouseEvent):void{
			if(_story_container == null){
				get_story_container();
			}
			var pct:Number		= (_handle.y - 15) / _avail_height;
			var y_start:Number	= _track_height + 30 - _story_container.height
			_story_container.y	= Math.round(y_start * pct);
			
			//test over-scroll condition
			if(_story_container.y > 0){
				_story_container.y = 0;
			}else if(_story_container.y < y_start){
				_story_container.y = y_start;
			}
		}
		
		/**
		 * Arrow down handler
		 */
		private function arrow_down_handler(e:MouseEvent):void{
			_timer = new Timer(30, 0);
			
			var dir:Boolean = e.target.name == 'up_arrow' ? true : false;
			if(dir){
				_timer.addEventListener(TimerEvent.TIMER, scroll_up);
			}else{
				_timer.addEventListener(TimerEvent.TIMER, scroll_down);
			}
			_timer.start();
		}
		
		/**
		 * Arrow up handler
		 */
		private function arrow_up_handler(e:MouseEvent):void{
			if(_timer != null){
				_timer.reset();
			}
		}
		
		/**
		 * Scroll up
		 */
		private function scroll_up(e:TimerEvent):void{
			if(_story_container == null){
				get_story_container();
			}
			
			var y_start:Number	= _track_height + 30 - _story_container.height;
			var y_new:Number	= _story_container.y + Scroller.SCROLL_DISTANCE;
			if(y_new < 0){
				_story_container.y = y_new;
				set_handle_coord();
			}else{
				_story_container.y = 0;
				_handle.y = 15;
				_timer.reset();
			}
		}
		
		/**
		 * Scroll down
		 */
		private function scroll_down(e:TimerEvent):void{
			if(_story_container == null){
				get_story_container();
			}
			
			var y_start:Number	= _track_height + 30 - _story_container.height;
			var y_new:Number	= _story_container.y - Scroller.SCROLL_DISTANCE;
			if(y_new > y_start){
				_story_container.y = y_new;
				set_handle_coord();
			}else{
				_story_container.y = y_start;
				_handle.y = _avail_height + 15;
				_timer.reset();
			}
		}
		
		/**
		 * Arrow click handler
		 */
		private function arrow_click_handler(e:MouseEvent):void{
			var y_start:Number = _track_height + 30 - _story_container.height;
			var y_new:Number = 0;
			
			var dir:Boolean = e.target.name == 'up_arrow' ? true : false;
			if(dir){
				y_new = _story_container.y + Scroller.SCROLL_DISTANCE;
				if(y_new < 0){
					_story_container.y = y_new;
					set_handle_coord();
				}else{
					_story_container.y = 0;
					_handle.y = 15;
				}
			}else{
				y_new = _story_container.y - Scroller.SCROLL_DISTANCE;
				if(y_new > y_start){
					_story_container.y = y_new;
					set_handle_coord();
				}else{
					_story_container.y = y_start;
					_handle.y = _avail_height + 15;
				}
			}
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Get story container
		 */
		private function get_story_container():void{
			for(var i:int = 0; i < this.parent.numChildren; i++){
				var c:* = this.parent.getChildAt(i);
				if(c.name == 'story_handler_container'){
					_story_container = c;
					break;
				}
			}
		}
		
		/**
		 * Set handle y coordinate
		 */
		private function set_handle_coord():void{
			var hidden:Number = _story_container.height - (_track_height + 30);
			var pct:Number = Math.abs(_story_container.y) / hidden;
			
			_handle.y = Math.round(_avail_height * pct) + 15;
		}
	}
}