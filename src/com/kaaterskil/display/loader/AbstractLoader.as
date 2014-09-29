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
 package com.kaaterskil.display.loader {
 	import flash.net.URLLoader;
 	import com.kaaterskil.lang.NoSuchMethodException;
 	
	import flash.display.Loader;
	import flash.display.Sprite;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	
	import flash.net.URLRequest;

	/**
	 * @author Blair
	 */
	public class AbstractLoader extends Sprite {
		protected var loaderName : String;
		protected var loader : EventDispatcher;
		private var loaded : Boolean;
		
		/*-------------------------------------------------- properties ----------*/
		 
		public function isLoaded() : Boolean {
			return loaded;
		}
		
		public function setIsLoaded(loaded : Boolean) : void {
			this.loaded = loaded;
		}
		
		public function getLoader() : EventDispatcher {
			return loader;
		}
		
		public function setLoader(loader : EventDispatcher) : void {
			if(loader is Loader){
				var newLoader : Loader = Loader(loader);
				if(null !== loaderName){
					newLoader.name = loaderName;
				}
				setListeners(newLoader.contentLoaderInfo);
				addChild(newLoader);
			}else{
				setListeners(loader);
			}
			this.loader = loader;
		}
		
		/*-------------------------------------------------- public methods ----------*/
		
		/**
		 * Loads the resource identified by the given URI string
		 * 
		 * @param request	The URIRrequest object representing the resource 
		 * 					to be loaded.
		 * @throws 		A SecurityError that is handled by the 
		 * 					securityEventHandler,
		 */
		public function load(request : URLRequest) : void {
			if(loader is Loader){
				Loader(loader).load(request);
			}else if(loader is URLLoader) {
				URLLoader(loader).load(request);
			}else{
				var msg : String = "load() not implemented in loader " + loader;
				throw new NoSuchMethodException(msg);
			}
		}
		
		/*-------------------------------------------------- event methods ----------*/
		
		/**
		 * Sets the loader's event listeners
		 */
		protected function setListeners(target : IEventDispatcher) : void {
			target.addEventListener(
					Event.INIT, initEventtHandler);
			target.addEventListener(
					Event.OPEN, openEventHandler);
			target.addEventListener(
					ProgressEvent.PROGRESS, progressEventHandler);
			target.addEventListener(
					Event.COMPLETE, completeEventHandler);
			target.addEventListener(
					Event.UNLOAD, unloadEventHandler);
			target.addEventListener(
					IOErrorEvent.IO_ERROR, errorEventHandler);
			target.addEventListener(
					SecurityErrorEvent.SECURITY_ERROR, securityEventHandler);
		}
		
		/**
		 * Removes the event listeners from the loader
		 */
		protected function clearListeners(target : IEventDispatcher) : void {
			target.removeEventListener(
					Event.INIT, initEventtHandler);
			target.removeEventListener(
					Event.OPEN, openEventHandler);
			target.removeEventListener(
					ProgressEvent.PROGRESS, progressEventHandler);
			target.removeEventListener(
					Event.COMPLETE, completeEventHandler);
			target.removeEventListener(
					Event.UNLOAD, unloadEventHandler);
			target.removeEventListener(
					IOErrorEvent.IO_ERROR, errorEventHandler);
			target.removeEventListener(
					SecurityErrorEvent.SECURITY_ERROR, securityEventHandler);
		}
		
		/**
		 * Handler for loading events dispatched by the Loader's 
		 * LoaderInfo object when the loading operation starts. The 
		 * default implementation is a no-op method that can be 
		 * overridden in subclasses.
		 * 
		 * @param e The event to be handled
		 */
		protected function openEventHandler(e : Event) : void {
			// Noop
		}
		
		/**
		 * Handler for progress events dispatched by the Loader's 
		 * LoaderInfo object. The default implementation is a no-op 
		 * method that can be overridden in subclasses.
		 * 
		 * @param e The event to be handled
		 */
		protected function progressEventHandler(e : ProgressEvent) : void {
			// Noop
		}
		
		/**
		 * Handler for the event dispatched by the Loader's LoaderInfo 
		 * object when a network request is made over HTTP and the 
		 * HTTP status code can be detected. The default implementation 
		 * is a no-op method that can be overridden in subclasses.
		 * 
		 * @param e The event to be handled
		 */
		protected function httpStatusEventHandler(e : HTTPStatusEvent) : void {
			// Noop
		}
		
		/**
		 * Handler for the event dispatched by the Loader's LoaderInfo 
		 * object when the properties and methods of the loaded 
		 * resource are accessible. The default implementation is a 
		 * no-op method that can be overridden in subclasses.
		 * 
		 * @param e The event to be handled
		 */
		protected function initEventtHandler(e : Event) : void {
			// Noop
		}
		
		/**
		 * Handler for the event dispatched by the Loader's LoaderInfo 
		 * object when the resource has completed loading. The default 
		 * implementation is a no-op method that can be overridden in 
		 * subclasses.
		 * 
		 * @param e The event to be handled
		 */
		protected function completeEventHandler(e : Event) : void {
			// Noop
		}
		
		/**
		 * Handler for the event dispatched by the Loader's LoaderInfo 
		 * object when the resource has been removed. The default 
		 * implementation is a no-op method that can be overridden in 
		 * subclasses.
		 * 
		 * @param e The event to be handled
		 */
		protected function unloadEventHandler(e : Event) : void {
			// Noop
		}
		
		/**
		 * Handler for I/O error events that cause the load operation 
		 * to fail. The default implementation is a no-op method that 
		 * can be overridden in subclasses.
		 * 
		 * @param e The event to be handled
		 */
		protected function errorEventHandler(e : IOErrorEvent) : void {
			// Noop
		}
		
		/**
		 * Handler for security error events diapatched by the Loder. 
		 * The default implementation is a no-op method that can be 
		 * overridden in subclasses.
		 * 
		 * @param e The event to be handled
		 */
		protected function securityEventHandler(e : SecurityErrorEvent) : void {
			// Noop
		}
	}
}
