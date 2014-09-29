/**
 * Image.as
 *
 * Class definition
 * @copyright 2007 Kaaterskil Management, LLC
 * @version 071229
 * @package com.kaaterskil.utilities
 */

package com.kaaterskil.utilities{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.*;
	
	dynamic public class Image extends Sprite{
		/**
		 * Containers
		 */
		public var _image:Loader;
		
		/**
		 * Trackers
		 */
		public var _image_index:Array;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Image(obj:Object):void{
			this.name = 'image instance';
			init(obj);
		}
		
		/**
		 * Initilization
		 */
		internal function init(obj:Object):void{
			//set position, if defined
			if(obj.x != undefined){
				this.x = obj.x;
			}
			if(obj.y != undefined){
				this.y = obj.y;
			}
			
			//set src
			if(obj.src is String){
				_image_index = [obj.src];
			}else if(obj.src is Array){
				_image_index = obj.src;
			}
			
			load_images();
		}
		
		/*------------------------------------------------------------
		COMMUNICATION METHODS
		------------------------------------------------------------*/
		/**
		 * Load image
		 */
		protected function load_images():void{
			for(var i:int = 0; i < _image_index.length; i++){
				var image	= new Loader();
				image.name	= 'image_' + i;
				
				set_listeners(image.contentLoaderInfo);
				addChild(image);
				
				image.load(new URLRequest(_image_index[i]));
			}
		}
		
		/*------------------------------------------------------------
		EVENT LISTENER METHODS
		------------------------------------------------------------*/
		/**
		 * Set event listeners
		 */
		protected function set_listeners(target):void{
			target.addEventListener(ProgressEvent.PROGRESS, progress_handler);
			target.addEventListener(Event.INIT, init_handler);
			target.addEventListener(Event.COMPLETE, complete_handler);
			target.addEventListener(IOErrorEvent.IO_ERROR, error_handler);
			target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, security_handler);
		}
		
		/**
		 * Unset listeners
		 */
		protected function unset_listeners(target):void{
			target.removeEventListener(ProgressEvent.PROGRESS, progress_handler);
			target.removeEventListener(Event.INIT, init_handler);
			target.removeEventListener(Event.COMPLETE, complete_handler);
			target.removeEventListener(IOErrorEvent, error_handler);
			target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, security_handler);
		}
		
		/**
		 * Progress handler.
		 */
		protected function progress_handler(e:ProgressEvent):void{
		}
		
		/**
		 * Initialization handler.
		 */
		protected function init_handler(e:Event):void{
			//trace('calling INIT_called');
			dispatchEvent(new Event('INIT_called'));
		}
		
		/**
		 * Complete handler.
		 */
		protected function complete_handler(e:Event):void{
			//trace(e.target.name + ' loaded. x_coord: ' + this.x + ', y_coord: ' + this.y);
			dispatchEvent(new Event('image_loaded'));
		}
		
		/**
		 * Error handler
		 */
		protected function error_handler(e:IOErrorEvent):void{
			trace('IO ERROR: ' + e.toString());
		}
		
		/**
		 * Security error handler
		 */
		protected function security_handler(e:SecurityErrorEvent):void{
			trace('Security Error: ' + e.text);
		}
	}
}