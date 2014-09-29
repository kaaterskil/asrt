/**
 * Image_button.as
 *
 * Class definition
 * @copyright 2007 Kaaterskil Management, LLC
 * @version 071228
 * @package com.kaaterskil.utilities
 */

package com.kaaterskil.utilities{
	import fl.controls.Button;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	public class Image_button extends Sprite{
		internal var _button:Button;
		
		/**
		 * Constructor
		 */
		public function Image_button(obj:Object):void{
			init(obj);
		}
		
		/**
		 * Initialize instance
		 */
		private function init(obj:Object):void{
			this.x = obj.x;
			this.y = obj.y;
			draw_button();
		}
		
		/**
		 * Create button
		 */
		private function draw_button():void{
			_button = new Button();
			_button.label	= 'Search';
			_button.width	= 200;
			
			//_button.setStyle('upIcon', Search_btn_up);
			//_button.setStyle('downIcon', Search_btn_dn);
			_button.addEventListener(MouseEvent.CLICK, do_search);
			addChild(_button);
		}
		
		/**
		 * Click event handler
		 */
		private function do_search(e:MouseEvent):void{
			trace('search foo');
		}
	}
}