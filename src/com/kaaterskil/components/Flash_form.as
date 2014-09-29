/**
 * Flash_form.as
 *
 * Class definition
 * @copyright 2007 Kaaterskil Management, LLC
 * @version 080206
 * @package com.kaaterskil.components
 */

package com.kaaterskil.components{
	import fl.controls.*;
	import flash.display.*;
	import flash.text.*;
	import flash.net.*;
	import flash.events.*;
	
	import com.kaaterskil.utilities.*;

	public class Flash_form extends EventDispatcher{
		/**
		 * A controlling array with references to all form elements
		 */
		public var _elements:Array;
		
		/**
		 * An array of all form fields
		 */
		public var _fields:Array;
		
		/**
		 * An array of all form values
		 */
		public var _values:Array;
		
		/**
		 * The name of the form
		 */
		public var name:String;
		
		/**
		 * The load complete message
		 */
		public static var LOAD_COMPLETE = 'form_load_complete';
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Flash_form():void{
			_elements = new Array();
			_values = new Array();
			_fields = new Array();
		}
		
		/**
		 * Clear form. Clears the tracking arrays of the form. If a 
		 * valid display object is passed to this method, all form 
		 * elements will be removed from the container. 
		 */
		public function clear_form(container:DisplayObjectContainer = null):void{
			if(container != null){
				clear_display(container);
			}
			_elements = new Array();
			_values = new Array();
			_fields = new Array();
		}
		
		/**
		 * Clears element from display object container.
		 */
		private function clear_display(container:DisplayObjectContainer):void{
			for(var i:int = 0; i < _elements.length; i++){
				var e:* = _elements[i];
				if(container.contains(e)){
					container.removeChild(e);
				}
			}
		}
		
		/**
		 * Add new form element. Adds a field reference to the controlling array.
		 * @param e The form element
		 */
		public function add_element(e:*):void{
			_elements.push(e);
		}
		
		/**
		 * Add a form field
		 * @param e The form element
		 */
		public function add_field(e:*):void{
			_fields.push(e);
		}
		
		/**
		 * Removes an element by name
		 * @param str	The element name.
		 */
		public function remove_element(str:String):void{
			for(var i:int = 0; i < _elements.length; i++){
				var e = _elements[i];
				if(e.name == str){
					_elements.splice(i, 1);
					break;
				}
			}
		}
		
		/**
		 * Removes a field by name.
		 * @param str	The field name.
		 */
		public function remove_field(str:String):void{
			for(var i:int = 0; i < _fields.length; i++){
				var f = _fields[i];
				if(f.name == str){
					_fields.splice(i, 1);
					break;
				}
			}
		}
		
		/**
		 * Set an element's visibility
		 * @param boolean t
		 */
		public function set_visibility(t:Boolean):void{
			for(var i:int = 0; i < _elements.length; i++){
				_elements[i].visible = t;
			}
		}
		
		/**
		 * Returns form values. Loops through each form element and 
		 * populates the _values object with name/value pairs.
		 */
		public function get_values():Array{
			var r:Array = new Array();
			for(var i:int = 0; i < _fields.length; i++){
				var e:* = _fields[i];
				
				//test custom components
				if(e.hasOwnProperty('_field')){
					//Text_input
					if(e._field is TextInput){
						r.push({name:e.name, value:e._field.textField.text});
						
					//Combo_box
					}else if(e._field is ComboBox){
						if(e._field.selectedIndex > -1){
							if(e._field.selectedItem.data != undefined){
								r.push({name:e.name, value:e._field.selectedItem.data});
							}else if(e._field.selectedItem.value != undefined){
								r.push({name:e.name, value:e._field.selectedItem.value});
							}
						}else{
							r.push({name:e.name, value:''});
						}
						
					//Radio_button
					}else if(e._field is RadioButton){
						r.push({name:e.name, value:e._field.value});
					}
					
				//test standard components
				}else{
					if(e is TextField){
						r.push({name:e.name, value:e.text});
						
					}else if(e is CheckBox){
						var val:Boolean = e.selected ? true : false;
						r.push({name:e.name, value:val});
						
					}else if(e is RadioButton){
						if(e.selected){
							r.push({name:e.groupName, value:e.value});
						}
						
					}else if(e is ComboBox){
						if(e.selectedIndex != -1){
							r.push({name:e.name, value:e.selectedItem.value});
						}else{
							r.push({name:e.name, value:''});
						}
						
					}else if(e is List){
						var arr:Array = new Array();
						for(var j:int = 0; j < e.selectedItems.length; j++){
							arr.push(e.selectedItems[j].value);
						}
						r.push({name:e.name, value:arr});
					}else{
						trace('no datatype match');
					}
				}
			}
			_values = r;
			return r;
		}
		
		/**
		 * Clear form values
		 */
		public function clear_values():void{
			for(var i:int = 0; i < _fields.length; i++){
				var e:* = _fields[i];
				
				//clear custom components
				if(e.hasOwnProperty('_field')){
					//Text_input
					if(e._field is TextInput){
						e._field.textField.text = '';
						
					//Combo_box
					}else if(e._field is ComboBox){
						e._field.selectedIndex = -1;
						
					//Radio_button
					}else if(e._field is RadioButton){
						if(e._field.name.substr(-1) == '0'){
							e._field.selected = true;
						}
					}
					
				//clear standard components
				}else{
					if(e is TextField){
						e.text = '';
					}else if(e is CheckBox){
						e.selected = false;
					}else if(e is RadioButton){
						if(e.name.substr(-1) == '0'){
							e.selected = true;
						}
					}else if(e is ComboBox){
						e.selectedIndex = -1;
					}else if(e is List){
						e.selectedIndices = undefined;
					}
				}
			}
		}
		
		/**
		 * Submit form
		 */
		public function submit(url:String, load_type:String = 'xml', method:String = 'post'):void{
			var src:String = url;
			
			get_values();
			var vars:Object = new Object();
			for(var key:* in _values){
				vars[key] = _values[key];
			}
			
			var loader:Basic_loader = new Basic_loader();
			loader.addEventListener(Basic_loader.URL_LOAD_COMPLETE, load_handler);
			loader.process_load(url, vars, load_type, method);
		}
		
		/**
		 * Load object listener
		 */
		public function load_handler(e:Event):void{
			dispatchEvent(new Event(Flash_form.LOAD_COMPLETE));
		}
	}
}