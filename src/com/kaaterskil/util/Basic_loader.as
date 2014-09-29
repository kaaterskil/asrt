/**
 * Basic_loader.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080103
 * @package com.kaaterskil.utilities
 */

package com.kaaterskil.utilities{
	import flash.display.Sprite;
	import flash.net.*;
	import flash.events.*;
	import flash.system.Security;
	
	/**
	 * This class definition can handle either an array of load requests
	 * or a single string. Sets a dynamic class so that authoring
	 * alterations may be made.
	 */
	dynamic public class Basic_loader extends Sprite{
		public static const URL_LOAD_COMPLETE = 'url_load_complete';
		public static const URL_LOADER_DECODE_FAILED = 'url_load_decode_failed';
		public static const URL_LOADER_ALT_DECODE = 'url_load_alternate_decode';
		public static const HTTP_STATUS_EVENT = 'http_status_event';
		
		public var _content:URLVariables;
		public var _content_xml:XML;
		public var _content_txt:String;
		
		private var _data_format:String;
		private var _loader:URLLoader;
		private var _request:URLRequest;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Basic_loader():void{
			_loader = new URLLoader();
		}
		
		/**
		 * Process
		 * @param src		A url string or array of url strings.
		 * @param vars		Data to send, either in URLVariables, Array, 
		 *					Object or string format.
		 * @param format	The format for the data to send. Values 
		 *					include 'xml', 'text', 'binary' or 'variables'
		 * @param method	The GET or POST method to use.
		 */
		public function process_load(src:*, vars:* = '', format:String = '', method:String = 'GET'):void{
			set_data_format(format);
			set_listeners(_loader);
			if(src is Array){
				for(var i:int = 0; i < src.length; i++){
					_request = new URLRequest(src[i]);
					if(vars != null){
						set_request_data(vars);
					}
					set_request_method(method);
					load_file(_request);
				}
			}else{
				_request = new URLRequest(src);
				if(vars != null){
					set_request_data(vars);
				}
				set_request_method(method);
				load_file(_request);
			}
		}
		
		
		/**
		 * Load a file to the server.
		 * @param url	The url string
		 */
		public function load_file(url:URLRequest):void{
			try{
				_loader.load(url);
			}catch(e:Error){
				trace('Unable to load file. Error ' + e.errorID + ': ' + e.message);
			}
		}
		
		/*------------------------------------------------------------
		LISTENER METHODS
		------------------------------------------------------------*/
		/**
		 * Sets listeners
		 * @param e	The target loader object. 
		 */
		protected function set_listeners(target):void{
			target.addEventListener(ProgressEvent.PROGRESS, progress_handler);
			target.addEventListener(Event.COMPLETE, complete_handler);
			target.addEventListener(IOErrorEvent.IO_ERROR, error_handler);
			target.addEventListener(HTTPStatusEvent.HTTP_STATUS, http_handler);
			target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, security_handler);
		}
		
		/**
		 * Unsets listeners
		 * @param e	The target loader object
		 */
		protected function unset_listeners(target):void{
			target.removeEventListener(ProgressEvent.PROGRESS, progress_handler);
			target.removeEventListener(Event.COMPLETE, complete_handler);
			target.removeEventListener(IOErrorEvent.IO_ERROR, error_handler);
			target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, http_handler);
			target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, security_handler);
		}
		
		/**
		 * Progress handler
		 * @param e	The progress event object
		 */
		protected function progress_handler(e:ProgressEvent):void{
			//trace("progressHandler loaded:" + e.bytesLoaded + " total: " + e.bytesTotal);
			//do something here
		}
		
		/**
		 * Completion handler
		 * @param e	The completion event object
		 */
		public function complete_handler(e:Event):void{
			unset_listeners(e.target);
			//trace('format: ' + _data_format + ', raw response: ' + e.target.data);
			
			//remove backslashes
			var ptn:RegExp = /\\/gm;
			_loader.data = Common.str_replace_regexp(_loader.data, ptn, '');
			
			//save data
			try{
				if(_data_format == 'xml'){
					_content_xml = new XML(_loader.data);
					//trace('foobar1 ');
				}else if(_data_format == 'variables'){
					_content = new URLVariables(_loader.data);
					//trace('foobar2 ' + e);
				}else{
					_content = _loader.data;
					//trace('foobar3 ' + e);
				}
				dispatchEvent(new Event(Basic_loader.URL_LOAD_COMPLETE));
				
			}catch(err1:TypeError){
				//trace('foo error1 ' + err1);
				_content_txt = _loader.data;
				dispatchEvent(new Event(Basic_loader.URL_LOADER_ALT_DECODE));
				
			}catch(err2:Error){
				//trace('foo error2 ' + err2);
				_content_txt = 'Error parsing ' + _data_format + 'from host:\nError ';
				_content_txt += err2.errorID + ': ' + err2.message + '\n\n' + _loader.data;
				dispatchEvent(new Event(Basic_loader.URL_LOADER_DECODE_FAILED));
			}
		}
		
		/**
		 * Error handler. Report I/O errors.
		 * @param e	The error event object
		 */
		protected function error_handler(e:IOErrorEvent):void{
			trace('I/O Error: ' + e.toString());
		}
		
		/**
		 * HTTP Status change handler. Reports HTTP status changes.
		 * @patam e		The HTTPStatusEvent object
		 */
		protected function http_handler(e:HTTPStatusEvent):void{
			//trace('HTTP Status event: ' + e.status);
			//dispatchEvent(new Event(Basic_loader.HTTP_STATUS_EVENT));
		}
		
		/**
		 * ecurity error handler
		 */
		private function security_handler(e:SecurityErrorEvent):void{
			trace('Security Error: ' + e.text);
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Sets the data format
		 * @param str	User defined formats.
		 * @result		A URLLoaderDataFormat value.
		 */
		private function set_data_format(str:String = ''):void{
			_data_format = str;
			
			if(str != null){
				switch(str.toLowerCase()){
					case 'variables':
						_loader.dataFormat = URLLoaderDataFormat.VARIABLES;
						break;
					case 'binary':
						_loader.dataFormat = URLLoaderDataFormat.BINARY;
						break;
					case 'xml':
					case 'text':
						_loader.dataFormat = URLLoaderDataFormat.TEXT;
						break;
					default:
						_loader.dataFormat = URLLoaderDataFormat.TEXT;
				}
			}else{
				_loader.dataFormat = URLLoaderDataFormat.TEXT;
			}
		}
		
		/**
		 * Sets the http form submission method
		 * @param str	Either GET or POST. Defaults to GET.
		 * @result		A URLRequestMethod value.
		 */
		private function set_request_method(str:String):void{
			if(_loader.dataFormat == URLLoaderDataFormat.BINARY){
				//Actionscript only supports the POST method for binary data
				_request.method = URLRequestMethod.POST;
			}else{
				if(str.toLowerCase() == 'post'){
					_request.method = URLRequestMethod.POST;
				}else{
					_request.method = URLRequestMethod.GET;
				}
			}
		}
		
		/**
		 * Formats the data to send.
		 * @param vars	The data to send. The data can already be in
		 * 				URLVariables format, or in array or object 
		 *				property format, or as a string.
		 * @result		A URLVariables object.
		 */
		private function set_request_data(vars:*):void{
			var r:URLVariables;
			
			//for URLVariables
			if(vars is URLVariables){
				_request.data = vars;
				
			//for arrays
			}else if(vars is Array){
				if(_data_format == 'variables'){
					//create URLVariables object.
					r = new URLVariables();
					for(var e:* in vars){
						r[e] = vars[e];
					}
					_request.data = r;
				}else{
					//convert array or object to string.
					_request.data = vars.join();
				}
				
			//for strings
			}else if(vars is String){
				_request.data = vars;
				
			//for objects
			}else if(vars is Object){
				r = new URLVariables();
				for(var key:String in vars){
					//for nested arrays
					if(vars[key] is Array){
						for(var i:int = 0; i < vars[key].length; i++){
							var var2:* = vars[key][i];
							for(var key2:* in var2){
								r[key + '_' + i + '_' + key2] = var2[key2];
							}
						}
					//for strings, numbers or booleans
					}else if(vars[key] is String || vars[key] is Number || vars[key] is Boolean){
						r[key] = vars[key];
					//for nested objects
					}else if(vars[key] is Object){
						var vars2:Object = vars[key];
						for(key2 in vars2){
							r[key + '_' + key2] = vars2[key2];
						}
					}
				}
				_request.data = r;
			}
		}//end method
	}
}