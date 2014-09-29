/**
 * Video_player.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080327
 * @package com.kaaterskil.utilities
 */

package com.kaaterskil.utilities{
	import fl.video.VideoEvent;
	import fl.video.VideoProgressEvent;
	import fl.video.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;
	
	import com.kaaterskil.utilities.*;
	
	/**
	 * This class instantiates an FLVPlayback object for video loading
	 * and playing. Its default status is to load an FLV video file by
	 * HTTP progressive download, NOT streaming using Flash
	 * Communication Server or Flash Media Server. The constructor is
	 * passed on object containing the URL source loaction, the
	 * filename, text format and the instantiated object's position
	 * coordinates, along with optional background and border colors.
	 */
	public class Video_player extends Sprite{
		/**
		 * Containers
		 */
		private var _container:Sprite;
		public var _player:FLVPlayback;
		
		/**
		 * Parameters
		 */
		private var _href:String;
		private var _text:String;
		public var _position:Number;
		
		/**
		 * Text formats
		 */
		private var _format_txt:TextFormat;
		
		/*------------------------------------------------------------
		CONTROL FUNCTIONS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Video_player(obj):void{
			init(obj);
		}
		
		/**
		 * Initialization
		 */
		private function init(obj):void{
			_href		= obj.href;
			_text		= obj.filename;
			_position	= obj.position;
			_format_txt	= obj.format;
			this.name	= obj.name;
			
			create_container();
			load_movie();
			
			if(obj.background != undefined){
				draw_background(obj.background);
			}
			if(obj.border != undefined){
				draw_border(obj.border);
			}
		}
		
		/**
		 * Load movie
		 */
		private function load_movie():void{
			_player = new FLVPlayback();
			_player.name		= 'video_player';
			_player.autoPlay	= true;
			_player.autoRewind	= true;
			_player.source		= _href;
			_player.addEventListener(VideoEvent.READY, ready_handler);
			_player.addEventListener(VideoEvent.COMPLETE, complete_handler);
			_player.addEventListener(VideoProgressEvent.PROGRESS, progress_handler);
			_player.addEventListener(VideoEvent.PLAYING_STATE_ENTERED, play_handler);
			_container.addChild(_player);
		}
		
		/*------------------------------------------------------------
		DRAWING METHODS
		------------------------------------------------------------*/
		/**
		 * Create container
		 */
		private function create_container():void{
			_container = new Sprite();
			_container.name = 'video_container';
			addChild(_container);
		}
		
		/**
		 * Draw background
		 * @param color		The background color
		 */
		private function draw_background(color:Number):void{
			var bkg:Shape = new Shape();
			bkg.name = 'video_background';
			bkg.graphics.clear();
			bkg.graphics.lineStyle(1, color, 0);
			bkg.graphics.beginFill(color, 1);
			bkg.graphics.drawRect(0, 0, this.width, this.height);
			bkg.graphics.endFill();
			_container.addChild(bkg);
		}
		
		/**
		 * Draw border
		 * @param color		The border color
		 */
		private function draw_border(color:Number):void{
			var border:Shape = new Shape();
			border.name = 'video_border';
			border.graphics.clear();
			border.graphics.lineStyle(1, color, 1);
			border.graphics.drawRect(-1, -1, _player.width + 2, _player.height + 2);
			_container.addChild(border);
			_container.swapChildren(_player, border);
		}
		
		/**
		 * Draw progress bar
		 * @param obj	The FLV's loaded percent
		 */
		private function draw_progress_bar(pct:Number):void{
			//remove existing bar
			remove_child('progress_bar_container');
			
			//create container
			var progress_container:Sprite = new Sprite();
			progress_container.name	= 'progress_bar_container';
			_container.addChild(progress_container);
			
			//get parameters
			var margin:Number	= 20;
			var x_coord:Number	= margin;
			var w_max:Number	= this.width - (margin * 2);
			var w_pct:Number	= Math.round(w_max * pct);
			
			//draw title
			 var obj:Object = new Object();
			 obj.x		= 0;
			 obj.y		= 0;
			 obj.name	= 'progress_text';
			 obj.prams = new Object();
			 obj.prams.props = {antiAliasType:	AntiAliasType.ADVANCED,
							    autoSize:		TextFieldAutoSize.LEFT,
								embedFonts:		true,
								multiline:		true,
								text:			'LOADING...',
								visible:		true,
								width:			w_max,
								wordWrap:		true
								};
			obj.prams.format = _format_txt;
			var txt:Text_field = new Text_field(obj);
			progress_container.addChild(txt);
			
			//draw bar
			obj = {x:0, y:txt.y + txt.height};
			var bar:Shape = new Shape();
			bar.name = 'progress_bar';
			bar.graphics.clear();
			bar.graphics.lineStyle(2, 0xff0000, 1);
			bar.graphics.moveTo(obj.x, obj.y);
			bar.graphics.lineTo(obj.x + w_pct, obj.y);
			progress_container.addChild(bar);
			
			//set coordinates
			var h:Number = bar.y + bar.height;
			var y_coord:Number	= (this.height - h) / 2;
			progress_container.x = x_coord;
			progress_container.y = y_coord;
		}
		
		/*------------------------------------------------------------
		LISTENER METHODS
		------------------------------------------------------------*/
		/**
		 * On load progress. Uses the default progress interval of 0.25 seconds.
		 */
		private function progress_handler(e:VideoProgressEvent):void{
			var loaded:Number	= e.target.bytesLoaded;
			var total:Number	= e.target.bytesTotal;
			var pct:Number		= loaded / total;
			if(!e.target.playing){
				draw_progress_bar(pct);
			}else{
				remove_child('progress_bar_container');
			}
		}
		
		/**
		 * On load completion (or enough download to begin playback)
		 */
		private function ready_handler(e:VideoEvent):void{
			e.target.removeEventListener(VideoEvent.READY, ready_handler);
			remove_child('progress_bar_container');
		}
		
		/**
		 * On playback completion
		 */
		private function complete_handler(e:VideoEvent):void{
			_player.play();
		}
		
		/**
		 * Playing state event handler. Called when video player
		 * begins playback.
		 */
		private function play_handler(e:VideoEvent):void{
			remove_child('progress_bar_container');
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Remove progress bar
		 */
		private function remove_child(n:String):void{
			for(var i:int = 0; i < _container.numChildren; i++){
				var c:* = _container.getChildAt(i);
				if(c.name == n){
					_container.removeChildAt(i);
					break;
				}
			}
		}
	}
}