/**
 * Product_handler.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080410
 * @package com.kaaterskil.cart
 */
 
package com.kaaterskil.cart{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import com.kaaterskil.utilities.*;
	
	public class Product_handler extends Sprite{
		/**
		 * Constants
		 */
		private static const TEXT_DEDUCTION_TYPE0 = 'Deduct amount';
		private static const TEXT_DEDUCTION_TYPE1 = 'Percent';
		private static const TEXT_DEDUCTION_TYPE2 = 'New Price';
		private static const OPTION_TYPES = ['select', 'text', 'radio', 'checkbox', 'file'];
		
		/**
		 * Libraries
		 */
		public var _options:Array;
		public var _option_values:Array;
		public var _categories:Array;
		public var _products:Array;
		public var _sales:Array;
		public var _specials:Array;
		public var _volume_discounts:Array;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Product_handler():void{
		}
		
		/*------------------------------------------------------------
		DISCOUNT METHODS
		------------------------------------------------------------*/
		/**
		 * Get discount
		 */
		public function get_discount(product_id:int,  
									  attribute_id:int = 0, 
									  test_price:Number = 0,
									  test_qty:Number = 0):Number{
			//for attributes with no price
			if(attribute_id > 0 && test_price == 0){
				return 0;
			}
			
			var product_price:Number	= get_base_price(product_id);
			var special_price:Number	= get_special_price(product_id, true);
			var sale_price:Number		= get_special_price(product_id, false);
			var discount_type:Number	= get_discount_type(product_id);
			
			var special_discount:Number = 0;
			if(product_price != 0){
				special_discount = special_price != 0 ? special_price / product_price : 1;
			}
			
			var discount:Number = get_discount_type(product_id, 'amount');
			if((discount_type == 120 || discount_type == 1209) || 
				(discount_type == 110 || discount_type == 1109)){
				discount = discount != 0 ? (100 - discount) / 100 : 1;
			}
			
			var r:Number = 0;
			if(has_volume_discount(product_id, test_qty)){
				if(attribute_id == 0){
					//this is not an attribute
					r = get_volume_discount_price(product_id, test_qty, test_price);
				}else if(get_value(product_id, 'product_is_priced_by_attribute')){
					r = get_volume_discount_price(product_id, test_qty, test_price);
				}
				return r;
			}
			switch(discount_type){
				case 5:
					//no sale and no special
					if(attribute_id == 0){
						r = discount;
					}else{
						if(test_price != 0){
							r = special_discount != 0 ? test_price * special_discount : test_price;
						}else{
							r = discount;
						}
					}
					break;
				case 59:
					//no sale and special
					if(attribute_id == 0){
						r = discount;
					}else{
						if(test_price != 0){
							r = test_price * special_discount;
						}else{
							r = discount;
						}
					}
					break;
				case 120:
					//percentage discount sale and special without a special
					if(attribute_id == 0){
						r = discount;
					}else{
						if(test_price != 0){
							r = test_price * discount;
						}else{
							r = discount;
						}
					}
					break;
				case 1209:
					//percentage discount sale and special with a special
					if(attribute_id == 0){
						r = discount;
					}else{
						if(test_price != 0){
							var tmp1:Number	= test_price * special_discount;
							var tmp2:Number	= tmp1 - (tmp1 * discount)
							r = tmp1 - tmp2;
						}else{
							r = discount;
						}
					}
					break;
				case 110:
					//percentage discount sale and special without a special
					if(attribute_id == 0){
						r = discount;
					}else{
						if(test_price != 0){
							r = test_price - (test_price * discount);
						}else{
							r = discount;
						}
					}
					break;
				case 1109:
					//percentage discount ale and special with a special
					if(attribute_id == 0){
						r = discount;
					}else{
						if(test_price != 0){
							r = test_price * special_discount;
						}else{
							r = discount;
						}
					}
					break;
				case 20:
					//flat discount sale and special without a special
					if(attribute_id == 0){
						r = discount;
					}else{
						if(test_price != 0){
							r = test_price - discount;
						}else{
							r = discount;
						}
					}
					break;
				case 209:
					//flat amount discount sale and special with a special
					if(attribute_id == 0){
						r = discount;
					}else{
						if(test_price != 0){
							r = test_price * special_discount;
							r -= discount;
						}else{
							r = discount;
						}
					}
					break;
				case 10:
					//flat amount idscount sale and special without a special
					if(attribute_id == 0){
						r = discount;
					}else{
						if(test_price != 0){
							r = test_price * discount;
						}else{
							r = discount;
						}
					}
					break;
				case 109:
					//flat amount discount sale and special with a special
					if(attribute_id == 0){
						r = 1;
					}else{
						if(test_price != 0){
							r = test_price * special_discount;
						}else{
							r = discount;
						}
					}
					break;
				case 220:
					//new price discount sale and special without a special
					if(attribute_id == 0){
						r = discount;
					}else{
						if(test_price != 0){
							r = test_price * discount;
						}else{
							r = discount;
						}
					}
					break;
				case 2209:
					//new price discount sale and special with a special
					if(attribute_id == 0){
						r = discount;
					}else{
						if(test_price != 0){
							r = test_price * special_discount;
						}else{
							r = discount;
						}
					}
					break;
				case 210:
					//new price discount sale and special without a special
					if(attribute_id == 0){
						r = discount;
					}else{
						if(test_price != 0){
							r = test_price * discount;
						}else{
							r = discount;
						}
					}
					break;
				case 2109:
					//new price discount sale and special with a special
					if(attribute_id == 0){
						r = discount;
					}else{
						if(test_price != 0){
							r = test_price * special_discount;
						}else{
							r = discount;
						}
					}
					break;
				case 0:
				case 9:
					r = discount;
					break;
				default:
					r = 7000;
					break;
			}
			return r;
		}
		
		/**
		 * Get the discount type
		 * @param product_id	The id of the selected product.
		 * @param dollar_test	A flag to return the dollar value (true)
		 *						or discount type (false).
		 */
		public function get_discount_type(product_id:int, dollar_test:* = false):Number{
			var category_id:int = get_value(product_id, 'category_id');
			
			//get sale price
			var sale_exists:Boolean = false;
			var discount:Number		= 0;
			var condition:int		= 0;
			var discount_type:int	= 0;
			for(var i:int = 0; i < _sales.length; i++){
				var s:Object = _sales[i];
				if(s.sale_status){
					var categories:Array = s.sale_categories_all.split(',');
					for each(var id:int in categories){
						if(id == category_id){
							sale_exists 	= true;
							discount		= s.sale_value > 0 ? s.sale_value : 0;
							condition		= s.sale_condition > 0 ? s.sale_condition : 0;
							discount_type	= s.sale_type > 0 ? s.sale_type: 0;
							break;
						}
					}
				}
			}
			//get special price
			var special_price:Number = get_special_price(product_id, true);
			
			//set discount type
			if(sale_exists && condition != 0){
				discount_type = (discount_type * 100) + (condition * 10);
			}else{
				discount_type = 5;
			}
			if(special_price > 0){
				discount_type = (discount_type * 10) + 9;
			}
			
			//return
			if(!dollar_test){
				return discount_type;
			}else if(dollar_test == 'amount'){
				return discount;
			}else{
				return 0;
			}
		}
		
		/*------------------------------------------------------------
		PRICE METHODS
		------------------------------------------------------------*/
		/**
		 * Get actual price.
		 * @param product_id	The is of the selected product.
		 */
		private function get_actual_price(product_id:int):Number{
			var tax_class:int					= 0;
			var price:Number					= 0;
			var is_priced_by_attribute:Boolean	= false;
			var is_free:Boolean					= false;
			var is_call:Boolean					= false;
			for(var i:int = 0; i < _products.length; i++){
				var p:Object = _products[i];
				if(p.product_id == product_id){
					tax_class				= p.product_tax_class_id;
					price					= p.product_price;
					is_priced_by_attribute	= p.product_is_priced_by_attribute;
					is_free					= p.product_is_free;
					is_call					= p.product_is_call;
					break;
				}
			}
			var base_price:Number		= get_base_price(product_id);
			var special_price:Number	= get_special_price(product_id, true);
			var sale_price:Number		= get_special_price(product_id, false);
			
			var r:Number = base_price;
			if(special_price > 0){
				r = special_price;
			}
			if(sale_price > 0){
				r = sale_price
			}
			if(is_free){
				r = 0;
			}
			return r;
		}
		
		/**
		 * Get product base price
		 * @param product_id	The selected product id
		 */
		private function get_base_price(product_id:int):Number{
			var product_price:Number	= 0;
			var attribute_price:Number	= 0;
			var attribute_test:Boolean	= false;
			
			//get product price
			for(var i:int = 0; i < _products.length; i++){
				var p:Object = _products[i];
				if(p.product_id == product_id){
					product_price	= p.product_price;
					attribute_test	= p.product_is_priced_by_attribute;
					break;
				}
			}
			
			//accumulate attribute prices
			if(attribute_test && (p.attributes is Array) && (p.attributes.length > 0)){
				for(var j:int = 0; j < p.attributes.length; i++){
					var a:Object = p.attributes[i];
					if(!a.attribute_is_display_only && !a.attribute_is_base_price_included){
						attribute_price += a.attribute_price;
					}
				}
			}
			return product_price + attribute_price;
		}
		
		/**
		 * Get special price
		 * @param product_id	The selected product id
		 */
		private function get_special_price(product_id:int, special_only:Boolean = false):Number{
			//get base price
			var category_id:int		= 0;
			var base_price:Number	= get_base_price(product_id);
			
			//get specials price
			var special_price:Number = 0;
			for(i = 0; i < _specials.length; i++){
				var s:Object = _specials[i];
				if(s.special_product_id == product_id && s.special_status){
					special_price = s.special_price;
				}
			}
			
			//test for gift
			var gift_test:Boolean = false;
			for(var i:int = 0; i < _products.length; i++){
				var p:Object = _products[i];
				if(p.product_id == product_id){
					category_id = p.category_id;
					if(p.product_SKU.toLowerCase().indexOf('gift') != -1){
						gift_test = true;
					}
					break;
				}
			}
			if(gift_test || special_only){
				if(special_price > 0){
					return special_price;
				}else{
					return 0;
				}
			}
			
			//get sale value
			var sale_condition:int	= 0;
			var sale_value:Number	= 0;
			var sale_type:int		= 0;
			for(i = 0; i < _sales.length; i++){
				s = _sales[i];
				var category_list:String	= s.sale_categories_all.split(',');
				var now:Date				= new Date();
				var date_start:Date			= new Date(s.sale_date_start);
				var date_end:Date			= new Date(s.sale_date_end);
				var price_from:Number		= s.sale_pricerange_from;
				var price_to:Number			= s.sale_pricerange_to;
				
				var category_test:Boolean = false;
				for each(var id:* in category_list){
					if(int(id) == category_id){
						category_test = true;
						break;
					}
				}
				
				if(category_test && s.sale_status && (date_start <= now) && (date_end >= now) && (price_from <= base_price) && (price_to >= base_price)){
					sale_condition	= s.sale_condition;
					sale_value		= s.sale_value;
					sale_type		= s.sale_type;
					break;
				}
			}
			
			//compare
			if(sale_value > 0){
				var sale_base:Number	= 0;
				var sale_special:Number	= 0;
				var temp:Number = special_price > 0 ? special_price : base_price;
				switch(sale_type){
					case 0:
						//for dollar deduction
						sale_base 		= base_price - sale_value;
						sale_special	= temp - sale_value;
						break;
					case 1:
						//per percentage
						sale_base		= base_price - (base_price * (sale_value / 100));
						sale_special	= temp - (temp * (sale_value / 100));
						break;
					case 2:
						//for whole price
						sale_base		= sale_value;
						sale_special	= sale_value;
						break;
					default:
						return special_price;
						break;
				}
				sale_base 		= sale_base < 0 ? 0 : sale_base;
				sale_special	= sale_special < 0 ? 0 : sale_special;
				
				var r:Number = 0;
				if(special_price == 0){
					r = sale_base;
				}else{
					switch(sale_condition){
						case 0:
							r = sale_base;
							break;
						case 1:
							r = special_price;
							break;
						case 2:
							r = sale_special;
							break;
						default:
							r = special_price;
							break;
					}
				}
			}else{
				r = special_price;
			}
			return r;
		}
		
		/**
		 * Get volume discount price.
		 * @param product_id	The id of the selected product.
		 */
		private function get_volume_discount_price(product_id:int, 
											 test_qty:Number, 
											 test_price:Number = 0):Number{
			//get product info
			var discount_type:int		= 0;
			var discount_type_from:int	= 0;
			for(var i:int = 0; i < _products.length; i++){
				var p:Object = _products[i];
				if(p.product_id == product_id){
					discount_type			= p.product_discount_type;
					discount_type_from		= p.product_discount_type_from;
					break;
				}
			}
			
			//get volume discount info
			var arr:Array = new Array();
			if(has_volume_discount(product_id, test_qty)){
				for(i = 0; i < _volume_discounts.length; i++){
					var vd:Object = _volume_discounts[i];
					if(vd.discount_product_id == product_id && vd.discount_qty <= test_qty){
						arr.push(vd);
					}
				}
			}else{
				return get_actual_price(product_id);
			}
			
			//get greatest discount
			arr.sortOn('discount_qty', Array.NUMERIC | Array.DESCENDING);
			vd = arr[0];
			
			var r:Number 				= 0;
			var base_price:Number		= get_base_price(product_id);
			var special_price:Number	= get_special_price(product_id, true);
			switch(discount_type){
				case 0:
					//no discount
					r = get_actual_price(product_id);
					break;
				case 1:
					//percentage discount
					if(discount_type_from == 0){
						if(test_price != 0){
							r = test_price - (test_price * (vd.discount_price / 100))
						}else{
							r = base_price - (base_price * (vd.discount_price / 100));
						}
					}else{
						if(special_price > 0){
							r = special_price - (special_price * (vd.discount_price / 100));
						}else{
							if(test_price != 0){
								r = test_price - (test_price * (vd.discount_price / 100));
							}else{
								r = base_price - (base_price * (vd.discount_price / 100));
							}
						}
					}
					break;
				case 2:
					//actual price
					if(discount_type_from == 0){
						r = vd.discount_price;
					}else{
						r = vd.discount_price;
					}
					break;
				case 3:
					//amount off-price
					if(discount_type_from == 0){
						r = base_price - vd.discount_price;
					}else{
						if(special_price > 0){
							r = special_price - vd.discount_price;
						}else{
							r = base_price - vd.discount_price;
						}
					}
					break;
			}
			return r;
		}
		
		/**
		 * 
		
		/*------------------------------------------------------------
		ATTRIBUTE PRICE METHODS
		------------------------------------------------------------*/
		public function get_attribute_price(product_id:int, 
											 attribute_id:int, 
											 qty:Number = 1, 
											 include_onetime:Boolean = false):Number{
			var r:Number = 0;
			var attributes:Array = get_value(product_id, 'attributes');
			for each(var a:Object in attributes){
				if(a.attribute_id == attribute_id){
					//get attribute price
					if(a.attribute_price_prefix == '-'){
						r = -a.attribute_price;
					}else{
						r = a.attribute_price;
					}
					
					//get attribute volume discount
					r += get_attribute_volume_price(a.attribute_qty_prices, qty);
					
					//get attribute price factor
					var base_price:Number 		= get_actual_price(product_id);
					var special_price:Number	= get_special_price(product_id);
					var apf:Number				= a.attribute_price_factor;
					var apfo:Number				= a.attribute_price_factor_offset;
					r += get_attribute_price_factor(base_price, special_price, apf, apfo);
					
					//include onetime
					if(include_onetime){
						r += get_attribute_onetime_price(product_id, attribute_id, 1);
					}
					break;
				}
			}
			return r;
		}
		
		public function get_attribute_onetime_price(product_id:int, 
													 attribute_id:int, 
													 qty:Number = 1):Number{
			var r:Number = 0;
			var attributes:Array = get_value(product_id, 'attributes');
			for each(var a:Object in attributes){
				if(a.attribute_id == attribute_id){
					//get attribute onetime price
					r = a.attribute_price_onetime;
					
					//get attribute onetime price factor
					var base_price:Number 		= get_actual_price(product_id);
					var special_price:Number	= get_special_price(product_id);
					var apf:Number				= a.attribute_price_factor_onetime;
					var apfo:Number				= a.attribute_price_factor_onetime_offset;
					r += get_attribute_price_factor(base_price, special_price, apf, apfo);
					
					//onetime volume price
					r += get_attribute_volume_price(a.attribute_qty_prices_onetime, 1)
					break;
				}
			}
			return r;
		}
		
		/**
		 * Return an attribute's volume price based on quantity
		 * @param str	The attribute's volume price string
		 * @param qty	The attribute's quantity test
		 */
		private function get_attribute_volume_price(str:String, qty:Number):Number{
			var r:Number	= 0;
			
			var ptn:RegExp 	= /[:,]/;
			var arr:Array 	= str.split(ptn);
			for(var i:int = 0; i < arr.length; i += 2){
				r = i + 1 < arr.length ? arr[i + 1] : 0;
				if(qty <= arr[i]){
					r = i + 1 < arr.length ? arr[i + 1] : 0;
					break;
				}
			}
			return r;
		}
		
		/**
		 * Returns product price adjusted by attribute factor.
		 * @param base_price		The product's base price
		 * @param special_price		The product's special price
		 * @param factor			The attribute price factor
		 * @param offset			The attribute factor's offset
		 */
		private function get_attribute_price_factor(base_price:Number, 
													special_price:Number, 
													factor:Number, 
													offset:Number):Number{
			var r:Number = 0;
			if(special_price > 0){
				r = special_price * (factor - offset);
			}else{
				r = base_price * (factor - offset);
			}
			return r;
		}
		
		/*------------------------------------------------------------
		COMMUNICATION METHODS
		------------------------------------------------------------*/
		/**
		 * Retrieve option info
		 * @param url	The server url request string
		 * @param vars	An object of name/value parameters to send to
		 * 				the server
		 */
		public function get_options(url:String, vars:Object = null):void{
			var loader:Basic_loader = new Basic_loader();
			loader.addEventListener(Basic_loader.URL_LOAD_COMPLETE, build_option_library);
			loader.process_load(url, vars, 'xml', 'GET');
		}
		
		/**
		 * Retrieve option values info
		 * @param url	The server url request string
		 * @param vars	An object of name/value parameters to send to
		 * 				the server
		 */
		public function get_option_values(url:String, vars:Object = null):void{
			var loader:Basic_loader = new Basic_loader();
			loader.addEventListener(Basic_loader.URL_LOAD_COMPLETE, build_option_values_library);
			loader.process_load(url, vars, 'xml', 'GET');
		}
		
		/**
		 * Retrieve category info
		 * @param url	The server url request string
		 * @param vars	An object of name/value parameters to send to
		 * 				the server
		 */
		public function get_categories(url:String, vars:Object = null):void{
			var loader:Basic_loader = new Basic_loader();
			loader.addEventListener(Basic_loader.URL_LOAD_COMPLETE, build_category_library);
			loader.process_load(url, vars, 'xml', 'GET');
		}
		
		/**
		 * Retrieve product info
		 * @param url	The server url request string
		 * @param vars	An object of name/value parameters to send to
		 * 				the server
		 */
		public function get_products(url:String, vars:Object = null):void{
			var loader:Basic_loader = new Basic_loader();
			loader.addEventListener(Basic_loader.URL_LOAD_COMPLETE, build_product_library);
			loader.process_load(url, vars, 'xml', 'GET');
		}
		
		/**
		 * Retrieve sale info
		 * @param url	The server url request string
		 * @param vars	An object of name/value parameters to send to
		 * 				the server
		 */
		public function get_sales(url:String, vars:Object = null):void{
			var loader:Basic_loader = new Basic_loader();
			loader.addEventListener(Basic_loader.URL_LOAD_COMPLETE, build_sale_library);
			loader.process_load(url, vars, 'xml', 'GET');
		}
		
		/**
		 * Retrieve specials info
		 * @param url	The server url request string
		 * @param vars	An object of name/value parameters to send to
		 * 				the server
		 */
		public function get_specials(url:String, vars:Object = null):void{
			var loader:Basic_loader = new Basic_loader();
			loader.addEventListener(Basic_loader.URL_LOAD_COMPLETE, build_specials_library);
			loader.process_load(url, vars, 'xml', 'GET');
		}
		
		/**
		 * Retrieve volume discounts info
		 * @param url	The server url request string
		 * @param vars	An object of name/value parameters to send to
		 * 				the server
		 */
		public function get_volume_discounts(url:String, vars:Object = null):void{
			var loader:Basic_loader = new Basic_loader();
			loader.addEventListener(Basic_loader.URL_LOAD_COMPLETE, build_volume_discount_library);
			loader.process_load(url, vars, 'xml', 'GET');
		}
		
		/*------------------------------------------------------------
		LIBRARY METHODS
		------------------------------------------------------------*/
		/**
		 * Build option library
		 */
		private function build_option_library(e:Event):void{
			e.target.removeEventListener(Basic_loader.URL_LOAD_COMPLETE, build_option_library);
			var reply:XML	= e.target._content_xml;
			_options		= Common.parse_xml(reply);
		}
		
		/**
		 * Build option values library
		 */
		private function build_option_values_library(e:Event):void{
			e.target.removeEventListener(Basic_loader.URL_LOAD_COMPLETE, build_option_values_library);
			var reply:XML	= e.target._content_xml;
			_option_values	= Common.parse_xml(reply);
		}
		
		/**
		 * Build category library
		 */
		private function build_category_library(e:Event):void{
			e.target.removeEventListener(Basic_loader.URL_LOAD_COMPLETE, build_category_library);
			var reply:XML	= e.target._content_xml;
			_categories		= Common.parse_xml(reply);
		}
		
		/**
		 * Build product library.
		 */
		private function build_product_library(e:Event):void{
			e.target.removeEventListener(Basic_loader.URL_LOAD_COMPLETE, build_product_library);
			var reply:XML	= e.target._content_xml;
			_products		= Common.parse_xml(reply);
			//trace(Common.enumerate_obj(_products));
		}
		
		/**
		 * Build sale library.
		 */
		private function build_sale_library(e:Event):void{
			e.target.removeEventListener(Basic_loader.URL_LOAD_COMPLETE, build_sale_library);
			var reply:XML	= e.target._content_xml;
			_sales			= Common.parse_xml(reply);
		}
		
		/**
		 * Build specials library.
		 */
		private function build_specials_library(e:Event):void{
			e.target.removeEventListener(Basic_loader.URL_LOAD_COMPLETE, build_specials_library);
			var reply:XML	= e.target._content_xml;
			_specials		= Common.parse_xml(reply);
		}
		
		/**
		 * Build discount_qty library
		 */
		private function build_volume_discount_library(e:Event):void{
			e.target.removeEventListener(Basic_loader.URL_LOAD_COMPLETE, build_volume_discount_library);
			var reply:XML		= e.target._content_xml;
			_volume_discounts	= Common.parse_xml(reply);
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Return a product property
		 * @param product_id	The id of the selected product
		 * @param prop			The property to test
		 */
		public function get_value(product_id:int, prop:String):*{
			var r:*;
			for(var i:int = 0; i < _products.length; i++){
				var p:Object = _products[i];
				if(p.product_id == product_id){
					r = p.hasOwnProperty(prop) ? p[prop] : null;
					break;
				}
			}
			return r;
		}
		
		/**
		 * Test for volume discounts.
		 * @param product_id	The id of the selected product.
		 */
		private function has_volume_discount(product_id:int, qty:Number):Boolean{
			var r:Boolean = false;
			for(var i:int = 0; i < _volume_discounts.length; i++){
				var vd:Object = _volume_discounts[i];
				if((vd.discount_product_id == product_id) && (vd.discount_qty <= qty)){
					r = true;
					break;
				}
			}
			return r;
		}
	}
}