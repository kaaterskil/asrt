/**
 * Image_gallery_swapper.as
 *
 * Class definition
 * @description A concrete decorator class.
 * @inheritance	Image_gallery_swapper -> AImage_gallery_decorator
 *				-> AImage_gallery -> AContent_display -> ADisplay -> Sprite
 * @interface	IImage_gallery -> IContent_display -> IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		0804242
 * @package		com.kaaterskil.display.image_galleries
 */
 
package com.kaaterskil.display.image_galleries{
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	import gs.TweenLite;
	import com.kaaterskil.display.factories.*;
	import com.kaaterskil.utilities.*;
	import com.kaaterskil.utilities.iterators.*;
	import com.kaaterskil.utilities.libraries.*;
	
	public class Image_gallery_swapper extends AImage_gallery_decorator{
		private var _container:DisplayObjectContainer
		private var _timer:Timer;
		private var _swap_delay:int;
		private var _fade_delay:int;
		
		/**
		 * Constructor
		 */
		public function Image_gallery_swapper(gallery:IImage_gallery):void{
			//load the gallery into the parent class.
			super(gallery);
			_container	= get_container();
			
			//set the timer parameters from the registry singleton
			_swap_delay	= int(Registry.get_instance().get_item('gallery_swap_delay'));
			_fade_delay	= int(Registry.get_instance().get_item('gallery_fade_delay'));
			
			set_alpha();
			display_first_image();
			start_swap();
		}
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Stops timer when story is removed from the display list.
		 * @param e		An event object dispatched by the story.
		 */
		override public function stop_timer(e:Event):void{
			_timer.reset();
		}
		
		/**
		 * Sets the alpha property of all images in the gallery to 0.
		 */
		private function set_alpha():void{
			for(var i:int = 0; i < _container.numChildren; i++){
				var c:DisplayObject = _container.getChildAt(i);
				c.alpha = 0;
			}
		}
		
		/**
		 * Displays the first image in the display list and places it 
		 * at the top of the index.
		 */
		private function display_first_image():void{
			var img:DisplayObject	= _container.getChildAt(0);
			img.alpha				= 1;
			_container.setChildIndex(img, _container.numChildren - 1);
		}
		
		/**
		 * Starts the image swapping.
		 */
		private function start_swap():void{
			_timer = new Timer(_swap_delay);
			_timer.addEventListener(TimerEvent.TIMER, swap_handler);
			_timer.start();
		}
		
		/*------------------------------------------------------------
		EVENT METHODS
		------------------------------------------------------------*/
		/**
		 * Swaps images. This method takes the image at the top of the 
		 * display index as the 'old' image, and the image at index 0 
		 * as the new. The new image is placed on top and faded in, 
		 * pushing all other images down one in the stack.
		 * @param e		The event object dispatched by the timer.
		 */
		private function swap_handler(e:TimerEvent):void{
			if(_container.numChildren > 0){
				//get the 'old' image
				var c1:DisplayObject = _container.getChildAt(_container.numChildren - 1);
				
				//get the 'new' image and place it at the top of the stack
				var c2:DisplayObject = _container.getChildAt(0);
				_container.setChildIndex(c2, _container.numChildren - 1);
				
				/*
				 * Fade-in the new image. Creates an onComplete event 
				 * to set the 'old' image alpha to 0 when the 'new' 
				 * image has completely faded in.
				 */
				TweenLite.to(c2, _fade_delay, {autoAlpha:1, ease:None.easeNone, 
							 onComplete:tween_handler, onCompleteParams:[c1]});
			}
		}
		
		/**
		 * Sets the 'old' image alpha to 0 when the 'new' image has 
		 * completed its fade-in.
		 * @param img	A reference to the 'old' image instance.
		 */
		private function tween_handler(img:ADisplay){
			img.alpha = 0;
		}
	}//end class
}