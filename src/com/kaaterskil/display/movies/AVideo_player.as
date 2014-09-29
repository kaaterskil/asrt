/**
 * AVideo_player.as
 *
 * Class definition
 * @description	This is the abstract decorated class, and provides 
 *				base functionality to other extended decorated 
 *				classes.
 * @inheritance	AVideo_player -> AContent_display -> ADisplay -> Sprite
 * @interface	IVideo_player -> IContent_display -> IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080423
 * @package		com.kaaterskil.display.movies
 */

package com.kaaterskil.display.movies{
	import flash.display.*;
	import flash.errors.*;
	import flash.events.*;
	import flash.geom.Point;
	
	import com.kaaterskil.display.factories.*;
	
	public class AVideo_player extends AContent_display implements IVideo_player{
		public function AVideo_player():void{}
		
		/**
		 * Loads the product's parameters and begins the drawing 
		 * process. Required by interface IContent_display.
		 */
		override public function init(prams:Object, container:DisplayObjectContainer = null):void{
			throw new IllegalOperationError('Abstract method init() must be overridden by a subclass.');
		}
		
		/**
		 * Sets the product's x/y coordinates. Required by 
		 * interface IContent_display
		 */
		override public function set_position(point:Point):void{
			throw new IllegalOperationError('Abstract method set_position() must be overridden by a subclass.');
		}
		
		/**
		 * Gets the product's layout parameter. Required by 
		 * interface IContent_display
		 */
		override public function get_layout():int{
			throw new IllegalOperationError('Abstract method get_layout() must be overridden by a subclass.');
		}
		
		/**
		 * Returns a test whether the video is ready to play. 
		 * Required by the IVideo_player interface.
		 */
		public function get is_ready():Boolean{
			throw new IllegalOperationError('Abstract method is_ready() must be overridden by a subclass.');
		}
		
		/**
		 * Plays the video. Required by the IVideo_player
		 * interface.
		 */
		public function play_video():void{
			throw new IllegalOperationError('Abstract method play_video() must be overridden by a subclass.');
		}
		
		/**
		 * Stope the video. Required by the IVideo_player
		 * interface.
		 */
		public function stop_video(e:Event):void{
			throw new IllegalOperationError('Abstract method stop_video() must be overridden by a subclass.');
		}
	}
}