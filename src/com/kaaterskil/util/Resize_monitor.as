/**
 * Resize_monitor.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080222
 * @package com.kaaterskil.utilities
 */

package com.kaaterskil.utilities{
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	
	public class Resize_monitor extends Sprite{
		public function Resize_monitor():void{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, resize_handler);
		}
		
		private function resize_handler(e:Event):void{
			for(var i:int = 0; i < stage.numChildren; i++){
				var c:* = stage.getChildAt(i);
				if(c.name == 'master_container'){
					c.width = stage.width;
					c.height = stage.height;
					break;
				}
			}//end for
		}
	}
}