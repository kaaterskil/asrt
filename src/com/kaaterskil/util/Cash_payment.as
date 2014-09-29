/**
 * Cash_payment.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080213
 * @package com.kaaterskil.utilities
 */

package com.kaaterskil.utilities{
	import fl.controls.RadioButtonGroup;
	import fl.controls.ButtonLabelPlacement;
	import flash.net.*;
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.net.*;
	
	import com.kaaterskil.utilities.*;
	import com.kaaterskil.utilities.CC_Validator;
	import com.kaaterskil.utilities.Basic_loader;
	
	public class Cash_payment extends Sprite{
		/**
		 * Authorize.net settings
		 */
		public var _is_enabled:Boolean;
		public var _card_types:Array;
		public var _send_url:String;
		public var _test_mode:String;
		public var _order_status:String;
		public var _order_status_id:int;
		public var _payment_method:String;
		public var _db_trans_url:String;
		
		public var _module_title:String;
		public var _module_description:String;
		
		/**
		 * Containers
		 */
		public var _validator:CC_Validator;
		public var _loader:Basic_loader;
		
		/**
		 * Customer data
		 */
		public var _customer_id:String;
		public var _customer_ip:String;
		public var _session_name:String;
		public var _session_id:String;
		
		/**
		 * Transaction data
		 */
		public var _cc_type:String;
		public var _cc_number:String;
		public var _cc_expiry_month:String;
		public var _cc_expiry_year:String;
		public var _cc_cvv2:String;
		public var _order_id:Number;
		public var _amount:Number;
		public var _description:String;
		public var _request:Object;
		
		/**
		 * Reply data
		 */
		public var _response:Object;
		public var _approval_code:String;
		public var _transaction_id:Number;
		public var _message:String;
		
		/**
		 * Text formats
		 */
		private var _format_label:TextFormat;
		private var _format_value:TextFormat;
		private var _format_field:TextFormat;
		private var _format_section:TextFormat;
		
		/**
		 * Module description
		 */
		public static const CASHPMT_FORM_DESCRIPTION = 'Please review the following information for accuracy. To make changes, click the \'Back\' button or the menus above to return to either the billing/payment or the main registration pages. NOTE: Space in our camps and clinics is limited and is assigned on a first-come, first-served basis. Paying by check or money order will not guarantee that your child has a space until payment is received. If you have any questions, please contact us.';
		
		/**
		 * Set to email the gateway response to customer
		 */
		public static const CASHPMT_EMAIL_CUSTOMER:Boolean = false;
		
		/**
		 * Set to email the gateway response to merchant
		 */
		public static const CASHPMT_EMAIL_MERCHANT:Boolean = false;
		public static const CASHPMT_COMPANY_EMAIL = 'webmaster@gglax.com';
		
		/**
		 * Set order status
		 */
		public static const CASHPMT_ORDER_STATUS = 'Pending';
		public static const ORDER_STATUS_LIST = 'Pending,Processing,Delivered,Paid,Update';
		
		/**
		 * Set payment method
		 */
		public static const CASHPMT_TEXT_TITLE = 'Cash/Check';
		public static const CASHPMT_FORM_LABEL = 'Check or Money Order';
		 
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 * @param url	The complete url string to the server to save
		 *				authorize.net transactions.
		 */
		public function Cash_payment():void{
			init();
		}
		 
		/**
		 * Initialization
		 */
		private function init():void{
			this.name			= 'Cash_payment';
			_amount				= 0;
			_module_title		= Cash_payment.CASHPMT_FORM_LABEL;
			_module_description	= Cash_payment.CASHPMT_FORM_DESCRIPTION;;
			_is_enabled			= Payment.PAYMENT_MODULE_CASHPMT_STATUS == 'Enabled' ? true : false;
			_order_status		= Cash_payment.CASHPMT_ORDER_STATUS;
			_payment_method		= Cash_payment.CASHPMT_TEXT_TITLE;
			
			var arr:Array = Cash_payment.ORDER_STATUS_LIST.split(',')
			_order_status_id = Common.array_search(_order_status, arr, false);
		}
		 
		/*------------------------------------------------------------
		ACTION METHODS
		------------------------------------------------------------*/
		/**
		 * Returns an array of form field parameters ready to be drawn
		 * into their respective components.
		 * @param arr		An array field values
		 */
		public function set_billing_fields():Array{
			var types:Array = ['meta', 'billing'];
			var arr:Array = new Array();
			for(var i:int = 0; i < types.length; i++){
				//get values for the field types
				var type:String = types[i];
				var fields:Array = set_field_values(type);
				
				//convert to drawing parameters and add to array
				arr.push(set_drawing_params(fields));
			}
			return arr;
		}
		
		/**
		 * Validates a credit card number.
		 * @param obj	An object with card information. The object 
		 *				must have at least the following properties:
		 *				cc_number, expiry_month, expiry_year, amount.
		 */
		public function pre_confirmation(obj:Object):String{
			_amount = obj.amount;
			return '';
		}
		
		/**
		 * Confirmation. This populates an array with label and data
		 * information to be used to create confirmation text.
		 * @param obj	On object containing credit card name and address
		 */
		public function confirmation(obj:Object):Array{
			var arr:Array = new Array();
			if(obj != null){
				arr.push({label:'Payment Method',	value:Cash_payment.CASHPMT_FORM_LABEL});
				arr.push({label:'First Name',		value:obj.first_name});
				arr.push({label:'Last Name',		value:obj.last_name});
				arr.push({label:'Street',			value:obj.address});
				arr.push({label:'City',				value:obj.city});
				arr.push({label:'State',			value:obj.state});
				arr.push({label:'ZIP Code',			value:obj.ZIP_Code});
				arr.push({label:'Telephone',		value:obj.telephone});
				arr.push({label:'Email',			value:obj.email});
				arr.push({label:'Amount',			value:'$' + Common.format_dollar(_amount)});
			}
			return arr;
		}
		
		/**
		 * Prepare and submit.
		 * @param pmt	An object with payment name/value pairs.
		 */
		public function submit(pmt:Object):void{
		}
		
		/*------------------------------------------------------------
		COMMUNICATION METHODS
		------------------------------------------------------------*/
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Converts field values in component drawing parameters
		 * @param arr	An array of field values
		 */
		private function set_drawing_params(arr:Array):Array{
			//set templates
			set_text_formats();
			var module_styles:Array 	= [['embedFonts', true], ['textFormat', _format_section]];
			var label_styles:Array 		= [['embedFonts', true], ['textFormat', _format_label]];
			var field_txt_styles:Array	= [['embedFonts', true], ['textFormat', _format_field], ['textPadding', 1]];
			
			//set values
			var r:Array = new Array();
			for(var i:int = 0; i < arr.length; i++){
				var field:Object = arr[i];
				
				var obj:Object = new Object();
				//set meta data
				obj.column 			= Number(field.column);
				obj.field_name		= String(field.field_name);
				obj.required		= Boolean(field.required);
				obj.form_type		= String(field.form_type);
				obj.on_focus_out	= String(field.on_change);
				
				//set field and label data
				obj.label_params = new Object();
				obj.field_params = new Object();
				switch(obj.form_type){
					case 'varchar':
					case'text':
						obj.label_params.format = _format_label;
						obj.label_params.styles = label_styles;
						obj.label_params.props = {autoSize:TextFieldAutoSize.LEFT,
												  embedFonts:true,
												  enabled:false,
												  focusEnabled:false,
												  tabEnabled:false,
												  wordWrap:false,
												  text:String(field.form_label)
												  };
						obj.field_params.format = _format_field;
						obj.field_params.styles = field_txt_styles;
						obj.field_params.props = {autoSize:TextFieldAutoSize.LEFT,
												  editable:true,
												  embedFonts:true,
												  enabled:true,
												  maxChars:int(field.max_size),
												  restrict:String(field.pattern),
												  tabIndex:int(field.tab),
												  text:String(field.field_value),
												  wordWrap:false
												  };
						break;
					case 'radio_button':
						if(obj.field_name == 'module'){
							obj.field_params.styles = module_styles;
						}else{
							obj.field_params.styles = label_styles;
						}
						obj.field_params.props = {enabled:true,
												  groupName:String(field.group_name),
												  label:String(field.form_label),
												  labelPlacement:ButtonLabelPlacement.RIGHT,
												  selected:false,
												  tabEnabled:Boolean(field.tab_enabled),
												  tabIndex:int(field.tab),
												  value:String(field.field_value)
												  };
						break;
					case 'check_box':
						obj.field_params.styles = label_styles;
						obj.field_params.props = {enabled:true,
												  label:String(field.form_label),
												  labelPlacement:ButtonLabelPlacement.RIGHT,
												  selected:false,
												  tabEnabled:true,
												  tabIndex:int(field.tab),
												  value:String(field.field_value)
												  };
						break;
					case 'select':
						obj.label_params.styles = label_styles;
						obj.label_params.props = {autoSize:TextFieldAutoSize.LEFT,
												  enabled:false,
												  focusEnabled:false,
												  tabEnabled:false,
												  wordWrap:false,
												  text:String(field.form_label)
												  };
						obj.field_params.props = {tabEnabled:true,
												  tabIndex:int(field.tab)
												  };
						break;
					case 'list':
						break;
					case 'hidden':
						break;
				}
				//add to array
				r.push(obj);
			}
			return r;
		}
		
		/**
		 * Sets values for billing fields
		 * @param type	The type of field (module vs data field)
		 */
		private function set_field_values(type:String):Array{
			var arr:Array = new Array();
			if(type == 'meta'){
				arr.push({column:		1,
						 field_name:	'module',
						 required:		true,
						 form_type:		'radio_button',
						 on_change:		'module_selected',
						 group_name:	'pmt_method',
						 form_label:	Cash_payment.CASHPMT_FORM_LABEL.toUpperCase(),
						 tab:			1,
						 tab_enabled:	false,
						 field_value:	this.name
						 });
			}else if(type == 'billing'){
				arr.push({column:		1,
						 field_name:	'first_name',
						 required:		true,
						 form_type:		'text',
						 on_change:		'',
						 max_size:		20,
						 pattern:		'text',
						 form_label:	'First Name:',
						 tab:			1,
						 field_value:	''
						 });
				arr.push({column:		1,
						 field_name:	'last_name',
						 required:		true,
						 form_type:		'text',
						 on_change:		'',
						 max_size:		30,
						 pattern:		'text',
						 form_label:	'Last Name:',
						 tab:			2,
						 field_value:	''
						 });
				arr.push({column:		1,
						 field_name:	'address',
						 required:		true,
						 form_type:		'text',
						 on_change:		'',
						 max_size:		34,
						 pattern:		'text',
						 form_label:	'Street:',
						 tab:			3,
						 field_value:	''
						 });
				arr.push({column:		1,
						 field_name:	'city',
						 required:		true,
						 form_type:		'text',
						 on_change:		'',
						 max_size:		18,
						 pattern:		'text',
						 form_label:	'Town/City:',
						 tab:			4,
						 field_value:	''
						 });
				arr.push({column:		1,
						 field_name:	'state',
						 required:		true,
						 form_type:		'select',
						 on_change:		'',
						 form_label:	'State:',
						 tab:			5
						 });
				arr.push({column:		1,
						 field_name:	'ZIP_Code',
						 required:		true,
						 form_type:		'text',
						 on_change:		'',
						 max_size:		10,
						 pattern:		'integer',
						 form_label:	'ZIP Code:',
						 tab:			6,
						 field_value:	''
						 });
				arr.push({column:		2,
						 field_name:	'telephone',
						 required:		true,
						 form_type:		'text',
						 on_change:		'format_telephone',
						 max_size:		14,
						 pattern:		'telephone',
						 form_label:	'Telephone:',
						 tab:			7,
						 field_value:	''
						 });
				arr.push({column:		2,
						 field_name:	'email',
						 required:		false,
						 form_type:		'text',
						 on_change:		'validate_email',
						 max_size:		90,
						 pattern:		'email',
						 form_label:	'Email:',
						 tab:			8,
						 field_value:	''
						 });
			}
			return arr;
		}

		/**
		 * Set text formats
		 */
		private function set_text_formats():void{
			_format_label = new TextFormat();
			_format_label.font		= 'FFF Strategy';
			_format_label.size		= 8;
			_format_label.color 	= 0x888888;
			
			_format_value = new TextFormat();
			_format_value.font		= 'FFF Strategy';
			_format_value.size		= 8;
			_format_value.color 	= 0x000000;

			_format_field = new TextFormat();
			_format_field.font			= 'Courier New';
			_format_field.size			= 12;
			_format_field.color			= 0x000000;
			_format_field.leftMargin	= 2;
			_format_field.leading		= 0;

			_format_section = new TextFormat();
			_format_section.font	= 'Tw Cen MT Condensed Extra Bold';
			_format_section.size	= 11;
			_format_section.color	= 0x990000;
			_format_section.bold	= true;
		}
	}
}