/**
 * CC_Validator.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080112
 * @package com.kaaterskil.utilities
 */

 
package com.kaaterskil.utilities{
	import com.kaaterskil.utilities.Common;
	
	public class CC_Validator{
		/**
		 * Trackers
		 */
		internal var _card_types:Object;
		
		/**
		 * User card information
		 */
		internal var _cc_type:String;
		internal var _cc_number:String;
		internal var _cc_expiry_month:Number;
		internal var _cc_expiry_year:Number;
		
		/**
		 * Constants - NOTE: THIS SHOULD BE CONFIRM WITH CLIENT
		 */
		public static const VISA_ENABLED:Boolean		= true;
		public static const MC_ENABLED:Boolean			= true;
		public static const DISCOVER_ENABLED:Boolean	= true;
		public static const AX_ENABLED:Boolean			= true;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function CC_Validator():void{
			set_card_types();
		}
		
		/*------------------------------------------------------------
		VALIDATION METHODS
		------------------------------------------------------------*/
		/**
		 * Validate card.
		 * @param obj		An object containing credit card parameters
		 * @result			Possible result values:
		 *					-4	Expired card
		 *					-3	Bad year
		 *					-2	Bad month
		 *					-1	Bad card number OR card not enabled
		 *					0	Bad card number
		 *					1	OK
		 */
		public function validate(obj:Object):Number{
			var cc_number:String	= String(obj.cc_number);
			var expiry_mo:Number	= Number(obj.cc_expiry_month);
			var expiry_yr:Number	= Number(obj.cc_expiry_year);
			
			//clean up credit card number
			var ptn:RegExp = /[^0-9]/g;
			_cc_number = cc_number.replace(ptn, '');
			
			//validate card number and status
			var visa_ptn:RegExp = /^4[0-9]{12}([0-9]{3})?$/;
			var mc_ptn:RegExp	= /^5[1-5][0-9]{14}$/;
			var disc_ptn:RegExp	= /^6011[0-9]{12}$/;
			var ax_ptn:RegExp	= /^3[47][0-9]{13}$/;
			
			if(visa_ptn.test(_cc_number) && _card_types.visa.enabled){
				_cc_type = _card_types.visa.value;
				
			}else if(mc_ptn.test(_cc_number) && _card_types.mc.enabled){
				_cc_type = _card_types.mc.value;
				
			}else if(disc_ptn.test(_cc_number) && _card_types.discover.enabled){
				_cc_type = _card_types.discover.value;
				
			}else if(ax_ptn.test(_cc_number) && _card_types.ax.enabled){
				_cc_type = _card_types.ax.value;
				
			}else{
				return -1;
			}
			
			var now = new Date();
			var curr_yr = now.getFullYear();
			var curr_mo = now.getMonth();
			
			//validate card expire month
			//NOTE: actionscript starts January at 0
			if(expiry_mo >= 0 && expiry_mo <= 11){
				_cc_expiry_month = expiry_mo;
			}else{
				return -2;
			}
			
			//validate card expire year
			if(expiry_yr >= curr_yr && expiry_yr <= (curr_yr + 10)){
				_cc_expiry_year = expiry_yr;
			}else{
				return -3;
			}
			
			//validate expire date as a whole
			if(_cc_expiry_year == curr_yr && _cc_expiry_month < curr_mo){
				return -4;
			}
			return validate_number();
		}
		
		/**
		 * Card number validation algorithm
		 */
		private function validate_number():Number{
			var card_number = Common.str_reverse(_cc_number);
			var sum:Number = 0;
			
			for(var i:int = 0; i < card_number.length; i++){
				var curr_num:Number = Number(card_number.charAt(i));
				
				//double every second digit
				if(i % 2 == 1){
					curr_num *= 2;
				}
				//add digits of 2-digit numbers together
				if(curr_num > 9){
					var num1:Number = curr_num % 10;
					var num2:Number = (curr_num - num1) / 10;
					curr_num = num1 + num2;
				}
				sum += curr_num;
			}
			
			//return result
			var r:Number = sum % 10 == 0 ? 1 : 0;
			return r;
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Set card types
		 */
		private function set_card_types():void{
			var visa:Object	= {label:'Visa', 
							   value:'Visa', 
							   enabled:CC_Validator.VISA_ENABLED
							   };
			var mc:Object	= {label:'MasterCard', 
							   value:'MasterCard', 
							   enabled:CC_Validator.MC_ENABLED
							   };
			var disc:Object	= {label:'Discover', 
							   value:'Discover', 
							   enabled:CC_Validator.DISCOVER_ENABLED
							   };
			var amex:Object	= {label:'American Express', 
							   value:'Amex', 
							   enabled:CC_Validator.AX_ENABLED
							   };
			_card_types = {visa:visa, mc:mc, discover:disc, ax:amex};
		}
	}
}