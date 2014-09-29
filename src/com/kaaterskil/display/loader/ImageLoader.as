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
 * Notices, as required underSection 5 of the GNU Affero General 
 * Public License version 3.
 * 
 * In accordance with Section 7(b) of the GNU Affero General 
 * Public License version 3, these Appropriate Legal Notices 
 * must display the words "Powered by Kaaterskil".
 */
package com.kaaterskil.display.loader {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	
	import flash.system.LoaderContext;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.ProgressEvent;
	
	import flash.net.URLRequest;
	
	/**
	 * ImageLoader
	 * 
	 * A wrapper object for Loaders to handle image loading
	 *
	 * @author Blair Caple
	 * @version $Id: $
	 */
	public class ImageLoader extends Loader {
		private var data : Array;
		private var loader : Loader;
		private var expectedItems : int = 0;
		private var loadedItems : int = 0;
		
		/**
		 * Constructs a new ImageLoader object based on the 
		 * optioanlly gievn url specification. The specification 
		 * may be in the form of an Array of URL Strings, a single 
		 * URL String, a URLRequest object or null if unknown.
		 * 
		 * @param url The URL specification
		 */
		public function ImageLoader(url : * = null) : void {
			if(null !== url){
				var src : String;
				var loader : Loader;
				
				if(url is Array){
					var a : Array = url;
					expectedItems = a.length;
					for(var i : int = 0; i < a.length; i++){
						src = String(a[i]);
						loader = new Loader();
						setListeners(loader.contentLoaderInfo);
						loader.load(new URLRequest(src));
					}
				}else if(url is String){
					expectedItems = 1;
					src = url;
					loader = new Loader();
					setListeners(loader.contentLoaderInfo);
					loader.load(new URLRequest(src));
					
				}else if(url is URLRequest){
					expectedItems = 1;
					var request : URLRequest = url;
					loader = new Loader();
					setListeners(loader.contentLoaderInfo);
					loader.load(request);
				}
			}else{
				this.loader = new Loader();
			}
		}
		
		/*---------------------------------------- public methods ----------*/
		
		/**
		 * Returns the loaded images or an empty Array.
		 * 
		 * @return the loaded image array
		 */
		public function getContent() : Array {
			if(null !== data){
				return data;
			}
			return new Array();
		}
		
		/**
		 * Returns the number of expected items to be loaded.
		 * 
		 * @return The number of ecpected items
		 */
		public function getExpectedItems() : int {
			return expectedItems;
		}
		
		/**
		 * Returns the number of loaded items
		 * 
		 * @return The number of loaded items
		 */
		public function getLoadedItems() : int {
			return loadedItems;
		}
		
		/**
		 * Sets the loader for this wrapper
		 * 
		 * @param loader The underlying Loader object
		 */
		public function setLoader(loader : Loader) : void {
			this.loader = loader;
		}
		
		/**
		 * Loads the given URLRequest object
		 * 
		 * @param request The absolute or relative URL of the SWF, 
		 * 					JPEG, GIF, or PNG file to be loaded. A 
		 * 					relative path must be relative to the 
		 * 					main SWF file. Absolute URLs must include 
		 * 					the protocol reference, such as http:// 
		 * 					or file:///. Filenames cannot include 
		 * 					disk drive specifications.
		 * @param context A LoaderContext object
		 */
		override public function load(
				request : URLRequest, context : LoaderContext = null) : void {
					
			if(null !== loader){
				setListeners(loader.contentLoaderInfo);
				loader.load(request, context);
			}
		}
		
		/*---------------------------------------- protected methods ----------*/
		
		/**
		 * Sets event listeners on the underlying Loader
		 */
		protected function setListeners(li : LoaderInfo) : void {
			li.addEventListener(Event.OPEN, openListener);
			li.addEventListener(ProgressEvent.PROGRESS, progressListener);
			li.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusListener);
			li.addEventListener(Event.INIT, initListener);
			li.addEventListener(Event.COMPLETE, completeListener);
			li.addEventListener(Event.UNLOAD, unloadListener);
			li.addEventListener(IOErrorEvent.IO_ERROR, errorListener);
			li.addEventListener(
					SecurityErrorEvent.SECURITY_ERROR, securityErrorListener);
		}
		
		/**
		 * Clears the event listeners from the underlying Loader
		 */
		protected function clearListeners(li : LoaderInfo) : void {
			li.removeEventListener(Event.OPEN, openListener);
			li.removeEventListener(ProgressEvent.PROGRESS, progressListener);
			li.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusListener);
			li.removeEventListener(Event.INIT, initListener);
			li.removeEventListener(Event.COMPLETE, completeListener);
			li.removeEventListener(Event.UNLOAD, unloadListener);
			li.removeEventListener(IOErrorEvent.IO_ERROR, errorListener);
			li.removeEventListener(
					SecurityErrorEvent.SECURITY_ERROR, securityErrorListener);
		}
		
		/**
		 * Open file event listener
		 */
		protected function openListener(e : Event) : void {
			// No-op
		}
		
		/**
		 * Progress event listener
		 */
		protected function progressListener(e : ProgressEvent) : void {
			// No-op
		}
		
		/**
		 * HTTP status event listener
		 */
		protected function httpStatusListener(e : HTTPStatusEvent) : void {
			// No-op
		}
		
		/**
		 * Load initialization event listener.
		 */
		protected function initListener(e : Event) : void {}
		
		/**
		 * Load completion listener
		 */
		protected function completeListener(e : Event) : void {
			clearListeners(LoaderInfo(e.currentTarget));
			
			var img : Bitmap = LoaderInfo(e.currentTarget).content as Bitmap;
			LoaderInfo(e.currentTarget).loader.unload();
			
			if(null !== img){
				if(null === data){
					data = new Array();
				}
				
				data.push(img);
				loadedItems++;
				dispatchEvent(new Event("COMPLETE"));
			}
		}
		
		/**
		 * Unload event listener
		 */
		protected function unloadListener(e : Event) : void {
			// No-op
		}
		
		/**
		 * I/O error listener
		 */
		protected function errorListener(e : IOErrorEvent) : void {
			trace(e.toString());
		}
		
		/**
		 * Security event listener
		 */
		protected function securityErrorListener(e : SecurityErrorEvent) : void {
			// No-op
		}
	}
}
