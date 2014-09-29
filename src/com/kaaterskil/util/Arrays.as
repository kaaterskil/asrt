/**
 * Kaaterskil Library
 * Copyright (C) 2008-2011 Kaaterskil Management, LLC.
 * 
 * This program is free software: you can redistribute it 
 * and/or modify it under the terms of the GNU Affero General 
 * Public License as published by the Free Software Foundation, 
 * either version 3 of the License, or (at your option) any 
 * later version.
 * 
 * This program is distributed in the hope that it will be 
 * useful, but WITHOUT ANY WARRANTY; without even the implied 
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
 * PURPOSE.  See the GNU Affero General Public License for more 
 * details.
 * 
 * You should have received a copy of the GNU Affero General 
 * Public Licensealong with this program.  If not, see 
 * <http://www.gnu.org/licenses/> or write to the Free Software 
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, 
 * MA 02110-1301 USA.
 *
 * You can contact Kaaterskil Management, LLC at 45 Avon Road, 
 * Wellesley, MA USA 02482, or by email at questions@kaaterskil.com.
 * 
 * The interactive user interfaces in modified source and object 
 * code versionsof this program must display Appropriate Legal 
 * Notices, as required under Section 5 of the GNU Affero General 
 * Public License version 3.
 * 
 * In accordance with Section 7(b) of the GNU Affero General 
 * Public License version 3, these Appropriate Legal Notices 
 * must display the words "Powered by Kaaterskil".
 */
package com.kaaterskil.util {
	/**
	 * Utility functions for arrays
	 *
	 * @author Blair Caple
	 * @version $Id: $
	 */
	public class Arrays {
		
		public static function arraycopy(
				src:Array, srcPos:int, dest:Array, destPos:int, len:int) : void {
			if(src == null || dest == null){
				throw new Error();
			}
			if((srcPos > src.length) || (destPos > dest.length) 
					|| (srcPos < 0) || (destPos < 0) || (len < 0)
					|| ((srcPos + len) > src.length) 
					|| ((destPos + len) > dest.length)){
				throw new Error();
			}
			for (var i:int = 0; i < len; i++) {
				dest[i + destPos] = src[i + srcPos];
			}
		}
		
		public static function average(v:*) : Number {
			 var arr:Array;
			 if (v is String) {
			 	arr = String(v).split(',');
			 }else if (v is Array) {
			 	arr = v;
			 }else{
			 	return 0;
			 }
			 return sum(arr) / arr.length;
		}
		
		public static function sum(a:Array) : Number {
			var len:int = a.length;
			var sum:Number = 0;
			for (var i:int = 0; i < len; i++) {
				if(a[i] is Number || a[1] is int || a[i] is uint){
					sum += a[i];
				}else{
					if(a[i] is String && !isNaN(parseFloat(a[i]))){
						sum += parseFloat(a[i]);
					}
				}
			}
			return sum;
		}
		
		public static function arraySearch(
				needle:*, haystack:Array, strict:Boolean = false) : int {
			if(needle is String && !strict){
				needle = String(needle).toLowerCase();
			}
			for (var i:int = 0; i < haystack.length; i++) {
				var e:* = haystack[i];
				if(e is String && !strict){
					e = String(e).toLowerCase();
				}
				if(e == needle) {
					return i;
				}
			}
			return -1;
		}
		
		public static function inArray(
				needle:*, haystack:Array, strict:Boolean = false) : Boolean {
			if(needle is String && !strict){
				needle = String(needle).toLowerCase();
			}
			for (var i:int = 0; i < haystack.length; i++) {
				var e:* = haystack[i];
				if(e is String && !strict){
					e = String(e).toLowerCase();
				}
				if(e == needle){
					return true;
				}
			}
			return false;
		}
		
		public static function keySet(
				needle:*, haystack:Array, strict:Boolean = false) : Array {
			var tmp:Array;
			var i:int;
			var key:*;
			if(null === needle){
				i	= 0;
				tmp	= new Array(haystack.length);
				for (key in haystack) {
					tmp[i++] = key;
				}
				return tmp;
			}else{
				if(needle is String && !strict){
					needle = String(needle).toLowerCase();
				}
				
				i	= 0;
				tmp	= new Array(haystack.length);
				for (key in haystack) {
					var e:* = haystack[key];
					if(e is String && !strict){
						e = String(e).toLowerCase();
					}
					if(e == needle){
						tmp[i++] = key;
					}
				}
				
				var result:Array = new Array(i);
				for (var j:int = 0; j < i; i++) {
					result[j] = tmp[j];
				}
				return result;
			}
		}
		
		public static function values(data:Array) : Array {
			var result:Array = new Array(data.length);
			var i:int = 0;
			for each (var e:* in data) {
				result[i++] = e;
			}
			return result;
		}
	}
}
