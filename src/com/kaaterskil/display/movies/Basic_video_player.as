/**
 * Basic_video_player.as
 *
 * Class definition
 * @description	This is the base decorated class.
 * @inheritance	Basic_video_player -> AVideo_player -> AContent_display 
 *				-> ADisplay -> Sprite
 * @interface	IVideo_player -> IContent_display -> IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080423
 * @package		com.kaaterskil.display.movies
 */

package com.kaaterskil.display.movies{
	import fl.video.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	
	public class Basic_video_player extends AVideo_player{
		/**
		 * Containers
		 */
		private var _player		:FLVPlayback; 
		
		/**
		 * Parameters
		 */
		private var _href		:String;
		private var _text		:String;
		private var _position	:int;
		private var _format		:TextFormat;
		
		/**
		 * Flags
		 */
		private var _is_ready	:Boolean;
		
		/**
		 * Constructor
		 */
		public function Basic_video_player():void{}
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Initialization
		 */
		override public function init(prams:Object, container:DisplayObjectContainer = null):void{
			_href		= prams.src;
			_text		= prams.description;
			_position	= prams.position;
			_format		= prams.format;
			this.name	= prams.filename;
			
			_is_ready	= false;
			
			load_movie();
		}
		
		/**
		 * Sets the x/y coordinates
		 */
		override public function set_position(point:Point):void{
			this.x = point.x;
			this.y = point.y;
		}
		
		/**
		 * Returns the instance's layout parameter.
		 */
		override public function get_layout():int{
			return _position;
		}
		
		/**
		 * Returns a test whether the video is ready to play
		 */
		override public function get is_ready():Boolean{
			return _is_ready;
		}
		
		/**
		 * Plays the video
		 */
		override public function play_video():void{
			_player.play();
		}
		
		/**
		 * Stops the video
		 */
		override public function stop_video(e:Event):void{
			_player.stop();
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Loads the movie.
		 */
		private function load_movie():void{
			_player = new FLVPlayback();
			_player.name		= 'video_player'
			_player.autoPlay	= false;
			_player.autoRewind	= true;
			_player.source		= _href;
			_player.addEventListener(VideoEvent.READY,					ready_handler);
			_player.addEventListener(VideoEvent.COMPLETE,				complete_handler);
			_player.addEventListener(VideoProgressEvent.PROGRESS,		progress_handler);
			_player.addEventListener(VideoEvent.PLAYING_STATE_ENTERED,	play_handler);
			addChild(_player);
		}
		
		/*------------------------------------------------------------
		EVENT METHODS
		------------------------------------------------------------*/
		/**
		 * On load progress. Uses the default progress interval of 0.25 seconds.
		 */
		private function progress_handler(e:VideoProgressEvent):void{
			/*
			var loaded:Number	= e.target.bytesLoaded;
			var total:Number	= e.target.bytesTotal;
			var pct:Number		= loaded / total;
			if(!e.target.playing){
				draw_progress_bar(pct);
			}else{
				remove_child('progress_bar_container');
			}
			*/
		}
		
		/**
		 * On load completion (or enough download to begin playback)
		 */
		private function ready_handler(e:VideoEvent):void{
			e.target.removeEventListener(VideoEvent.READY, ready_handler);
			dispatchEvent(new Event(Event.INIT));
			//remove_child('progress_bar_container');
		}
		
		/**
		 * On playback completion
		 */
		private function complete_handler(e:VideoEvent):void{
		}
		
		/**
		 * Playing state event handler. Called when video player
		 * begins playback.
		 */
		private function play_handler(e:VideoEvent):void{
			//remove_child('progress_bar_container');
		}
	}
}
