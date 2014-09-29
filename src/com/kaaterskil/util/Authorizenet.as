/**
 * Authorizenet.as
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
	
	public class Authorizenet extends Sprite{
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
		 * Set to email the gateway response to customer
		 */
		public static const AUTHORIZENET_EMAIL_CUSTOMER:Boolean = false;
		
		/**
		 * Module description
		 */
		public static const AUTHORIZENET_FORM_DESCRIPTION = 'Please review the following information for accuracy. To make changes, click the \'Back\' button or the menus above to return to either the billing/payment or the main registration pages.';
		
		/**
		 * Set to email the gateway response to merchant
		 */
		public static const AUTHORIZENET_EMAIL_MERCHANT:Boolean = false;
		public static const AUTHORIZENET_COMPANY_EMAIL = 'webmaster@gglax.com';
		
		/**
		 * Set Authorize.net test mode
		 * @option Live, Test
		 */
		public static const AUTHORIZENET_MODE = 'Test';
		
		/**
		 * Set API login name
		 */
		public static const AUTHORIZENET_LOGIN = '9cN9E5aUj7L2';
		
		/**
		 * Set API transaction key
		 */
		public static const AUTHORIZENET_TXNKEY = '7q6Jt23n7wXW7S3x';
		
		/**
		 * Set this variable to TRUE to route all the API requests through a a proxy.
		 */
		public static const AUTHORIZENET_USE_PROXY:Boolean = false;
		
		/**
		 * Set the host name or the IP address of the proxy server.
		 * This will be read onoy if USE_PROXY is set to TRUE.
		 */
		public static const AUTHORIZENET_PROXY_HOST = '';
		
		/**
		 * Set proxy port
		 * This will be read onoy if USE_PROXY is set to TRUE.
		 */
		public static const AUTHORIZENET_PROXY_PORT = '';
		
		/**
		 * Define the Authorize.net production url
		 * https://secure.authorize.net/gateway/transact.dll
		 */
		public static const AUTHORIZENET_URL_LIVE = 'https://secure.authorize.net/gateway/transact.dll';

		/**
		 * Define the Authorize.net test url
		 * https://certification.authorize.net/gateway/transact.dll
		 */
		public static const AUTHORIZENET_URL_TEST = 'https://certification.authorize.net/gateway/transact.dll';
		
		/**
		 * Set order status
		 */
		public static const AUTHORIZENET_ORDER_STATUS = 'Paid';
		public static const ORDER_STATUS_LIST = 'Pending,Processing,Delivered,Paid,Update';
		
		/**
		 * Set payment method
		 */
		public static const AUTHORIZENET_FORM_LABEL = 'Credit Card';
		
		/**
		 * Card types
		 */
		public static const AUTHORIZENET_CC_ENABLED_VISA:Boolean		= true;
		public static const AUTHORIZENET_CC_ENABLE_MC:Boolean			= true;
		public static const AUTHORIZENET_CC_ENABLED_DISCOVER:Boolean	= true;
		public static const AUTHORIZENET_CC_ENABLED_AX:Boolean			= true;
		
		/**
		 * Data
		 */
		public static const TEXT_MONTHS = 'January,February,March,April,May,June,July,August,September,October,November,December';
		
		/**
		 * Error messages
		 */
		public static const ERROR_TEXT_CC_UNKNOWN_CARD = 'The credit card number was not entered correctly, or we do not accept that kind of card. Please try again or use another credit card.';
		public static const ERROR_TEXT_CC_INVALID_DATE = 'The expiration date entered for the credit card is invalid. Please check the date and try again.';
		public static const ERROR_TEXT_CC_INVALID_NUMBER = 'The credit card number entered is invalid. Please check the number and try again.';
		 
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 * @param url	The complete url string to the server to save
		 *				authorize.net transactions.
		 */
		public function Authorizenet():void{
			init();
		}
		 
		/**
		 * Initialization
		 */
		private function init():void{
			this.name			= 'Authorizenet';
			_module_title		= Authorizenet.AUTHORIZENET_FORM_LABEL;
			_module_description	= Authorizenet.AUTHORIZENET_FORM_DESCRIPTION;;
			_amount				= 0;
			_is_enabled			= Payment.PAYMENT_MODULE_AUTHORIZENET_STATUS == 'Enabled' ? true : false;
			_order_status		= Authorizenet.AUTHORIZENET_ORDER_STATUS;
			_payment_method		= Authorizenet.AUTHORIZENET_FORM_LABEL;
			
			var arr:Array = Authorizenet.ORDER_STATUS_LIST.split(',')
			_order_status_id = Common.array_search(_order_status, arr, false);
			
			set_card_types();
			set_send_url();
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
		 * Validates a credit card number. This method instantiates 
		 * the CC_Validation class to a) clean up the card number of 
		 * invalid characters, b) determine the card type, c) validate
		 * the card expire date, and e) validate the card number. If
		 * the validation passes (return value = 1), the filtered card
		 * information is saved to instance variables.  
		 * @param obj	An object with card information. The object 
		 *				must have at least the following properties:
		 *				cc_number, expiry_month, expiry_year, amount.
		 */
		public function pre_confirmation(obj:Object):String{
			_validator = new CC_Validator();
			var validation:Number = _validator.validate(obj);
			
			//set error message
			var r:String = '';
			switch(validation){
				case 0:
					r = Authorizenet.ERROR_TEXT_CC_INVALID_NUMBER;
					break;
				case -1:
					r = Authorizenet.ERROR_TEXT_CC_UNKNOWN_CARD;
					break;
				case -2:
				case -3:
				case -4:
					r = Authorizenet.ERROR_TEXT_CC_INVALID_DATE + '(' + validation + ')';
					break;
			}
			if(validation > 0){
				_cc_type			= _validator._cc_type;
				_cc_number			= _validator._cc_number;
				_cc_expiry_month	= String(_validator._cc_expiry_month);
				_cc_expiry_year		= String(_validator._cc_expiry_year);
				_cc_cvv2			= obj.cc_cvv2 != null ? String(obj.cc_cvv2) : '';
				_amount				= obj.amount;
				
			}
			return r;
		}
		
		/**
		 * Confirmation. This populates an array with label and data
		 * information to be used to create confirmation text.
		 * @param obj	On object containing credit card name and address
		 */
		public function confirmation(obj:Object):Array{
			var cc_number_greek:String = '';
			if(_cc_number != ''){
				cc_number_greek = _cc_number.substr(0, 4);
				cc_number_greek += Common.str_repeat('X', _cc_number.length - 8);
				cc_number_greek += _cc_number.substr(-4);
			}
			
			var months:Array = Authorizenet.TEXT_MONTHS.split(',');
			var expire_date:String = months[Number(_cc_expiry_month)] + ', ' + _cc_expiry_year;
			
			var arr:Array = new Array();
			if(obj != null){
				arr.push({label:'Payment Method',	value:Authorizenet.AUTHORIZENET_FORM_LABEL});
				arr.push({label:'First Name',		value:obj.first_name});
				arr.push({label:'Last Name',		value:obj.last_name});
				arr.push({label:'Street',			value:obj.address});
				arr.push({label:'City',				value:obj.city});
				arr.push({label:'State',			value:obj.state});
				arr.push({label:'ZIP Code',			value:obj.ZIP_Code});
				arr.push({label:'Telephone',		value:obj.telephone});
				arr.push({label:'Email',			value:obj.email});
				arr.push({label:'Amount',			value:'$' + Common.format_dollar(_amount)});
				arr.push({label:'Card Type',		value:_cc_type});
				arr.push({label:'Card Number',		value:cc_number_greek});
				arr.push({label:'Expires',			value:expire_date});
				arr.push({label:'CVV',				value:_cc_cvv2});
			}
			return arr;
		}
		
		/**
		 * Prepare and submit. This method is called from Step 2 of 
		 * the Registration's process order sequence. Step 1 had an
		 * Order instance request a session, customer id and order id
		 * from the server. Step 2 retrieved the data, loaded it to
		 * instance variables of this class and called this method. 
		 * This method loads all required information into an object,
		 * which is then passed to the call_host method.
		 *
		 * @param pmt	An object with payment name/value pairs.
		 */
		public function submit(pmt:Object):void{
			//set additional data to transmit
			var customer_email_test:String = Authorizenet.AUTHORIZENET_EMAIL_CUSTOMER ? 'TRUE' : 'FALSE';
			var merchant_email:String = Authorizenet.AUTHORIZENET_EMAIL_MERCHANT ? Authorizenet.AUTHORIZENET_COMPANY_EMAIL : '';
			
			//format data
			var amount:String		= _amount.toFixed(2);
			var cc_expiry:String	= Common.pad_left(_cc_expiry_month, '0', 2) + _cc_expiry_year.substr(-2);
			
			//set request data
			_request = new Object();
			_request = {x_login:			Authorizenet.AUTHORIZENET_LOGIN,
						x_tran_key:			Authorizenet.AUTHORIZENET_TXNKEY,
						x_version:			'3.1',
						x_test_request:		_test_mode,
						x_delim_data:		'TRUE',
						x_relay_response:	'FALSE',
						x_first_name:		pmt.first_name,
						x_last_name:		pmt.last_name,
						x_address:			pmt.address,
						x_city:				pmt.city,
						x_state:			pmt.state,
						x_zip:				pmt.ZIP_Code,
						x_phone:			pmt.telephone,
						x_cust_id:			_customer_id,
						x_customer_ip:		_customer_ip,
						x_email:			pmt.email,
						x_email_customer:	customer_email_test,
						x_merchant_email:	merchant_email,
						x_invoice_num:		_order_id,
						x_description:		_description,
						x_amount:			amount,
						x_method:			'CC',
						x_type:				'AUTH_CAPTURE',
						x_card_num:			_cc_number,
						x_exp_date:			cc_expiry,
						x_card_code:		_cc_cvv2
						};
						
			//encode submission NOTE: This is not necessary. 
			//Authorize.net parses the variables object just fine.
			//_request = encode_uri(_request);
			
			//send to gateway host
			call_host(_request);
		}
		
		/*------------------------------------------------------------
		COMMUNICATION METHODS
		------------------------------------------------------------*/
		/**
		 * Call host. This method processes a transactions by taking 
		 * the name/value pairs required by the host, processing them
		 * into a URLVariables object, and sending the object to the
		 * specified url (test or production). NOTE: The data format
		 * is set to 'text' because the host responds with a comma-
		 * delimited string. However, since the sent variables are 
		 * uri-encoded name/value pairs delimited with '&', the most 
		 * likely result is that the repsonse will be process not by 
		 * the main handler but by the alternate handler.
		 *
		 * @param vars	The name/value pairs to send to the host.
		 */
		private function call_host(vars:Object):void{
			var url:String = _send_url;
			_loader = new Basic_loader();
			_loader.addEventListener(Basic_loader.URL_LOAD_COMPLETE, get_host_reply);
			_loader.addEventListener(Basic_loader.URL_LOADER_ALT_DECODE, get_host_alt_reply);
			_loader.addEventListener(Basic_loader.URL_LOADER_DECODE_FAILED, parse_host_failure);
			_loader.process_load(url, vars, 'text', 'GET');
		}
		
		/**
		 * This is the primary handler for the sen_host() reply. It 
		 * assumes that Flash will be able to parse the reply into 
		 * a URLVariables object. This variable is then converted to
		 * a simple array for processsing.
		 * @param e		The loader on_complete event object.
		 */
		private function get_host_reply(e:Event):void{
			trace('get_host_reply called');
			_loader.removeEventListener(Basic_loader.URL_LOAD_COMPLETE, get_host_reply);
			_loader.removeEventListener(Basic_loader.URL_LOADER_ALT_DECODE, get_host_alt_reply);
			_loader.removeEventListener(Basic_loader.URL_LOADER_DECODE_FAILED, parse_host_failure);
			var reply:URLVariables = e.target._content;
			
			var r:String = '';
			for(var prop:* in reply){
				r += ',' + reply[prop];
			}
			r = r.substr(1);
			var arr:Array = r.split(',');
			parse_host_reply(arr);
		}
		
		/**
		 * This is a secondary handler for the call_host() reply. It 
		 * assumes that the primary handler has failed and that the 
		 * loaded data is in comma-delimited, text format. The string
		 * is split on the commas and processed like a normal array.
		 * @param e		The loader on_complete event TypeError object.
		 */
		private function get_host_alt_reply(e:Event):void{
			trace('get_host_alt_reply called');
			_loader.removeEventListener(Basic_loader.URL_LOAD_COMPLETE, get_host_reply);
			_loader.removeEventListener(Basic_loader.URL_LOADER_ALT_DECODE, get_host_alt_reply);
			_loader.removeEventListener(Basic_loader.URL_LOADER_DECODE_FAILED, parse_host_failure);
			var reply:String = e.target._content_txt;

			var arr:Array = reply.split(',');
			parse_host_reply(arr);
		}
		
		/**
		 * This is the third and final handler for the call_host() method,
		 * which handles complete failures.
		 * @param e		The loader on_complete Error object.	
		 */
		private function parse_host_failure(e:Event):void{
			trace('parse_host_failure');
			_loader.removeEventListener(Basic_loader.URL_LOAD_COMPLETE, get_host_reply);
			_loader.removeEventListener(Basic_loader.URL_LOADER_ALT_DECODE, get_host_alt_reply);
			_loader.removeEventListener(Basic_loader.URL_LOADER_DECODE_FAILED, parse_host_failure);
			_message = e.target._content_txt;
			dispatchEvent(new Event('order_process_failure'));
		}
		
		/**
		 * Process host response. Called by the loader event target. 
		 * This method takes the reponse array, loads it into a 
		 * _response object, prepares various strings to be used for
		 * alerts and database records, and sends an object to the 
		 * server to write to the Authorizenet table of the database.
		 * @param e		The loader event target object.
		 */
		private function parse_host_reply(arr:Array):void{
			//decode response
			arr = decode_uri(arr);
			
			//parse response
			_response = new Object();
			_response = {response_code:			arr[0],
						 response_subcode:		arr[1],
						 response_reason_code:	arr[2],
						 response_reason_text:	arr[3],
						 approval_code:			arr[4],
						 avs_result_code:		arr[5],
						 transaction_id:		arr[6],
						 order_id:				arr[7],
						 transaction_type:		arr[11],
						 customer_id:			arr[12],
						 md5_hash:				arr[37],
						 cvv2_response:			arr[38],
						 cavv_response:			arr[39],
						 response_notes:		get_response_reason(arr[2])
						 };
			
			//prepare request string
			var request_str:String = '';
			for(var prop:* in _request){
				request_str += '&' + prop + '=' + _request[prop];
			}
			request_str = request_str.substr(1);
			
			//prepare response string
			var response_str:String = '';
			for(var item:* in _response){
				if(_response[item] != null){
					response_str += '&' + item + '=' + _response[item];
				}else{
					response_str += '&' + item + '=NULL';
				}
			}
			response_str = response_str.substr(1);
			
			//prepare error string
			var error_str:String = '';
			
			//prepare data for writing
			var vars = {customer_id:		_customer_id,
						order_id:			_response.order_id,
						response_code:		_response.response_code,
						response_text:		_response.response_reason_text,
						response_notes:		_response.response_notes,
						authorization_type:	_response.transaction_type,
						transaction_id:		_response.transaction_id,
						approval_code:		_response.approval_code,
						status_id:			_order_status_id,
						sent:				request_str,
						received:			response_str,
						timestamp:			'now',
						session_id:			_session_id,
						error:				'',
						info:				error_str
						};
						
			//append session information to url string
			_db_trans_url += '?' + _session_name + '=' + _session_id;
			
			//save authorizenet transaction to database
			//and write first order history record
			_loader = new Basic_loader();
			_loader.addEventListener(Basic_loader.URL_LOAD_COMPLETE, confirm_db_write);
			_loader.addEventListener(Basic_loader.URL_LOADER_ALT_DECODE, confirm_alt_db_write);
			_loader.addEventListener(Basic_loader.URL_LOADER_DECODE_FAILED, db_write_fail);
			_loader.process_load(_db_trans_url, vars, 'variables', 'post');
		}
		
		/**
		 * Receives confirmation from server that payment response was 
		 * recorded in the gateway table of the database. The message
		 * field should be null if both of the disk writing routines
		 * are successful. A failure event is dispatched otherwise. The
		 * dispatch of a sucessful event is captured by the Registration
		 * instance, which writes the order to disk and sends an email
		 * to the merchant and customer.
		 * @param e 	The loader on_complete event object
		 */
		private function confirm_db_write(e:Event):void{
			trace('confirm_db_write called');
			_loader.removeEventListener(Basic_loader.URL_LOAD_COMPLETE, confirm_db_write);
			_loader.removeEventListener(Basic_loader.URL_LOADER_ALT_DECODE, confirm_alt_db_write);
			_loader.removeEventListener(Basic_loader.URL_LOADER_DECODE_FAILED, db_write_fail);
			
			var reply:URLVariables = e.target._content;
			_message = reply.msg;
			if(_message != ''){
				trace('payment: order_process_failure: ' + _message);
				dispatchEvent(new Event('order_process_failure'));
			}else{
				trace('calling registration: process_order_part3');
				dispatchEvent(new Event('payment_process_success'));
			}
		}
		
		private function confirm_alt_db_write(e:Event):void{
			trace('confirm_alt_db_write called');
			_loader.removeEventListener(Basic_loader.URL_LOAD_COMPLETE, confirm_db_write);
			_loader.removeEventListener(Basic_loader.URL_LOADER_ALT_DECODE, confirm_alt_db_write);
			_loader.removeEventListener(Basic_loader.URL_LOADER_DECODE_FAILED, db_write_fail);
										
			var reply:String = e.target._content_txt;
			_message = '';
			var arr:Array = reply.split('&');
			for(var i:int = 0; i < arr.length; i++){
				var arr2:Array = arr[i].split('=');
				if(arr2[0] == 'msg'){
					_message = arr2[1];
					break;
				}
			}
			if(_message != ''){
				trace('payment: order_process_failure: ' + _message);
				dispatchEvent(new Event('order_process_failure'));
			}else{
				trace('calling registration: process_order_part3');
				dispatchEvent(new Event('payment_process_success'));
			}
		}
		
		private function db_write_fail(e:Event):void{
			trace('payment: order_process_failure: ' + e.target._content_txt);
			_loader.removeEventListener(Basic_loader.URL_LOAD_COMPLETE, confirm_db_write);
			_loader.removeEventListener(Basic_loader.URL_LOADER_ALT_DECODE, confirm_alt_db_write);
			_loader.removeEventListener(Basic_loader.URL_LOADER_DECODE_FAILED, db_write_fail);
			
			dispatchEvent(new Event('order_process_failure'));
		}
		
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
						 form_label:	Authorizenet.AUTHORIZENET_FORM_LABEL.toUpperCase(),
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
				arr.push({column:		2,
						 field_name:	'cc_number',
						 required:		true,
						 form_type:		'text',
						 on_change:		'',
						 max_size:		19,
						 pattern:		'integer',
						 form_label:	'Card Number:',
						 tab:			9,
						 field_value:	''
						 });
				arr.push({column:		2,
						 field_name:	'cc_expiry_month',
						 required:		true,
						 form_type:		'select',
						 on_change:		'',
						 form_label:	'Expire Month:',
						 tab:			10
						 });
				arr.push({column:		2,
						 field_name:	'cc_expiry_year',
						 required:		true,
						 form_type:		'select',
						 on_change:		'',
						 form_label:	'Expire Year:',
						 tab:			11
						 });
				arr.push({column:		2,
						 field_name:	'cc_cvv2',
						 required:		false,
						 form_type:		'text',
						 on_change:		'',
						 max_size:		3,
						 pattern:		'integer',
						 form_label:	'CVV:',
						 tab:			12,
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

		/**
		 * Encodes a string into a valid UTF-8 URI.
		 * @param v	the array, object or string to encode.
		 */
		private function encode_uri(v:*):*{
			if(v is Array){
				for(var i:int = 0; i < v.length; i++){
					v[i] = encodeURI(v[i]);
				}
			}else if(v is String){
				v = encodeURI(v);
			}else if(v is Number){
				v = encodeURI(String(v));
			}else if(v is Object){
				for(var key:* in v){
					v[key] = encodeURI(v[key]);
				}
			}else{
				v = encodeURI(v);
			}
			return v;
		}
		
		/**
		 * Decodes a URI encoded string.
		 * @param v		The array, object or string to decode.
		 */
		private function decode_uri(v:*):*{
			if(v is Array){
				for(var i:int = 0; i < v.length; i++){
					v[i] = decodeURI(v[i]);
				}
			}else if(v is String){
				v = decodeURI(v);
			}else if(v is Object){
				for(var key:* in v){
					v[key] = decodeURI(v[key]);
				}
			}
			return v;
		}
		
		/**
		 * Sets available card types.
		 */
		private function set_card_types():void{
			_card_types = new Array();
			if(Authorizenet.AUTHORIZENET_CC_ENABLED_VISA){
				_card_types.push({label:'Visa', data:'Visa'});
			}
			if(Authorizenet.AUTHORIZENET_CC_ENABLE_MC){
				_card_types.push({label:'MasterCard', data:'MasterCard'});
			}
			if(Authorizenet.AUTHORIZENET_CC_ENABLED_DISCOVER){
				_card_types.push({label:'Discover', data:'Discover'});
			}
			if(Authorizenet.AUTHORIZENET_CC_ENABLED_AX){
				_card_types.push({label:'American Express', data:'Amex'});
			}
		}
		
		/**
		 * Sets the url to send to.
		 */
		private function set_send_url():void{
			if(Authorizenet.AUTHORIZENET_MODE == 'Live'){
				_send_url = Authorizenet.AUTHORIZENET_URL_LIVE;
				_test_mode = 'False';
			}else{
				_send_url = Authorizenet.AUTHORIZENET_URL_TEST;
				_test_mode = 'True';
			}
		}
		
		/**
		 * provides additional comments with respect to a rejection code.
		 * @param e		The element number of the reason code.
		 */
		private function get_response_reason(e:Number):String{
			var reason = new Array();
			reason[4]	= 'The card needs to be picked up.';
			reason[5]	= 'The amount is not a number.';
			reason[7]	= 'The format of the expiration date is invalid.';
			reason[9]	= 'The bank ABA code did not pass validation or was not for a valid financial institution.';
			reason[10]	= 'The bank account number is invalid.';
			reason[11]	= 'A transaction with identical amount and credit card information was submitted two minutes prior.';
			reason[12]	= 'The auhorization code was submitted without a value.';
			reason[14]	= 'The Relay Response or Referrer URL does not match the merchant’s configured value(s) or is absent.';
			reason[15]	= 'The transaction ID value is non-numeric or was not present for a transaction that requires it.';
			reason[16]	= 'The transaction ID sent in was properly formatted but the gateway had no record of the transaction.';
			reason[17]	= 'The merchant was not configured to accept the credit card submitted in the transaction.';
			reason[18]	= 'The merchant does not accept electronic checks.';
			reason[28]	= 'The Merchant ID at the processor was not configured to accept this card type.';
			reason[31]	= 'The merchant was incorrectly set up at the processor.';
			reason[33]	= 'This error indicates that a field the merchant specified as required was not filled in.';
			reason[34]	= 'The merchant was incorrectly set up at the processor.';
			reason[35]	= 'The merchant was incorrectly set up at the processor.';
			reason[38]	= 'The merchant was incorrectly set up at the processor.';
			reason[41]	= 'Only merchants set up for the FraudScreen. Net service would receive this decline. This code will be returned if a given transaction’s fraud score is higher than the threshold set by the merchant.';
			reason[42]	= 'This is applicable only to merchants processing through the Wells Fargo SecureSource product who have requirements for transaction submission that are different from merchants not processing through Wells Fargo.';
			reason[43]	= 'The merchant was incorrectly set up at the processor.';
			reason[44]	= 'The Card Code filter has been set in the Merchant Interface and the transaction received an error code from the processor that matched the rejection criteria set by the merchant.';
			reason[45]	= 'The transaction received a code from the processor that matched the rejection criteria set by the merchant for both the AVS and Card Code filters.';
			reason[47]	= 'The merchant tried to capture funds greater than the amount of the original authorization-only transaction.';
			reason[48]	= 'The merchant attempted to settle for less than the originally authorized amount.';
			reason[49]	= 'The transaction amount submitted was greater than the maximum amount allowed.';
			reason[50]	= 'Credits or refunds may only be performed against settled transactions. The transaction against which the credit/refund was submitted has not been settled, so a credit cannot be issued.';
			reason[53]	= 'If x_method = ECHECK, x_type cannot be set to CAPTURE_ONLY.';
			reason[55]	= 'The transaction is rejected if the sum of this credit and prior credits exceeds the original debit amount.';
			reason[56]	= 'The merchant processes eCheck transactions only and does not accept credit cards.';
			reason[64]	= 'This error is applicable to Wells Fargo SecureSource merchants only. Credits or refunds cannot be issued against transactions that were not authorized.';
			reason[65]	= 'The transaction was declined because the merchant configured their account through the Merchant Interface to reject transactions with certain values for a Card Code mismatch.';
			reason[66]	= 'The transaction did not meet gateway security guidelines.';
			reason[67]	= 'This error code is applicable to merchants using the Wells Fargo SecureSource product only. This product does not allow transactions of type CAPTURE_ONLY.';
			reason[68]	= 'The Authorize.net version number was invalid.';
			reason[69]	= 'The value submitted in x_type was invalid.';
			reason[70]	= 'The value submitted in x_method was invalid.';
			reason[71]	= 'The value submitted in x_bank_acct_type was invalid.';
			reason[72]	= 'The value submitted in x_auth_code was more than six characters in length.';
			reason[73]	= 'The format of the driver\'s license number was invalid.';
			reason[74]	= 'The value submitted in x_duty failed format validation.';
			reason[75]	= 'The freight value failed format validation.';
			reason[76]	= 'The tax value failed format validation.';
			reason[77]	= 'The customer tax ID failed validation.';
			reason[78]	= 'The value submitted in x_card_code failed format validation.';
			reason[79]	= 'The driver\'s license number failed format validation.';
			reason[80]	= 'The driver\'s license state failed format validation.';
			reason[81]	= 'The merchant requested an integration method not compatible with the AIM API.';
			reason[82]	= 'The system no longer supports version 2.5; requests cannot be posted to scripts.';
			reason[83]	= 'The system no longer supports version 2.5; requests cannot be posted to scripts.';
			reason[93]	= 'This code is applicable to Wells Fargo SecureSource merchants only. Country is a required field and must contain the value of a supported country.';
			reason[94]	= 'This code is applicable to Wells Fargo SecureSource merchants only.';
			reason[95]	= 'This code is applicable to Wells Fargo SecureSource merchants only.';
			reason[96]	= 'This code is applicable to Wells Fargo SecureSource merchants only. Country is a required field and must contain the value of a supported country.';
			reason[97]	= 'Applicable only to SIM API. Fingerprints are only valid for a short period of time. This code indicates that the transaction fingerprint has expired.';
			reason[98]	= 'Applicable only to SIM API. The transaction fingerprint has already been used.';
			reason[99]	= 'Applicable only to SIM API. The server-generated fingerprint does not match the merchant-specified fingerprint in the x_fp_hash field.';
			reason[100]	= 'Applicable only to eCheck. The value specified in the x_echeck_type field is invalid.';
			reason[101]	= 'Applicable only to eCheck. The specified name on the account and/or the account type do not match the NOC record for this account.';
			reason[102]	= 'A password or transaction key was submitted with this WebLink request. This is a high security risk.';
			reason[103]	= 'A valid fingerprint, transaction key, or password is required for this transaction.';
			reason[104]	= 'Applicable only to eCheck. The value submitted for country failed validation.';
			reason[105]	= 'Applicable only to eCheck. The values submitted for city and country failed validation.';
			reason[106]	= 'Applicable only to eCheck. The value submitted for company failed validation.';
			reason[107]	= 'Applicable only to eCheck. The value submitted for bank account name failed validation.';
			reason[108]	= 'Applicable only to eCheck. The values submitted for first name and last name failed validation.';
			reason[109]	= 'Applicable only to eCheck. The values submitted for first name and last name failed validation.';
			reason[110]	= 'Applicable only to eCheck. The values submitted for for bank account name does not contain valid characters.';		
			reason[111]	= 'This code is applicable to Wells Fargo SecureSource merchants only.';		
			reason[112]	= 'This code is applicable to Wells Fargo SecureSource merchants only.';		
			reason[116]	= 'This code is applicable only to merchants that include the x_authentication_indicator in the transaction request. The ECI value for a Visa transaction; or the UCAF indicator for a MasterCard transaction submitted in the x_authentication_indicator field is invalid.';		
			reason[117]	= 'This code is applicable only to merchants that include the x_cardholder_authentication_value in the transaction request. The CAVV for a Visa transaction; or the AVV/UCAF for a MasterCard transaction is invalid.';		
			reason[118]	= 'This code is applicable only to merchants that include the x_authentication_indicator and x_authentication_value in the transaction request. The combination of authentication indicator and cardholder authentication value for a Visa or MasterCard transaction is invalid.';		
			reason[119]	= 'This code is applicable only to merchants that include the x_authentication_indicator and x_recurring_billing in the transaction request. Transactions submitted with a value in x_authentication_indicator AND x_recurring_billing =YES will be rejected.';		
			reason[120]	= 'The system-generated void for the original timed-out transaction failed. (The original transaction timed out while waiting for a response from the authorizer.)';		
			reason[121]	= 'The system-generated void for the original errored transaction failed. (The original transaction experienced a database error.)';		
			reason[122]	= 'The system-generated void for the original errored transaction failed. (The original transaction experienced a processing error.)';		
			reason[123]	= 'The transaction request must include the API login ID associated with the payment gateway account.';		
			reason[127]	= 'The system-generated void for the original AVS-rejected transaction failed.';		
			reason[128]	= 'The customer\'s financial institution does not currently allow transactions for this account.';		
			reason[130]	= 'IFT: The payment gateway account status is Blacklisted.';		
			reason[131]	= 'IFT: The payment gateway account status is Suspended-STA.';		
			reason[132]	= 'IFT: The payment gateway account status is Suspended-Blacklist.';		
			reason[141]	= 'The system-generated void for the original FraudScreen-rejected transaction failed.';		
			reason[145]	= 'The system-generated void for the original card code-rejected and AVS-rejected transaction failed.';		
			reason[152]	= 'The system-generated void for the original transaction failed. The response for the original transaction could not be communicated to the client.';		
			reason[165]	= 'The system-generated void for the original card code-rejected transaction failed.';		
	
			var r:String = reason[e] != null ? reason[e] : '';
			return r;
		}
	}
}