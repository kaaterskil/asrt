/**
 * Cart_functions.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080412
 * @package com.kaaterskil.cart
 */

package com.kaaterskil.cart{
	public class Cart_functions{
		private static const TEXT_DEDUCTION_TYPE0 = 'Deduct amount';
		private static const TEXT_DEDUCTION_TYPE1 = 'Percent';
		private static const TEXT_DEDUCTION_TYPE2 = 'New Price';
		
		public static function get_discount_type(product:Object, sales:Array):*{
			var category_id:int			= product.category_id;
			var sale_exists:Boolean 	= false;
			var discount:Number			= 0;
			var condition:int			= 0;
			var discount_type:int		= 0;
			var special_price:Number	= 0;
			var deduction_types:Array = [{id:0, text:Cart_functions.TEXT_DEDUCTION_TYPE0}, 
										 {id:1, text:Cart_functions.TEXT_DEDUCTION_TYPE1}, 
										 {id:2, text:Cart_functions.TEXT_DEDUCTION_TYPE2}
										 ];
			
			for(var i:int = 0; i < sales.length; i++){
				var s:Object = sales[i];
				var categories:Array = s.sale_categories_all.split(',');
				for each(var id:int in categories){
					if(id == category_id){
						sale_exists 	= true;
						discount		= s.hasOwnProperty('sale_value') ? s.sale_value : 0;
						condition		= s.hasOwnProperty('sale_condition') ? s.sale_condition : 0;
						discount_type	= s.hasOwnProperty('sale_type') ? s.sale_type: 0;
						break;
					}
				}
			}
		}
	}
}