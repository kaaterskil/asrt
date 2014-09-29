/**
 * AImage_gallery_decorator.as
 *
 * Class definition
 * @description	An abstract decorator class.
 * @inheritance	AImage_gallery_decorator -> AImage_gallery 
 *				-> AContent_display -> ADisplay -> Sprite
 * @interface	IImage_gallery -> IContent_display -> IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080424
 * @package		com.kaaterskil.display.image_galleries
 */

package com.kaaterskil.display.image_galleries{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	import com.kaaterskil.utilities.iterators.*;
	
	public class AImage_gallery_decorator extends AImage_gallery{
		private var _gallery:IImage_gallery;
		
		public function AImage_gallery_decorator(gallery:IImage_gallery):void{
			_gallery = gallery;
		}
		
		override public function init(prams:Object, container:DisplayObjectContainer = null):void{
			_gallery.init(prams, container);
		}
		
		override public function get_position():Point{
			return _gallery.get_position();
		}
		
		override public function set_position(point:Point):void{
			_gallery.set_position(point);
		}
		
		override public function get_layout():int{
			return _gallery.get_layout();
		}
		
		override public function get_index():IIterator{
			return _gallery.get_index();
		}
		
		override public function get index_length():int{
			return _gallery.index_length;
		}
		
		override public function get_container():DisplayObjectContainer{
			return _gallery.get_container();
		}
		
		override public function stop_timer(e:Event):void{
			_gallery.stop_timer(e);
		}
	}
}