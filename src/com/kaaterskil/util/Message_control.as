/**
 * Message_control.as
 *
 * Class definition.
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080406
 * @package com.kaaterskil.utilities
 */

package com.kaaterskil.utilities{
	public class Message_control{
		/**
		 * Container
		 */
		private var _messages:Array;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public class Message_control(){
			reset();
		}
		
		/**
		 * Resets (initializes) the _message array.
		 */
		public function reset():void{
			_messages = new Array();
		}
		
		/**
		 * Adds a message to the instance
		 * @param cl	The class name of the instance generating the message
		 * @param msg	The message body
		 * @param type	The type of message
		 */
		public function add_message(cl:String, msg:String, type:String = 'error'):void{
			var txt:String = Common.trim(msg);
			if(txt.length > 0){
				_messages.push({param:	type,
							   class:	cl,
							   text:	txt
							   });
			}
		}
		
		/**
		 * Outputs message
		 * @param cl	The class name of the instance
		 */
		public function output_message(cl:String):Array{
			var arr:Array = new Array();
			for(var i:int = 0; i < _messages.length; i++){
				if(_messages[i].class == cl){
					arr.push(_messages[i]);
				}
			}
			return arr;
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Counts messages by class
		 * @param cl	The class name of the instance
		 */
		public function count_messages(cl:String):int{
			var r:int = 0;
			for(var i:int = 0; i < _messages.length; i++){
				if(_messages[i].class == cl){
					r++;
				}
			}
			return r;
		}
	}
}