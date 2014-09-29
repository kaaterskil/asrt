/**
 * Common.as
 *
 * @copyright 2007 Kaaterskil Management, LLC
 * @version 071114
 * @package com.kaaterskil.utilities
 */

package com.kaaterskil.utilities{
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.net.*;
	
	/**
	 * The Common utility class is an all-static class with methods
	 * for common utility functions within ActionScript. You do not
	 * create instances of Common - instead you call static methods.
	 */
	public class Common{
		/*------------------------------------------------------------
		MISCELLANEOUS FUNCTIONS
		------------------------------------------------------------*/
		/**
		 * Get the current domain. Returns 'localhost' for swf files
		 * residing with the client and the actual domain if the swf
		 * file resides at the server.
		 */
		public static function get_host():String{
			var conn = new LocalConnection();
			return conn.domain;
		}
		 
		/**
		 * Test for value. If the variable is an array, test for 
		 * elements. If the variable is a string, test for non-whitespace
		 * characters. Returns true for numbers.
		 * @param 	mixed 	v	The variable to test
		 * @result	boolean
		 */
		public static function not_null(v):Boolean{
			if(v is Array){
				if(v.length > 0){
					return true;
				}
			}else{
				if(v is String && v.length > 0){
					v = Common.trim(v);
					if(v.length > 0){
						return true;
					}
				}
				if((v is Number || v is int || v is uint) && !isNaN(v)){
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Enumerate an object's properties
		 */
		public static function enumerate_obj(obj:*, level:Number = 1):String{
			var r:String = '';
			if(obj is String || obj is Boolean){
				r += '\n' + obj;
			}else if(obj is Number){
				r += '\n' + String(obj);
			}else if(obj is Date){
				r += '\n' + obj.toString();
			}else if(obj is Array){
				r += '\nArray:{';
				for(var i:int = 0; i < obj.length; i++){
					r += '\n' + Common.str_repeat('\t', level) + '[' + i + '] => ' 
						 + enumerate_obj(obj[i], level + 1);
				}
				r += '\n' + Common.str_repeat('\t', level - 1) + '}';
			}else if(obj is Object){
				r += '\n' + obj.toString()+ ':{';
				for(var key:* in obj){
					r += '\n' + Common.str_repeat('\t', level) + '[' + key + '] => ' 
						 + enumerate_obj(obj[key], level + 1);
				}
				r += '\n' + Common.str_repeat('\t', level - 1) + '}';
			}
			r = r.substr(1);
			return r;
		}
		
		/**
		 * Search an object for a given property.
		 * @param needle	The key to search for.
		 * @param haystack	The object to search within.
		 * @param strict	Test for case sensitivity.
		 * @result			Boolean.
		 */
		public static function obj_property_exists(needle:*, obj:Object, strict:Boolean):Boolean{
			for(var key:* in obj){
				if(strict){
					if(key == needle){
						return true;
					}
				}else if(key.toLowerCase() == needle){
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Builds a string of random values to a specified length.
		 * @param len	The length of the return string.
		 * @param type	The type of string, e.g. all numbers, all
		 *				characters or mixed. Note that the returned
		 *				value using only numbers is still a string.
		 */
		public static function get_random_value(len:Number, type:String):String{
			//test if type has been defined
			var types:Array = ['digits', 'mixed', 'chars'];
			type = type.toLowerCase();
			if(!Common.in_array(type, types, false)){
				return null;
			}
			
			//build result
			var char:String = '';
			var re_digits:RegExp	= /^[0-9]$/;
			var re_mixed:RegExp		= /^[a-zA-Z0-9]$/;
			var re_chars:RegExp		= /^[a-zA-Z]$/;
			
			var str:String = '';
			while(str.length < len){
				//get random number
				char = '';
				if(type == 'digits'){
					char = String(Common.get_random(0, 9, 1));
				}else{
					char = String.fromCharCode(Common.get_random(0, 255, 1));
				}
				//test and add character to string
				if(type == 'digits' && re_digits.test(char)){
					str += char;
				}else if(type == 'chars' && re_chars.test(char)){
					str += char;
				}else if(re_mixed.test(char)){
					str += char;
				}
			}
			return str;
		}
		
		/**
		 * URL encode
		 */
		private function url_encode(v:*):*{
			if(v is Array){
				for(var i:int = 0; i < v.length; i++){
					v[i] = url_encode(v[i]);
				}
			}else if(v is String){
				v = encodeURI(v);
			}else if(v is Number){
				v = encodeURI(String(v));
			}else if(v is Object){
				for(var key:* in v){
					v[key] = url_encode(v[key]);
				}
			}else{
				v = encodeURI(v);
			}
			return v;
		}
		
		/**
		 * URL decode
		 */
		private function url_decode(v:*):*{
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
		
		/*------------------------------------------------------------
		DISPLAY FUNCTIONS
		------------------------------------------------------------*/
		/**
		 * Returns a nested array of the display list. Runs recursively.
		 */
		public static function show_display_tree(container:DisplayObjectContainer):void{
			var arr:Array = get_display_tree(container);
			trace(Common.enumerate_obj(arr));
		}
		private static function get_display_tree(container:DisplayObjectContainer):Array{
			var arr:Array = new Array();
			for(var i:int = 0; i < container.numChildren; i++){
				var child:* = container.getChildAt(i);
				var point:Point = new Point(child.x, child.y)
				if(child is DisplayObjectContainer){
					arr.push({name:		child.name, 
							 local:		point.toString() + ', ' 
							 			+ child.getBounds(container).toString(),
							 global:	child.localToGlobal(point).toString(),
							 children:	get_display_tree(child)
							 });
				}else{
					arr.push({name:		child.name, 
							 local:		point.toString() + ', ' 
							 			+ child.getBounds(container).toString(),
							 global:	child.localToGlobal(point).toString()
							 });
				}
			}
			return arr;
		}
		
		/**
		 * Traces a display object's local and global x/y coordinates.
		 */
		public static function trace_point(obj:DisplayObject):void{
			var point:Point = new Point(obj.x, obj.y);
			trace(obj.name + ' local: ' + point + ', global: ' + obj.localToGlobal(point));
		}
		
		/*------------------------------------------------------------
		TWEEN FUNCTIONS
		------------------------------------------------------------*/
		/**
		 * Tween action
		 * @param type		A string by which to add events or other functions
		 * @param obj		The target object to tween
		 * @param prop		The object property to tween
		 * @param func		The easing function
		 * @param begin		The beginning property value
		 * @param finish	The ending property value
		 * @param duration	The interval (in frames)
		 */
		public static function do_tween(type:String, obj:Object, prop:String, func:Function, 
										begin:Number, finish:Number, duration:Number, 
										is_seconds = false):Tween{
			var tween_obj:Tween = new Tween(obj, prop, func, begin, finish, duration, is_seconds);
			
			switch(type){
				default:
					break;
			}
			return tween_obj;
		}
		
		/**
		 * East in circular
		 */
		public static function ease_in_circular(t:Number, b:Number, c:Number, d:Number):Number{
			return c * (1 - Math.sqrt(1 - (t/=d) * t)) + b;
		}
		
		/**
		 * East in exponential
		 */
		public static function ease_in_exponential(t:Number, b:Number, c:Number, d:Number):Number{
			return c * Math.pow(2, 10 * (t/d - 1)) + b;
		}
		
		/**
		 * East in quadratic
		 */
		public static function ease_in_quadratic(t:Number, b:Number, c:Number, d:Number):Number{
			return c * (t/=d) * t + b;
		}
		
		/**
		 * East in cubic
		 */
		public static function ease_in_cubic(t:Number, b:Number, c:Number, d:Number):Number{
			return c * Math.pow(t / d, 3) + b;
		}
		
		/**
		 * Ease in quart
		 */
		public static function ease_in_quart(t:Number, b:Number, c:Number, d:Number):Number{
			return c * Math.pow(t / d, 4) + b;
		}
		
		/**
		 * Ease in quint
		 */
		public static function ease_in_quint(t:Number, b:Number, c:Number, d:Number):Number{
			return c * Math.pow(t / d, 5) + b;
		}
		
		/**
		 * East out circular
		 */
		public static function ease_out_circular(t:Number, b:Number, c:Number, d:Number):Number{
			return c * Math.sqrt(1 - (t = t/d - 1) * t) + b;
		}
		
		/**
		 * East out exponential
		 */
		public static function ease_out_exponential(t:Number, b:Number, c:Number, d:Number):Number{
			return c * (-Math.pow(2, -10 * t/d) + 1) + b;
		}
		
		/**
		 * East out quadratic
		 */
		public static function ease_out_quadratic(t:Number, b:Number, c:Number, d:Number):Number{
			return -c * (t/=d)*(t-2) + b;
		}
		
		/**
		 * East out cubic
		 */
		public static function ease_out_cubic(t:Number, b:Number, c:Number, d:Number):Number{
			return c * (Math.pow(t / d - 1, 3) + 1) + b;
		}
		
		/**
		 * Ease out quart
		 */
		public static function ease_out_quart(t:Number, b:Number, c:Number, d:Number):Number{
			return -c * (Math.pow(t / d - 1, 4) - 1) + b;
		}
		
		/**
		 * Ease out quint
		 */
		public static function ease_out_quint(t:Number, b:Number, c:Number, d:Number):Number{
			return c * (Math.pow(t / d - 1, 5) + 1) + b;
		}
		
		/*------------------------------------------------------------
		MATH FUNCTIONS
		------------------------------------------------------------*/
		/**
		 * Rounds a number. By default the number is rounded to the
		 * nearest integer. However, if an interval is specified, the
		 * number is rounded to the nearest interval.
		 * @param	Number	number 		The number to be rounded
		 * @param 	Number	interval	(Optional) The interval to which
		 *								you want to round the number.
		 * @result	Number				The rounded number.
		 */
		public static function round(number:Number, interval:Number = 1):Number{
			return Math.round(number / interval) * interval;
		}

		/**
		 * Gets the floor of a number. By default floor is the integer
		 * part of a number. However, by specifying an interval, the
		 * result may be a non-integer.
		 * @param	Number	number 		The number to be rounded
		 * @param 	Number	interval	(Optional) The interval to which
		 *								you want to round the number.
		 * @result	Number				The rounded number.
		 */
		public static function floor(number:Number, interval:Number = 1):Number{
			return Math.floor(number / interval) * interval;
		}

		/**
		 * Gets the ceiling of a number. By default ceiling is the integer
		 * part of a number. However, by specifying an interval, the
		 * result may be a non-integer.
		 * @param	Number	number 		The number to be rounded
		 * @param 	Number	interval	(Optional) The interval to which
		 *								you want to round the number.
		 * @result	Number				The rounded number.
		 */
		public static function ceiling(number:Number, interval:Number = 1):Number{
			return Math.ceil(number / interval) * interval;
		}
		
		/**
		 * Generate a random number within a specified range. By 
		 * default the result is an integer but this can be specified
		 * to a number of decimal places.
		 * @param	Number	min			The minimum value in the range.
		 * @param	Number	max			The maximum value in the range.
		 * @param 	Number	interval	(Optional) The interval to which
		 *								you want to round the number.
		 * @result	Number	r			The rounded random number.
		 */
		public static function get_random(min:Number, max:Number, interval:Number = 1):Number{
			//test if min > max and flip
			if(min > max){
				var temp:Number = min;
				min = max;
				max = temp;
			}
			//Calculate the range by subtracting the minimnum from the
			//maximum number. Add 1 times the rounding interval to 
			//ensure an even distribution.
			var range:Number = max - min + (1 * interval);
			
			//Multiply the range by Math.random(). The generated 
			//number won't be offset properly, so you need to add the
			//minimum amount to it.
			var number:Number = (Math.random() * range) + min;
			
			
			//Return the random value rounded to the desired interval.
			return floor(number, interval);
		}

		/*------------------------------------------------------------
		ARRAY FUNCTIONS
		------------------------------------------------------------*/
		/**
		 * Gets an average of string or array values.
		 */
		public static function average(v):Number{
			var arr:Array;
			
			//convert string to array
			if(v is String){
				arr = v.split(',');
			}else if(v is Array){
				arr = v;
			}else{
				return 0;
			}
			return sum(arr) / arr.length;
		}
		
		/**
		 * Adds the values in a string or array
		 */
		public static function sum(v):Number{
			var arr:Array;
			
			//convert string to array
			if(v is String){
				arr = v.split(',');
			}else if(v is Array){
				arr = v;
			}else{
				return 0;
			}
			
			//loop through the array
			var r:Number = 0;
			for(var i:int = 0; i < arr.length; i++){
				if(arr[i] is Number || arr[i] is int || arr[i] is uint){
					r += arr[i];
				}else{
					if(arr[i] is String && !isNaN(parseFloat(arr[i]))){
						r += parseFloat(arr[i]);
					}
				}
			}
			return r;
		}
		
		/**
		 * Searches the array for a given value and returns the first
		 * corresponding key if successful or -1 otherwise.
		 * @param   mixed    needle    The value to search for
		 * @param   array    haystack  The array to search within
		 * @param   boolean  strict    Test for case-sensitivity
		 * @result  integer            The element that matched
		 */
		public static function array_search(needle, haystack:Array, strict:Boolean):int{
			needle = !strict ? needle.toLowerCase() : needle;
			
			for(var i:int = 0; i < haystack.length; i++){
				var target = !strict ? haystack[i].toLowerCase() : haystack[i];
				if(needle == target){
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * Checks if a value exists in an array and returns true if found
		 * or false otherwise.
		 * @param   mixed    needle    The value to search for
		 * @param   array    haystack  The array to search within
		 * @param   boolean  strict    Test for case-sensitivity
		 * @result  boolean
		 */
		public static function in_array(needle:*, haystack:Array, strict:Boolean = false):Boolean{
			if(needle is String && !strict){
				needle = needle.toLowerCase();
			}
			
			for(var i:int = 0; i < haystack.length; i++){
				if(haystack[i] is String && !strict){
					var target:String = haystack[i].toLowerCase()
					if(needle == target){
						return true;
					}
				}else{
					if(needle == haystack[i]){
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * Searches an array for a given value and returns the
		 * corresponding keys.
		 * @param   mixed    needle    The value to search for
		 * @param   array    haystack  The array to search within
		 * @param   boolean  strict    Test for case-sensitivity
		 * @result  array
		 */
		public static function array_keys(needle, haystack:Array, strict:Boolean):Array{
			var arr:Array = new Array();
			needle = !strict ? needle.toLowerCase() : needle;
			
			for(var i:int = 0; i < haystack.length; i++){
				var target = !strict ? haystack[i].toLowerCase() : haystack[i];
				if(needle == target){
					arr.push(i);
				}
			}
			return arr;
		}
			
		/*------------------------------------------------------------
		XML FUNCTIONS
		------------------------------------------------------------*/
		/**
		 * Parses xml objects into an array. Runs recursively.
		 * @param xml	The xml object to parse
		 * @result arr	The array to return
		 */
		public static function parse_xml(xml:XML):Array{
			var arr:Array = new Array();
			for each(var child:XML in xml.*){
				arr.push({});
				for each(var prop:XML in child.*){
					var key:String	= prop.name();
					if(prop.hasSimpleContent()){
						var val:String	= prop.toString();
						arr[arr.length - 1][key] = val;
					}else{
						var arr2:Array = parse_xml(prop);
						arr[arr.length - 1][key] = arr2;
					}
				}
			}
			return arr;
		}
		
		/**
		 * Parses an xml file with multiple 'categories'. Each category
		 * is parsed into separate arrays.
		 * @param xml	The xml file
		 */
		public static function parse_xml_multi(xml:XML):Array{
			var arr:Array = new Array();
			for each(var child:* in xml.*){
				arr.push(parse_xml(child));
			}
			return arr;
		}
	
		/*------------------------------------------------------------
		STRING FUNCTIONS
		------------------------------------------------------------*/
		/**
		 * Escapes single quotes, double quotes and backslashes in a string.
		 * @param	string	v	The string to escape
		 * @result	string	r	The escaped string 
		 */
		public static function addslashes(v:String):String{
			var r:String = v;
			
			r.split('"').join('\"');
			r.split("'").join('\'');
			r.split('\\').join('\\\\');
			return r;
		}
		
		/**
		 * Strip slashes. Removes backslashes from a string.
		 * @param	string	v	The string to strip
		 * @result	string	r	The stripped string
		 */
		public static function stripslashes(v:String):String{
			var r:String = v;
			
			r.split('\\').join('');
			return r;
		}
		
		/**
		 * Trims whitespace from both ends of a string.
		 */
		public static function trim(str:String):String{
			var p:RegExp = /\s/;
			
			//set index where non-whitespace characters start
			var i_start:int = 0;
			while(p.test(str.charAt(i_start))){
				++i_start;
			}
			
			//set index where non-whitespace characters end
			var i_end:int = str.length - 1;
			while(p.test(str.charAt(i_end))){
				--i_end;
			}
			
			//strip characters
			if(i_end >= i_start){
				return str.slice(i_start, i_end + 1);
			}else{
				return '';
			}
		}
		
		/**
		 * Trims whitespace from the beginning of a string.
		 */
		public static function ltrim(str:String):String{
			var p:RegExp = /\s/;
			var pointer:int = 0;
			
			while(p.test(str.charAt(pointer))){
				++pointer;
			}
			return str.slice(pointer, str.length - 1);
		}
		
		/**
		 * Trims whitespace from the end of a string.
		 */
		public static function rtrim(str:String):String{
			var p:RegExp = /\s/;
			var pointer:int = str.length - 1;
			
			while(p.test(str.charAt(pointer))){
				--pointer;
			}
			return str.slice(0, pointer);
		}
		
		/**
		 * Capitalizes the first letter in a string.
		 */
		public static function ucfirst(str:String):String{
			var r:String = '';
			r = str.charAt(0).toUpperCase();
			r += str.substr(1, str.length - 1)
			return r;
		}
		
		/**
		 * Capitalizes the first character of each word in a string.
		 */
		public static function ucwords(str:String):String{
			var words:Array = str.split(' ');
			for(var i:int = 0; i < words.length; i++){
				words[i] = Common.ucfirst(words[i]);
			}
			return words.join(' ');
		}
		
		/**
		 * Converts all characters in a string to upper case.
		 */
		public static function strtoupper(str:String):String{
			return str.toUpperCase();
		}
		
		/**
		 * Converts all characters in a string to lower case.
		 */
		public static function strtolower(str:String):String{
			return str.toLowerCase();
		}
		
		/**
		 * Repeats a string.
		 * @param	str			The string to repeat
		 * @param	multiplier	The number of times to repeat
		 * @result	r			The repeated string
		 */
		public static function str_repeat(str:String, multiplier:int){
			var r:String = '';
			for(var i:int = 0; i < multiplier; i++){
				r += str;
			}
			return r;
		}
		
		/**
		 * Search and replace text in string using a RegExp pattern.
		 * @param str		The string to test.
		 * @param pattern	The pattern to find.
		 * @param replace	The replacemenet text.
		 * @param global	True to replace all occurances of pattern.
		 * @param strict	True for case sensitivity
		 */
		public static function str_replace_regexp(str:String,
												  pattern:RegExp, 
												  replace:String):String{
			return str.replace(pattern, replace);
		}
		
		/** 
		 * Search and replace text in string.
		 * @param	needle		The string to search for
		 * @param	replace		The replacement string
		 * @param	haystack	The string to search within
		 * @param	strict		Test for case-sensitivity
		 */
		public static function str_replace(needle:String, 
										   replace:String, 
										   haystack:String, 
										   strict:Boolean = false):String{
			var temp = '';
			var working	= haystack;
			var search_index = -1;
			var start_index	= 0;
			
			if(!strict){
				needle	= needle.toLowerCase();
				working	= working.toLowerCase();
			}
			
			while((search_index = working.indexOf(needle, start_index)) != -1){
				temp += haystack.substring(start_index, search_index);
				temp += replace;
				start_index = search_index + needle.length;
			}
			return temp + haystack.substring(start_index);
		}
		
		/**
		 * Reverses a string.
		 * @param str	The string to reverse.
		 */
		public static function str_reverse(str:String):String{
			var r:String = '';
			for(var i:int = str.length; i > 0; i--){
				r += str.charAt(i - 1);
			}
			return r;
		}
		
		/**
		 * Pads a string with leading characters. If the specified 
		 * length is less than the string's current length, it will 
		 * be truncated at the left.
		 * @param str	The string to pad
		 * @param char	The pad character
		 * @param len	The length of the padded string
		 */
		public static function pad_left(str:String, char:String, len:Number):String{
			//test current string length
			var curr_len:Number = str.length;
			var repeat:Number = len - curr_len
			if(repeat > 0){
				var pad:String = Common.str_repeat(char, repeat);
				str = pad + str;
			}else{
				var i:Number = len - curr_len - 1;
				str = str.substr(i);
			}
			return str;
		}
		
		/**
		 * Pads a string with trailing characters. If the specified 
		 * length is less than the string's current length, it will 
		 * be truncated at the right.
		 * @param str	The string to pad
		 * @param char	The pad character
		 * @param len	The length of the padded string
		 */
		public static function pad_right(str:String, char:String, len:Number):String{
			//test current string length
			var curr_len:Number = str.length;
			var repeat:Number = len - curr_len
			if(repeat > 0){
				var pad:String = Common.str_repeat(char, repeat);
				str += pad;
			}else{
				str = str.substr(0, len);
			}
			return str;
		}
		
		/**
		 * Converts newline characters to html <br> tags and tabs to spaces.
		 * @param str	The string to convert.
		 */
		public static function nl2br(str:String):String{
			//ensure that the global flag (g) is set to replace all instances.
			var pattern1:RegExp = /\n/g;
			var pattern2:RegExp = /\t/g;
			var replace1:String = '<br />';
			var replace2:String = '&nbsp;';
			
			var r1:String = str;
			var r2:String = str;
			if(str.indexOf('\n') != -1){
				r1 = str.replace(pattern1, replace1);
			}
			if(r1.indexOf('\t') != -1){
				r2 = r1.replace(pattern2, replace2);
			}
			return r2;
		}
		
		/**
		 * Format telephone string. This method assumes that only 
		 * numbers are submitted.
		 * @param string v
		 * @result string r
		 */
		public static function format_telephone(str:String):String{
			var r:String = '';
			var ptn1:RegExp = /^([2-9][0-9]{2})?([\\s\\.-]+)?([2-9][0-9]{2})([\\s\\.-]+)?([0-9]{4})$/gim;
			var ptn2:RegExp = /[\\(\\)\\s\\.-]+/g;
			
			if(ptn1.test(str)){
				str.replace(ptn2, '');
				if(str.length > 7){
					r = str.substr(0, 3) + '-' + str.substr(3, 3) + '-' + str.substr(6);
				}else{
					r = str.substr(0, 3) + '-' + str.substr(3);
				}
			}
			return r;
		}
		
		/**
		 * Formats a string as money
		 * @param v	The number to format
		 */
		public static function format_dollar(v:Number):String{
			//convert the number into a string with a fixed decimal
			var str:String = v.toFixed(2);
			
			//strip the cents off the string
			var cents:String = str.slice(-2);
			
			//create a new string of just the dollars
			//stripping off the cents and the decimal point
			var dollars:String = str.substring(0, str.length - 3);
			
			//create an array of groups of dollars
			//starting at the right
			var arr:Array = new Array();
			do{
				arr.push(dollars.slice(-3));
				dollars = dollars.substring(0, dollars.length - 3);
			}while(dollars.length > 3);
			
			//add any remaining dollars
			if(dollars.length > 0){
				arr.push(dollars);
			}
			
			//reverse the order of the array
			arr.reverse();
			
			//return a simple join
			return arr.join() + '.' + cents;
		}
	
		/*------------------------------------------------------------
		VALIDATION FUNCTIONS
		------------------------------------------------------------*/
		/**
		 * Validate date
		 * @param string v
		 * @result string r
		 */
		public static function validate_date(v:String){
			var r = '';
			if(v is String && v.length > 0){
				var year_min:Number = 1900;
				var year_max:Number = 2100;
				var days_in_month = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
				var pattern:RegExp = /[\-\s\/\.]+/g;
				var arr:Array = v.split(pattern);
				
				//test year
				var test_date = new Date();
				var this_year = test_date.getFullYear();
				var year = arr[2];
				var test_year:Number = Number(year);
				if(year.length == 2){
					var this_year_2 = Number(String(this_year).substr(2, 2));
					if(this_year_2 - test_year < 0){
						test_year += 1900;
					}else{
						test_year += 2000;
					}
				}
				if(test_year < year_min || test_year > year_max){
					return null;
				}
				
				//test month
				var test_month = parseInt(arr[0]);
				if(test_month < 1 || test_month > 12){
					return null;
				}
				
				//test day
				var test_day = parseInt(arr[1]);
				var february_days = Common.get_february_days(test_year);
				if((test_day < 1) || (test_day > days_in_month[test_month - 1]) 
						|| (test_month == 2 && test_day > february_days)){
					return null;
				}
				
				//return formatted date
				return test_month + '/' + test_day + '/' + test_year;
			}
			return null;
		}
		
		private static function get_february_days(year:uint):uint{
			var r:uint = 28;
			if(year % 100 == 0){
				if(year % 400 == 0){
					r = 29;
				}
			}else{
				if(year % 4 == 0){
					r = 29;
				}
			}
			return r;
		}
		
		/**
		 * Validate email
		 * @param str	The email string to validate
		 */
		public static function validate_email(str:String):String{
			var ptn:RegExp = /([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,6})/;
			var test = ptn.test(str);
			if(!test){
				str = '';
			}
			return str;
		}
	}
}