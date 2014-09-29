/**
 * Payment_manager.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080127
 * @package com.kaaterskil.payment
 */

package com.kaaterskil.payment{
	import flash.utils.*;
	import flash.events.*;
	import com.kaaterskil.utilities.Common;
	import com.kaaterskil.payment.*;
	
	public class Payment_manager extends EventDispatcher{
		/**
		 * Trackers
		 */
		public var _modules:Array;
		public var _selected_module:String;
		
		/**
		 * A message string.
		 */
		public var _message:String;
		
		/**
		 * Error messages
		 */
		public static const ERROR_NO_PMT_MODULES_ENABLED	= 'No payment modules are enabled.';
		public static const ERROR_NO_PMT_MODULES_INSTALLED	= 'No payment modules are installed.';
		public static const ERROR_PMT_MODULE_NOT_FOUND		= 'That payment module could not be found.';
		
		/*------------------------------------------------------------
		CLIENT-SPECIFIC VARIABLES
		------------------------------------------------------------*/
		public static const PAYMENT_MODULES_INSTALLED = 'Authorizenet,Cash_payment';
		public static var runtime_loader = [Authorizenet, Cash_payment];
		
		/*------------------------------------------------------------
		CREATION METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Payment_manager(module:String):void{
			_selected_module = '';
			
			if(Payment_manager.PAYMENT_MODULES_INSTALLED != ''){
				//build array of installed modules
				var module_names:Array = Payment_manager.PAYMENT_MODULES_INSTALLED.split(',');
				
				//get modules
				var include_modules:Array = new Array();
				if(module != '' && Common.in_array(module, module_names, false)){
					//get specific module
					include_modules.push(module);
					_selected_module = module;
				}else{
					//get all modules
					for(var i:int = 0; i < module_names.length; i++){
						include_modules.push(module_names[i]);
					}
				}
				
				//instantiate each module
				_modules = new Array();
				for(i = 0; i < include_modules.length; i++){
					try{
						//provide full classpath
						var class_name:String = 'com.kaaterskil.payment.' + include_modules[i];
						
						var Class_ref:Class = getDefinitionByName(class_name) as Class;
						var instance:Object = new Class_ref();
						_modules.push(instance);
						
					}catch(e:ReferenceError){
						var msg:String = 'Fatal error ' + e.message;
						terminate(msg);
						return;
					}
				}
			}else{
				terminate(Payment_manager.ERROR_NO_PMT_MODULES_INSTALLED);
				return;
			}
		}
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Prepare credit card and billing input fields
		 * @param test		Test if only the selected module should be set
		 */
		public function set_billing_fields(test:Boolean = false):Array{
			var arr:Array = new Array();
			for(var i:int = 0; i < _modules.length; i++){
				if(_modules[i]._is_enabled){
					if(test && _modules[i].name == _selected_module){
						arr.push(_modules[i].set_billing_fields());
						break;
					}else{
						arr.push(_modules[i].set_billing_fields());
					}
				}
			}
			return arr;
		}
		
		/**
		 * Get module special text
		 */
		public function get_special_text():Object{
			var obj:Object = new Object();
			if(_selected_module != ''){
				for(var i:int = 0; i < _modules.length; i++){
					if(_modules[i].name == _selected_module && _modules[i]._is_enabled){
						obj = _modules[i].get_special_text();
						break;
					}
				}
			}
			return obj;
		}
		
		/**
		 * Do pre-confirmation validation
		 */
		public function pre_confirmation(obj:Object):String{
			var r:String = '';
			if(_selected_module != ''){
				for(var i:int = 0; i < _modules.length; i++){
					if(_modules[i].name == _selected_module && _modules[i]._is_enabled){
						r = _modules[i].pre_confirmation(obj);
						break;
					}
				}
			}else{
				r = Payment_manager.ERROR_PMT_MODULE_NOT_FOUND;
			}
			return r;
		}
		
		/**
		 * Prepare confirmation values
		 */
		public function confirmation(obj:Object):Array{
			var arr:Array = new Array();
			if(_selected_module != ''){
				for(var i:int = 0; i < _modules.length; i++){
					if(_modules[i].name == _selected_module && _modules[i]._is_enabled){
						arr = _modules[i].confirmation(obj);
						break;
					}
				}
			}
			return arr;
		}
		
		/**
		 * Submit form to host
		 */
		public function submit(obj:Object):void{
			if(_selected_module != ''){
				for(var i:int = 0; i < _modules.length; i++){
					if(_modules[i].name == _selected_module && _modules[i]._is_enabled){
						_modules[i].submit(obj);
						break;
					}
				}
			}
		}
		
		/**
		 * Returns a reference to the selected module instance
		 */
		public function get_instance():Object{
			if(_selected_module != ''){
				for(var i:int = 0; i < _modules.length; i++){
					if(_modules[i].name == _selected_module && _modules[i]._is_enabled){
						return _modules[i];
					}
				}
			}
			return null;
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Get payment instance property value
		 */
		public function get_property(prop:*):*{
			if(_selected_module != ''){
				for(var i:int = 0; i < _modules.length; i++){
					if(_modules[i].name == _selected_module && _modules[i].hasOwnProperty(prop)){
						return _modules[i][prop];
					}
				}
			}
			return null;
		}
		
		/**
		 * Set payment instance property value
		 * @param prop	The property name
		 * @param v		The property value
		 */
		public function set_property(prop:String, v:*):void{
			if(_selected_module != ''){
				for(var i:int = 0; i < _modules.length; i++){
					if(_modules[i].name == _selected_module && _modules[i].hasOwnProperty(prop)){
						_modules[i][prop] = v;
						break;
					}
				}
			}
		}
		
		/**
		 * Adds a listener
		 * @param event_name	The custom event name
		 * @param listener		The listener function
		 */
		public function set_listener(event_name, listener):void{
			if(_selected_module != ''){
				for(var i:int = 0; i < _modules.length; i++){
					if(_modules[i].name == _selected_module && _modules[i]._is_enabled){
						_modules[i].addEventListener(event_name, listener);
						break;
					}
				}
			}
		}
		
		/**
		 * Removes a listener
		 * @param event_name	The custom event name
		 * @param listener		The listener function
		 */
		public function unset_listener(event_name, listener):void{
			if(_selected_module != ''){
				for(var i:int = 0; i < _modules.length; i++){
					if(_modules[i].name == _selected_module && _modules[i]._is_enabled){
						_modules[i].removeEventListener(event_name, listener);
						break;
					}
				}
			}
		}
		
		/**
		 * Destroy module instances
		 */
		public function unset_modules():void{
			_modules = new Array();
		}
		
		/**
		 * Set selected module
		 */
		public function set_selected_module(module:String):Boolean{
			for(var i:int = 0; i < _modules.length; i++){
				if(_modules[i].name == module){
					_selected_module = module;
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Terminate execution
		 */
		private function terminate(msg:String):void{
			_message = msg;
			trace('payment manager error: ' + msg);
			dispatchEvent(new Event('payment_manager_terminated'));
		}
	}
}