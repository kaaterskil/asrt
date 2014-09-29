/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.loaders
 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
 */

package com.kaaterskil.utilities.loaders{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	/**
	 * Image_loader class
	 *
	 * @description	This class implements a simple ILoader interface
	 *				to ensure all loaders provide the same signature.
	 * @package		com.kaaterskil.utilities.loaders
	 * @inheritance	Image_loader -> Sprite
	 * @interface	ILoader
	 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
	 * @version		080417
	 */
	public class Image_loader extends Sprite implements ILoader{
		/**
		 * Constants
		 */
		public static const LOAD_COMPLETE		= 'complete';
		public static const HTTP_STATUS_EVENT	= 'http_status';
		public static const INIT_EVENT			= 'init';
		public static const LOAD_FAILED			= 'failed';
		public static const OPEN_EVENT			= 'open';
		public static const PROGRESS_EVENT		= 'progress';
		public static const UNLOAD_EVENT		= 'unload';
		
		/**
		 * Send
		 */
		private var _loader		:Loader;
		private var _prams		:Object;
		private var _is_loaded	:Boolean;
		
		/**
		 * Constructor
		 */
		public function Image_loader(prams:Object = null):void{
			this.name	= 'image_loader';
			_prams		= prams != null ? prams : {};
			_is_loaded	= false;
		}
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Return the is_loaded state
		 */
		public function get is_loaded():Boolean{
			return _is_loaded;
		}
		
		/**
		 * Process
		 */
		public function process_load(src:String):void{
			_loader			= new Loader();
			_loader.name	= 'loader';
			set_listeners(_loader.contentLoaderInfo);
			addChild(_loader);
			
			var url_request:URLRequest = new URLRequest(src);
			_loader.load(url_request);
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Set listeners
		 */
		private function set_listeners(target:IEventDispatcher):void{
			target.addEventListener(Event.COMPLETE,					complete_handler);
			target.addEventListener(Event.INIT,						init_handler);
			target.addEventListener(IOErrorEvent.IO_ERROR,			error_handler);
			target.addEventListener(Event.OPEN,						open_handler);
			target.addEventListener(ProgressEvent.PROGRESS,			progress_handler);
			target.addEventListener(Event.UNLOAD,					unload_handler);
		}
		
		/**
		 * Remove listeners
		 */
		private function unset_listeners():void{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,			complete_handler);
			_loader.contentLoaderInfo.removeEventListener(Event.INIT,				init_handler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,	error_handler);
			_loader.contentLoaderInfo.removeEventListener(Event.OPEN,				open_handler);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,	progress_handler);
			_loader.contentLoaderInfo.removeEventListener(Event.UNLOAD,				unload_handler);
		}
		
		/*------------------------------------------------------------
		EVENT METHODS
		------------------------------------------------------------*/
		/**
		 * Complete event handler
		 */
		private function complete_handler(e:Event):void{
			unset_listeners();
			_is_loaded = true;
			dispatchEvent(new Event(Image_loader.LOAD_COMPLETE));
		}
		
		/**
		 * On initialized event handler
		 */
		private function init_handler(e:Event):void{
			_is_loaded = true;
			dispatchEvent(new Event(Image_loader.INIT_EVENT));
		}
		
		/**
		 * Error event handler
		 */
		private function error_handler(e:IOErrorEvent):void{
			trace('I/O ERROR: ' + e.toString());
			dispatchEvent(new Event(Image_loader.LOAD_FAILED));
		}
		
		/**
		 * On open event handler
		 */
		private function open_handler(e:Event):void{
			if(_prams.hasOwnProperty('open_handler') && _prams.open_handler){
				dispatchEvent(new Event(Image_loader.OPEN_EVENT));
			}
		}
		
		/**
		 * Progress event handler
		 */
		private function progress_handler(e:ProgressEvent):void{
			if(_prams.hasOwnProperty('progress_handler') && _prams.progress_handler){
				trace('target loaded: ' + e.bytesLoaded + ' of ' + e.bytesTotal);
				dispatchEvent(new Event(Image_loader.PROGRESS_EVENT));
			}
		}
		
		/**
		 * On unload event handler
		 */
		private function unload_handler(e:Event):void{
			if(_prams.hasOwnProperty('unload_handler') && _prams.unload_handler){
				dispatchEvent(new Event(Image_loader.UNLOAD_EVENT));
			}
		}
		
		/**
		 * Security error event handler
		 */
		private function security_handler(e:SecurityErrorEvent):void{
			trace('SECURITY ERROR: ' + e.text);
			dispatchEvent(new Event(Image_loader.LOAD_FAILED));
		}
	}
}