/**
 * AVideo_player_decorator.as
 *
 * Class definition
 * @description	An abstract decorator class.
 * @inheritance	AVideo_player_decorator -> AVideo_player
 *				-> AContent_display -> ADisplay -> Sprite
 * @interface	IVideo_player -> IContent_display -> IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080423
 * @package		com.kaaterskil.display.movies
 */

package com.kaaterskil.display.movies{
	import flash.errors.*;
	import flash.geom.Point;
	
	public class AVideo_player_decorator extends AVideo_player{
		private var _player:AVideoplayer;
		
		public function AVideo_player_decorator(player:AVideo_player):void{
			_player = player;
		}
		
		/**
		 * Loads the product's parameters and begins the drawing 
		 * process. Required by interface IContent_display.
		 */
		override public function init(prams:Object, container:DisplayObjectContainer = null):void{
			_player.init(prams, container);
		}
		
		/**
		 * Sets the product's x/y coordinates. Required by 
		 * interface IContent_display
		 */
		override public function set_position(point:Point):void{
			_player.set_position(point);
		}
		
		/**
		 * Gets the product's layout parameter. Required by 
		 * interface IContent_display
		 */
		override public function get_layout():int{
			return _player.get_layout();
		}
		
		/**
		 * Returns a test whether the video is ready to play.
		 * Required by the IVideo_player interface.
		 */
		override public function get is_ready():Boolean{
			return _player.is_ready;
		}
		
		/**
		 * Plays the video. Required by the IVideo_player
		 * interface.
		 */
		override public function play_video():void{
			_player.play_video();
		}
		
		/**
		 * Stops the video. Required by the IVideo_player
		 * interface.
		 */
		override public function stop_video(e:Event):void{
			_player.stop_video(e);
		}
	}
}