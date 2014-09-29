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
	import com.kaaterskil.event.LoadEvent;
	import com.kaaterskil.lang.IllegalArgumentException;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	


	/**
	 * XMLLoader
	 *
	 * @author Blair Caple
	 * @version $Id: $
	 */
	public class XMLLoader extends AbstractLoader {
		private var content : XML;
		
		/**
		 * Constructs a new XMLLoader from the given resource identiifer.
		 * 
		 * @param url The url resource specification. This may an 
		 * 			Array of URL String objects, a single String, or 
		 * 			a URLRequestObject, or null if unknown.
		 */
		function XMLLoader(url : * = undefined) {
			var src : String;
			
			var loader : URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			setListeners(loader);
			this.loader = loader;
			
			if(url is Array){
				var a : Array = url;
				for (var i : int = 0; i < a.length; i++) {
					src = String(a[i]);
					if(src != null && src.length > 0){
						loader.dataFormat = URLLoaderDataFormat.TEXT;
						load(new URLRequest(src));
					}
				}
			}else if(url is URLRequest) {
				var request : URLRequest = URLRequest(url);
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				load(request);
			}else if (null !== url){
				src = String(url);
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				load(new URLRequest(src));
			}
		}
		
		/*-------------------------------------------------- properties ----------*/
		
		/**
		 * Returns the XML Object created from the load operation.
		 */
		public function getContent() : XML {
			if(null !== content) {
				return content;
			}
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setLoader(loader : EventDispatcher) : void {
			if(loader is URLLoader){
				super.setLoader(loader);
			}
			throw new IllegalArgumentException();
		}
		
		/*-------------------------------------------------- event methods ----------*/
		
		override protected function openEventHandler(e : Event) : void {
			trace("Open event: " + e.toString());
		}
		
		override protected function progressEventHandler(e : ProgressEvent) : void {
			trace("Init event: " + e.toString());
		}
		
		override protected function initEventtHandler(e : Event) : void {
			trace("Init event: " + e.toString());
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function completeEventHandler(e : Event) : void {
			 clearListeners(URLLoader(e.target));
			 var data : * = URLLoader(e.target).data;
			 
			 try{
			 	content = new XML(data);
			 	dispatchEvent(LoadEvent.COMPLETE);
			 }catch(e : TypeError){
			 	trace("Error parsing xml: " + e.message + "\n\n" + data);
			 }
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function errorEventHandler(e : IOErrorEvent) : void {
			trace("I/O Error: " + e.toString());
			throw e;
		}
	}
}
