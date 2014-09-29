/**
 * Kaaterskil Library
 * Copyright (C) 2008-2011 Kaaterskil Management, LLC.
 * 
 * This program is free software: you can redistribute it 
 * and/or modify it under the terms of the GNU Affero General 
 * Public License as published by the Free Software Foundation, 
 * either version 3 of the License, or (at your option) any 
 * later version.
 * 
 * This program is distributed in the hope that it will be 
 * useful, but WITHOUT ANY WARRANTY; without even the implied 
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
 * PURPOSE.  See the GNU Affero General Public License for more 
 * details.
 * 
 * You should have received a copy of the GNU Affero General 
 * Public Licensealong with this program.  If not, see 
 * <http://www.gnu.org/licenses/> or write to the Free Software 
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, 
 * MA 02110-1301 USA.
 *
 * You can contact Kaaterskil Management, LLC at 45 Avon Road, 
 * Wellesley, MA USA 02482, or by email at questions@kaaterskil.com.
 * 
 * The interactive user interfaces in modified source and object 
 * code versionsof this program must display Appropriate Legal 
 * Notices, as required under Section 5 of the GNU Affero General 
 * Public License version 3.
 * 
 * In accordance with Section 7(b) of the GNU Affero General 
 * Public License version 3, these Appropriate Legal Notices 
 * must display the words "Powered by Kaaterskil".
 */
package com.kaaterskil.utilities{
	import flash.display.Sprite;
	import flash.net.*
	import flash.events.*;
	
	/**
	 * A sinmple XML Loader class that converts all loaded data to text.
	 * Sets a dynamic class so that alterations my be made in authoring.
	 */
	dynamic public class XMLLoader extends Sprite{
		/**
		 * A custom event to dispatch when loading is complete.
		 */
		public static const XML_LOAD_COMPLETE:String = 'xml_load_complete';
		
		/**
		 * A container for the loaded data.
		 */
		public var _xml_content:XML;
		
		/**
		 * The loader
		 */
		private var _loader:URLLoader;
		
		/*------------------------------------------------------------
		CREATION METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 * This method can load an array of urls, a single url string,
		 * or nothing at all, in which case the load_file() method
		 * should be called after creating an instance.
		 */
		public function XMLLoader(url:* = undefined):void{
			if(url is Array){
				for(var i:int = 0; i < url.length; i++){
					if(url[i] != undefined && url[i].length > 0){
						_loader = new URLLoader();
						_loader.dataFormat = URLLoaderDataFormat.TEXT;
						set_listeners(_loader);
						_loader.load(new URLRequest(url[i]));
					}
				}
			}else if(url is URLRequest){
				_loader = new URLLoader();
				_loader.dataFormat = URLLoaderDataFormat.VARIABLES;
				set_listeners(_loader);
				_loader.load(url);
			}else{
				_loader = new URLLoader();
				_loader.dataFormat = URLLoaderDataFormat.TEXT;
				set_listeners(_loader);
				if(url is String && url.length > 0){
					_loader.load(new URLRequest(url));
				}
			}
		}
		
		/**
		 * Load document. Call this method if you don't pass the url
		 * with the constructor.
		 */
		public function load_file(url:String):void{
			_loader.load(new URLRequest(url));
		}
		
		/*------------------------------------------------------------
		LISTENER METHODS
		------------------------------------------------------------*/
		/**
		 * Set event listeners
		 */
		protected function set_listeners(target):void{
			target.addEventListener(ProgressEvent.PROGRESS, progress_handler);
			target.addEventListener(Event.COMPLETE, complete_handler);
			target.addEventListener(IOErrorEvent.IO_ERROR, error_handler);
		}
		
		/**
		 * Unset listeners
		 */
		protected function unset_listeners(target):void{
			target.removeEventListener(ProgressEvent.PROGRESS, progress_handler);
			target.removeEventListener(Event.COMPLETE, complete_handler);
			target.removeEventListener(IOErrorEvent, error_handler);
		}
		
		/**
		 * Progress handler
		 */
		protected function progress_handler(e:ProgressEvent):void{
			//var pct:Number = Math.round(e.bytesLoaded / e.bytesTotal * 100);
			//trace('PCT LOADED: ' + pct + '%');
		}
		
		/**
		 * Complete handler
		 */
		public function complete_handler(e:Event):void{
			unset_listeners(_loader);
			var xml_data = e.target.data;
			try{
				_xml_content = new XML(e.target.data);
				dispatchEvent(new Event(XMLLoader.XML_LOAD_COMPLETE));
			}catch(e:TypeError){
				trace('ERROR PARSING TEXT: ' + e.message + '\n\n' + xml_data);
			}
		}
		
		/**
		 * Error handler
		 */
		protected function error_handler(e:IOErrorEvent):void{
			trace('IO ERROR: ' + e.toString());
		}
	}
}