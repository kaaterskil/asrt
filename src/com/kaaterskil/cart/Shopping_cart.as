/**
 * Shopping_cart.as
 *
 * Class definition
 * @2008 Kaaterskil management, LLC
 * @version 080406
 * package com.kaaterskil.cart
 */

package com.kaaterskil.cart{
	import flash.display.*;
	import flash.events.*;
	
	import com.kaaterskil.utilities.*;
	
	public class Shopping_cart extends Sprite{
		/**
		 * Constants
		 */
		private const QUANTITY_DECIMALS	= 0;
		
		/**
		 * Libraries
		 */
		private var _products:Array;
		
		/**
		 * Parameters
		 */
		private var _cart_id:String;
		private var _params:Object;
		public var _contents:Object;
		
		public var _subtotal:Number;
		public var _total_tax:Number;
		public var _total_price:Number;
		public var _total_weight:Number;
		
		public var _free_subtotal:Number
		public var _free_total:Number
		public var _free_total_weight:Number;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Shopping_cart():void{
			this.name = 'shopping_cart';
			reset();
		}
		
		/**
		 * Resets cart
		 */
		private function reset():void{
			_contents			= new Object();
			_subtotal			= 0;
			_total_tax			= 0;
			_total_price		= 0;
			_total_weight		= 0;
			_free_subtotal		= 0;
			_free_total			= 0;
			_free_total_weight	= 0;
			
			if(_params.hasOwnProperty('customer_id') && _params.customer_id != null){
				db_delete_cart()
			}
			_params = new Object();
			_cart_id = null;
		}
		
		/**
		 * Adds item to cart
		 */
		private function add_item(id:int, attributes:Object, qty:Number = 1):void{
			var product_id:String	= set_long_id(id, attributes);
			qty						= adjust_quantity(qty);
			
			if(is_in_cart(product_id)){
				update_item_quantity(product_id, qty);
			}else{
				_contents[product_id] = {quantity:qty};
				if(attributes.length > 0){
					for(var option:* in attributes){
						var val:*;
						var attribute_value:*;
						var blank_value:Boolean	= false;
						
						//test if option is a text field
						if(attributes[option].is_text){
							if(Common.trim(attributes[option].value) != ''){
								blank_value = true;
							}else{
								attribute_value	= Common.stripslashes(attributes[option].value);
								_contents[product_id].attribute_value = {option:attribute_value}
							}
						}
						if(!blank_value){
							if(attributes[option].value is Array){
								for(var opt:* in attributes[option].value){
									var val:* = attributes[option].value[opt];
									_contents[product_id].attributes[option + '_chk'] = val;
								}
							}else{
								_contents[product_id].attributes[option] = attributes[option].value;
							}
						}
					}//end for
				}
			}
			clean_up();
			_cart_id = create_cart_id();
		}
		
		/**
		 * Removes item from cart
		 * @pram product_id		The selected product id
		 */
		private function remove_item(product_id:String):void{
			_contents[product_id] = undefined;
			_cart_id = create_cart_id();
		}
		
		/**
		 * Deletes shopping cart from database
		 */
		private function db_delete_cart():void{
			var ptn:RegExp	= /_id$/g;
			var url:String	= Constants.FILENAME_DELETE_CART;
			
			var vars:Object = new Object();
			for(var prop:* in _params){
				if(_params[prop].match(ptn)){
					vars[prop] = _params[prop];
				}
			}
			call_server(vars, url, 'text');
		}
		
		/*------------------------------------------------------------
		FINANCIAL METHODS
		------------------------------------------------------------*/
		/**
		 * Retrieves product info from server
		 */
		private function get_product_info():void{
			var count:Number = count_items();
			if(count > 0){
				var url = Constants.FILENAME_PRODUCT_INFO;
				
				var vars:Object = new Object();
				for(var item:String in _contents){
					var id:int = get_product_id(item);
					vars.product_id = id;
				}
			}
			call_server(vars, url, 'xml');
		}
		
		/**
		 * Calculates totals
		 */
		public function calculate_totals():Boolean{
			_subtotal			= 0;
			_total_tax			= 0;
			_total_price		= 0;
			_total_weight		= 0;
			_free_subtotal		= 0;
			_free_total			= 0;
			_free_total_weight	= 0;
			
			if(_contents = null){
				return false;
			}
			for(var product_id:String in _contents){
				var id:int		= get_product_id(product_id);
				var qty:Number	= _contents[product_id].quantity;
				
				for(var i:int = 0; i < _products.length; i++){
					var product:Object	= _products[i];
					var id_test:int		= product.product_id;
					if(id_test == id){
						var price:Number			= product.product_price;
						var weight:Number			= product.product_weight;
						var tax_rate:Number			= get_tax_rate(product.tax_class_id);
						var special_price:Number	= get_special_price(id);
						var is_free:Boolean			= get_price_is_free(id);
						var has_attributes:Boolean	= test_attributes(id, false);
						
						var free_shipping_items:int		= 0;
						var free_shipping_price:Number	= 0;
						var free_shipping_weight:Number	= 0;
						
						//price adjustments
						if(special_price > 0 && !product.is_priced_by_attribute){
							price = special_price
						}
						if(is_free){
							price = 0;
						}
						if(product.is_priced_by_attribute && has_attributes){
							if(special_price > 0){
								price = special_price;
							}else{
								price = product.product_price;
							}
						}else{
							if(product.discount_type != 0){
								price = get_discount_price(id) * qty;
							}
						}
						
						//shipping adjustments
						if(product.is_virtual || product.is_free_shipping){
							weight = 0;
						}
						if(product.is_free_shipping || 
						   product.is_virtual || 
						   product.model_no.toLowerCase().indexOf('gift') != -1){
							free_shipping_items 	+= qty;
							free_shipping_price		+= price * tax_rate * qty;
							free_shipping_weight	+= weight * qty;
						}
						
						//update totals
						_subtotal		+= price * qty;
						_total_tax		+= price * tax_rate * qty;
						_total_price	+= price + tax;
						_total_weight	+= weight * qty;
						
						//attribute prices
						if(_contents[product_id].attributes != null){
							var attributes:Object = _contents[product_id].attributes;
							for(var option:* in attributes){
								
							}
						}
						break;
					}
				}
			}
		}
		
		/*------------------------------------------------------------
		COMMUNICATION METHODS
		------------------------------------------------------------*/
		/**
		 * Calls server
		 */
		private function call_server(vars:Object, url:String, type:String = 'text'):void{
			url = Constants.get_host() + url;
			var loader:Basic_loader = new Basic_loader();
			add_listeners(loader);
			loader.process_load(url, vars, type, 'POST');
		}
		
		/**
		 * Retrieves response from server. Expects a URLVariables object
		 * as the reply format.
		 */
		private function get_server_reply(e:Event):Array{
			remove_listeners(e.currentTarget);
			if(e.target._content_xml != null){
				var reply_xml:XML = e.target._content_xml;
				var root_node:XML = reply_xml.children()[0].parent().toXMLString();
				switch(root_node){
					case Constants.FILENAME_PRODUCT_INFO:
						parse_product_info(reply_xml);
						break;
				}
				
			}else{
				var r:String = '';
				var reply_vars:URLVariables = e.target._content;
				for(var prop:String in reply_vars){
					r += ',' + reply_vars[prop];
				}
				r = r.substr(1);
				var arr:Array = r.split(',');
				return(Common.url_decode(arr));
			}
		}
		
		/**
		 * Retrieves response from server. Expects string as the reply
		 * format..
		 */
		private function get_server_alt_reply(e:Event):Array{
			remove_listeners(e.currentTarget);
			var reply:String = e.target._content_txt;
			var arr:Array = reply.split(',');
			return(Common.url_decode(arr));
		}
		
		/**
		 * Retrieves failure response from server.
		 */
		private function parse_server_failure(e:Event):void{
			remove_listeners(e.currentTarget);
			var msg:String = e.target._content_txt;
			dispatchEvent(new Event('server_failure'));
		}
		
		/**
		 * Add event listeners
		 */
		private function add_listeners(target:Basic_loader):void{
			target.addEventListener(Basic_loader.URL_LOAD_COMPLETE, get_server_reply);
			target.addEventListener(Basic_loader.URL_LOADER_ALT_DECODE, get_server_alt_reply);
			target.addEventListener(Basic_loader.URL_LOADER_DECODE_FAILED, parse_server_failure);
		}
		
		/**
		 * Remove listeners
		 */
		private function remove_listeners(target:Basic_loader):void{
			target.removeEventListener(Basic_loader.URL_LOAD_COMPLETE, get_server_reply);
			target.removeEventListener(Basic_loader.URL_LOADER_ALT_DECODE, get_server_alt_reply);
			target.removeEventListener(Basic_loader.URL_LOADER_DECODE_FAILED, parse_server_failure);
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Creates a unique cart id
		 */
		private function create_cart_id():String{
			return Common.get_random_value(5, 'digits');
		}
		
		/**
		 * Counts the number of items in the cart.
		 */
		public function count_items():Number{
			var r:Number = 0;
			if(_contents != null){
				for(var product_id:String in _contents){
					r += get_quantity(product_id);
				}
			}
			return r;
		}
		
		/**
		 * Returns the quantity of an item
		 * @param product_id	The selected product id
		 */
		private function get_quantity(product_id:String):Number{
			var r:Number = 0;
			if(_contents.hasOwnProperty(product_id)){
				r = _contents[product_id].quantity;
			}
			return r;
		}
		
		/**
		 * Tests if a product is already in the cart.
		 * @param product_id	The selected product_id
		 */
		public function is_in_cart(product_id):Boolean{
			if(_contents.hasOwnProperty(product_id)){
				return true;
			}else{
				return false;
			}
		}
		
		/**
		 * Updates the current quantity of an item
		 * @param product_id	The item's product id
		 * @param qty			The user-defined quantity
		 */
		private function update_item_quantity(product_id:String, qty:Number):void{
			if(qty != 0 || qty != null){
				_contents[product_id].quantity = Number(qty);
			}
		}
		
		/**
		 * Removes items from the cart when the quantity <= zero.
		 */
		private function clean_up():void{
			for(var item:Object in _contents){
				if(!_contents[item].hasOwnProperty('quantity') || _contents[item].quantity <= 0){
					_contents[item] = undefined;
				}
			}
		}
		
		/**
		 * Returns a product ID with attributes appended to the string
		 * @param id			The product id
		 * @param attributes	An attribute object with option/value
		 *						properties
		 */
		private function set_long_id(product_id:*, attributes:Array):String{
			var id:String = String(product_id);
			if(attributes as Array != null && id.indexOf(':') == -1){
				for each(var key:Object in attributes){
					if(key as Array != null){
						for each(var key2:* in attributes[key]){
							id += '{' = key + '}' + Common.trim(String(attributes[key][key2]));
						}
						break;
					}else{
						id += '{' = key + '}' + Common.trim(String(attributes[key]));
					}
				}
				var hasher:MD5		= new MD5();
				var hash_id:String	= hasher.convert(id);
				return id + ':' + hash_id;
			}else{
				return id;
			}
		}
		
		/**
		 * Gets product id from md5 string
		 * @param product_id	The long string
		 */
		private function get_product_id(product_id:String):int{
			var arr:Array = product_id.split(':');
			return arr[0];
		}
		
		/**
		 * Adjusts quantity depending on the number of user-defined
		 * decimal places.
		 * @param qty	The user entered item quantity.
		 */
		private function adjust_quantity(qty:Number):Number{
			var r:Number = 0;
			var pow:int	= Math.pow(10, Shopping_cart.QUANTITY_DECIMALS);
			
			if(Shopping_cart.QUANTITY_DECIMALS != 0){
				if(qty % 0 == 0){
					r = qty.toFixed(Shopping_cart.QUANTITY_DECIMALS);
				}else{
					r = Math.round(qty * pow) / pow;
					r = r.toFixed(Shopping_cart.QUANTITY_DECIMALS);
				}
			}else{
				if(qty != qty.toFixed(Shopping_cart.QUANTITY_DECIMALS)){
					r = Math.round(qty * pow) / pow;
				}else{
					r = qty;
				}
			}
			return r;
		}
	}
}