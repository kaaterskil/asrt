/**
 * Multipage_form.as
 *
 * Class definition
 * @copyright 2007 Kaaterskil Management, LLC
 * @version 080206
 * @package com.kaaterskil.components
 */
 
package com.kaaterskil.components{
	
	public class Multipage_form{
		/**
		 * Reference to current page
		 */
		public var _current_page:Number;
		
		/**
		 * Reference to all form elements
		 */
		public var _forms:Array;
		
		/**
		 * Constructor
		 */
		public function Multipage_form():void{
			_current_page = 0;
			_forms = new Array();
		}
		
		/**
		 * Add form
		 * @param f Form
		 */
		public function add_form(f):void{
			_forms.push(f);
		}
		
		/**
		 * Set page visibility
		 * @param p Page
		 */
		public function set_page(p:Number):void{
			for(var i:Number = 0; i < _forms.length; i++){
				if(p == i){
					_forms[i].set_visibility(true);
				}else{
					_forms[i].set_visibility(false);
				}
			}
			_current_page = p;
		}
		
		/**
		 * Get current page reference
		 */
		public function get_page(p:Number):Flash_form{
			if(_forms[p] != null){
				return _forms[p];
			}
			return _forms[0];
		}
		
		/**
		 * Goto next page
		 */
		public function next_page():void{
			_current_page++;
			if(_current_page > _forms.length){
				_current_page = 0;
			}
			set_page(_current_page);
		}
		
		/**
		 * Goto previous page
		 */
		public function previous_page():void{
			_current_page--;
			if(_current_page < 0){
				_current_page = _forms.length - 1;
			}
			set_page(_current_page);
		}
	}
}