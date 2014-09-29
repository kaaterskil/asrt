/**
 * Image_gallery_no_text.as
 *
 * Class definition
 * @description	A concrete decorated class.
 * @inheritance	Image_gallery_no_text -> AImage_gallery
 *				-> AContent_display -> ADisplay -> Sprite
 * @interface	IImage_gallery -> IContent_display -> IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080523
 * @package		cpm.kaaterskil.display.image_galleries
 */

package com.kaaterskil.display.image_galleries{
	import flash.display.*;
	import flash.geom.*;
	
	import com.kaaterskil.display.factories.*;
	import com.kaaterskil.utilities.*;
	import com.kaaterskil.utilities.iterators.*;
	import com.kaaterskil.utilities.libraries.*;
	
	public class Image_gallery_no_text extends AImage_gallery{
		/**
		 * Containers
		 */
		private var _container:Sprite;
		
		/**
		 * Libraries
		 */
		private var _index:Library;
		
		/**
		 * Parameters
		 */
		private var _position:int;
		
		/**
		 * Constructor
		 */
		public function Image_gallery_no_text():void{}
		
		/*------------------------------------------------------------
		GETTER / SETTER METHODS
		------------------------------------------------------------*/
		/**
		 * Returns the instance's x/y coordinates
		 */
		override public function get_position():Point{
			var bounds:Rectangle = this.getBounds(this.parent);
			return bounds.topLeft;
		}
		
		/**
		 * Sets the instance's x/y coordinates.
		 */
		override public function set_position(point:Point):void{
			this.x = point.x;
			this.y = point.y;
		}
		
		/**
		 * Returns the layout position on the screen.
		 */
		override public function get_layout():int{
			return _position;
		}
		
		/**
		 * Returns an iterator of the image index
		 */
		override public function get_index():IIterator{
			return _index.iterator();
		}
		
		/**
		 * Returns the number of images in the index.
		 */
		override public function get index_length():int{
			return _index.get_size();
		}
		
		/**
		 * Returns container
		 */
		override public function get_container():DisplayObjectContainer{
			return _container;
		}
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Initialization
		 */
		override public function init(prams:Object, container:DisplayObjectContainer = null):void{
			this.name	= 'gallery_' + prams.gallery;
			_position	= prams.position != undefined ? prams.position : 0;
			
			if(container != null){
				container.addChild(this);
			}
			
			var point:Point = new Point();
			if(prams.x != undefined && prams.y != undefined){
				point.x = prams.x;
				point.y = prams.y;
			}
			set_position(point);
			
			create_container();
			add_images(prams.index);
		}
		
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Create container
		 */
		private function create_container():void{
			_container = new Sprite();
			_container.name = 'gallery_container';
			addChild(_container);
		}
		
		/**
		 * Adds images to the display list and index tracker.
		 */
		private function add_images(arr:Array):void{
			_index = new Library();
			for each(var obj:Object in arr){
				var image:ADisplay = obj.instance;
				image.x = 0;
				image.y = 0;
				_container.addChild(image);
				_index.add_element({name:image.name, instance:image});
			}
		}
	}
}