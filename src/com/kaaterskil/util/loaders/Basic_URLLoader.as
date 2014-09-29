/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.loaders
 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
 */
package com.kaaterskil.utilities.loaders{
	import flash.events.*;
	import flash.net.*;
	import flash.system.Security;
	
	import com.kaaterskil.utilities.*;
	
	/**
	 * Basic_URLloader class
	 *
	 * @description	This class implements a simple ILoader interface
	 *				to ensure all loaders provide the same signature.
	 *				This class handles an array of load requests 
	 *				(in name/value pairs) or a single string.
	 * @package		com.kaaterskil.utilities.loaders
	 * @inheritance	Basic_URLLoader -> EventDispatcher
	 * @interface	IURLLoader
	 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
	 * @version		080521
	 */
	public class Basic_URLLoader extends EventDispatcher implements IURLLoader{
		/**
		 * Constants
		 */
		public static const URL_LOAD_PROGRESS			= 'progress';
		public static const URL_LOAD_COMPLETE			= 'complete';
		public static const URL_LOAD_FAILED				= 'failed';
		public static const URL_LOADER_ALT_DECODE		= 'alt_complete';
		public static const HTTP_STATUS_EVENT			= 'http_status';
		public static const URL_LOADER_DECODE_FAILED	= 'decode_failed';
		
		/**
		 * Send
		 */
		private var _loader			:URLLoader;
		private var _request		:URLRequest;
		private var _data_format	:String;
		private var	_formats		:Array;
		private var _prams			:Object;
		
		/**
		 * Reply
		 */
		private var _content		:URLVariables;
		private var _content_xml	:XML;
		private var _content_txt	:String;
		
		/**
		 * Constructor
		 */
		public function Basic_URLLoader(prams:Object = undefined):void{
			_formats = ['', 'text', 'xml', 'variables', 'binary'];
			if(prams != null){
				_prams = prams;
			}else{
				_prams = {progress_handler:false, http_handler:false};
			}
			_loader = new URLLoader();
		}
		
		/*------------------------------------------------------------
		PUBLIC METHODS
		------------------------------------------------------------*/
		public function get_content(){
			return _content;
		}
		
		public function get_content_xml(){
			return _content_xml;
		}
		
		public function get_content_txt(){
			return _content_txt;
		}
		
		/**
		 * Process
		 * 
		 * @param url
		 * @param vars
		 * @param format	The data format.
		 * @param method	The GET or POST method to use
		 */
		public function process_load(src:*, vars:* = null, format:String = 'text', 
									 method:String = 'GET'):void{
			set_data_format(format);
			set_listeners(_loader);
			if(src is Array){
				for(var i:int = 0; i < src.length; i++){
					_request = new URLRequest(src[i]);
					set_request_data(vars);
					set_request_method(method);
					load_file(_request);
				}
			}else if(src is String){
				_request = new URLRequest(src);
				set_request_data(vars);
				set_request_method(method);
				load_file(_request);
			}
		}
		
		/*------------------------------------------------------------
		PRIVATE METHODS
		------------------------------------------------------------*/
		/**
		 * Load file
		 */
		private function load_file(url_request:URLRequest):void{
			try{
				_loader.load(url_request);
			}catch(e:Error){
				trace('LOAD ERROR: ' + e.errorID + ': ' + e.message);
				dispatchEvent(new Event(Basic_URLLoader.URL_LOAD_FAILED));
			}
		}
		
		/**
		 * Set the data format
		 */
		private function set_data_format(format:String = null):void{
			if(format != null && Common.in_array(format, _formats)){
				_data_format = format;
				switch(format){
					case '':
					case 'xml':
					case 'text':
						_loader.dataFormat = URLLoaderDataFormat.TEXT;
						break;
					case 'variables':
						_loader.dataFormat = URLLoaderDataFormat.VARIABLES;
						break;
					case 'binary':
						_loader.dataFormat = URLLoaderDataFormat.BINARY;
						break;
				}
			}else{
				_loader.dataFormat = URLLoaderDataFormat.TEXT;
			}
		}
		
		/**
		 * Set request data
		 */
		private function set_request_data(vars:*):void{
			var r:URLVariables = new URLVariables();
			
			if(vars != null){
				if(vars is URLVariables){
					r = vars;
				}else if(vars is Array){
					if(_data_format == 'variables'){
						for(var e:* in vars){
							r[e] = vars[e];
						}
					}else{
						r = vars.join();	//convert to string
					}
				}else if(vars is String){
					r = vars as URLVariables;
				}else if(vars is Object){	//Nu, what else would it be?
					for(var key:* in vars){
						if(vars[key] is Array){
							for(var i:int = 0 ; i < vars[key].length; i++){
								var vars2:* = vars[key][i];
								for(var key2:* in vars2){
									r[key + '_' + i + '_' + key2] = vars2[key2];
								}
							}
						}else if(vars[key] is String || vars[key] is Number || vars[key] is Boolean){
							r[key] = vars[key];
						}else{
							vars2 = vars[key];
							for(key2 in vars2){
								r[key + '_' + key2] = vars2[key2]
							}
						}
					}//end for
				}
				_request.data = r;
			}else{
				_request.data = null;
			}
		}
		
		/**
		 * Set request method
		 */
		private function set_request_method(method:String):void{
			if(_loader.dataFormat == URLLoaderDataFormat.BINARY){
				_request.method = URLRequestMethod.POST;	//AS3 only supports binary POST
			}else{
				if(method.toLowerCase() == 'post'){
					_request.method = URLRequestMethod.POST;
				}else{
					_request.method = URLRequestMethod.GET;
				}
			}
		}
		
		/**
		 * Set listeners
		 */
		private function set_listeners(target:URLLoader):void{
			target.addEventListener(ProgressEvent.PROGRESS,				progress_handler);
			target.addEventListener(Event.COMPLETE,						complete_handler);
			target.addEventListener(IOErrorEvent.IO_ERROR,				error_handler);
			target.addEventListener(HTTPStatusEvent.HTTP_STATUS,		http_handler);
			target.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	security_handler);
		}
		
		/**
		 * Remove listeners
		 */
		private function unset_listeners(target):void{
			target.removeEventListener(ProgressEvent.PROGRESS,				progress_handler);
			target.removeEventListener(Event.COMPLETE,						complete_handler);
			target.removeEventListener(IOErrorEvent.IO_ERROR,				error_handler);
			target.removeEventListener(HTTPStatusEvent.HTTP_STATUS,			http_handler);
			target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	security_handler);
		}
		
		/*------------------------------------------------------------
		EVENT METHODS
		------------------------------------------------------------*/
		/**
		 * Complete event handler
		 */
		private function complete_handler(e:Event):void{
			unset_listeners(e.target);
			try{
				if(_data_format == 'xml'){
					_content_xml = new XML(_loader.data);
				}else if(_data_format == 'variables'){
					_content = new URLVariables(_loader.data);
				}else{
					_content = _loader.data;
				}
				dispatchEvent(new Event(Basic_URLLoader.URL_LOAD_COMPLETE));
				
			}catch(err1:TypeError){
				_content_txt = _loader.data;
				dispatchEvent(new Event(Basic_URLLoader.URL_LOADER_ALT_DECODE));
				
			}catch(err2:Error){
				_content_txt = 'LOAD ERROR: ' + err2.errorID + ': ' + _loader.data;
				dispatchEvent(new Event(Basic_URLLoader.URL_LOADER_DECODE_FAILED));
			}
		}

		/**
		 * Progress event handler
		 */
		private function progress_handler(e:ProgressEvent):void{
			if(_prams.hasOwnProperty('progress_handler') && _prams.progress_handler){
				trace('loaded: ' + e.bytesLoaded + ' of ' + e.bytesTotal);
				dispatchEvent(new Event(Basic_URLLoader.URL_LOAD_PROGRESS));
			}
		}
		
		/**
		 * HTTP status event handler
		 */
		private function http_handler(e:HTTPStatusEvent):void{
			if(_prams.hasOwnProperty('http_handler') && _prams.http_handler){
				trace('HTTP EVENT: ' + e.status);
				dispatchEvent(new Event(Basic_URLLoader.HTTP_STATUS_EVENT));
			}
		}
		
		/**
		 * Error event handler
		 */
		private function error_handler(e:IOErrorEvent):void{
			unset_listeners(e.target);
			trace('I/O ERROR: ' + e.toString());
			dispatchEvent(new Event(Basic_URLLoader.URL_LOAD_FAILED));
		}
		
		/**
		 * Security error event handler
		 */
		private function security_handler(e:SecurityErrorEvent):void{
			unset_listeners(e.target);
			trace('SECURITY ERROR: ' + e.text);
			dispatchEvent(new Event(Basic_URLLoader.URL_LOAD_FAILED));
		}
	}
}