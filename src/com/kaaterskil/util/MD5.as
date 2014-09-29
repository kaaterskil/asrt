/**
 * MD5.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080407
 * @package com.kaaterskil.utilities
 */

package com.kaaterskil.utilities{
	
	/**
	 * Converst a string to a 128-bit message digest.
	 */
	public class MD5{
		/**
		 * Constructor
		 */
		public function MD5():void{
		}
		
		private function convert(str:String):String{
			var s11:int = 7;
			var s12:int	= 12;
			var s13:int	= 17;
			var s14:int	= 22;
			var s21:int	= 5;
			var s22:int	= 9;
			var s23:int	= 14;
			var s24:int	= 20;
			var s31:int	= 4;
			var s32:int	= 11;
			var s33:int	= 16;
			var s34:int	= 23;
			var s41:int	= 6;
			var s42:int	= 10;
			var s43:int	= 15;
			var s44:int	= 21;
			
			var arr:Array = convert_to_word_array(str);
			
			//initialize
			var a:Number	= 0x67452301;
			var b:Number	= 0xEFCDAB89;
			var c:Number	= 0x98BADCFE;
			var d:Number	= 0x10325476;
			
			//process the message in 16-word blocks
			for(var k:int = 0; k < arr.length; k += 16){
				var AA:Number = a;
				var BB:Number = b;
				var CC:Number = c;
				var DD:Number = d;
				
				a = ff(a, b, c, d, arr[k + 0],  s11, 0xD76AA478);
				d = ff(d, a, b, c, arr[k + 1],  s12, 0xE8C7B756);
				c = ff(c, d, a, b, arr[k + 2],  s13, 0x242070DB);
				b = ff(b, c, d, a, arr[k + 3],  s14, 0xC1BDCEEE);
				a = ff(a, b, c, d, arr[k + 4],  s11, 0xF57C0FAF);
				d = ff(d, a, b, c, arr[k + 5],  s12, 0x4787C62A);
				c = ff(c, d, a, b, arr[k + 6],  s13, 0xA8304613);
				b = ff(b, c, d, a, arr[k + 7],  s14, 0xFD469501);
				a = ff(a, b, c, d, arr[k + 8],  s11, 0x698098D8);
				d = ff(d, a, b, c, arr[k + 9],  s12, 0x8B44F7AF);
				c = ff(c, d, a, b, arr[k + 10], s13, 0xFFFF5BB1);
				b = ff(b, c, d, a, arr[k + 11], s14, 0x895CD7BE);
				a = ff(a, b, c, d, arr[k + 12], s11, 0x6B901122);
				d = ff(d, a, b, c, arr[k + 13], s12, 0xFD987193);
				c = ff(c, d, a, b, arr[k + 14], s13, 0xA679438E);
				b = ff(b, c, d, a, arr[k + 15], s14, 0x49B40821);
				a = gg(a, b, c, d, arr[k + 1],  s21, 0xF61E2562);
				d = gg(d, a, b, c, arr[k + 6],  s22, 0xC040B340);
				c = gg(c, d, a, b, arr[k + 11], s23, 0x265E5A51);
				b = gg(b, c, d, a, arr[k + 0],  s24, 0xE9B6C7AA);
				a = gg(a, b, c, d, arr[k + 5],  s21, 0xD62F105D);
				d = gg(d, a, b, c, arr[k + 10], s22, 0x2441453);
				c = gg(c, d, a, b, arr[k + 15], s23, 0xD8A1E681);
				b = gg(b, c, d, a, arr[k + 4],  s24, 0xE7D3FBC8);
				a = gg(a, b, c, d, arr[k + 9],  s21, 0x21E1CDE6);
				d = gg(d, a, b, c, arr[k + 14], s22, 0xC33707D6);
				c = gg(c, d, a, b, arr[k + 3],  s23, 0xF4D50D87);
				b = gg(b, c, d, a, arr[k + 8],  s24, 0x455A14ED);
				a = gg(a, b, c, d, arr[k + 13], s21, 0xA9E3E905);
				d = gg(d, a, b, c, arr[k + 2],  s22, 0xFCEFA3F8);
				c = gg(c, d, a, b, arr[k + 7],  s23, 0x676F02D9);
				b = gg(b, c, d, a, arr[k + 12], s24, 0x8D2A4C8A);
				a = hh(a, b, c, d, arr[k + 5],  s31, 0xFFFA3942);
				d = hh(d, a, b, c, arr[k + 8],  s32, 0x8771F681);
				c = hh(c, d, a, b, arr[k + 11], s33, 0x6D9D6122);
				b = hh(b, c, d, a, arr[k + 14], s34, 0xFDE5380C);
				a = hh(a, b, c, d, arr[k + 1],  s31, 0xA4BEEA44);
				d = hh(d, a, b, c, arr[k + 4],  s32, 0x4BDECFA9);
				c = hh(c, d, a, b, arr[k + 7],  s33, 0xF6BB4B60);
				b = hh(b, c, d, a, arr[k + 10], s34, 0xBEBFBC70);
				a = hh(a, b, c, d, arr[k + 13], s31, 0x289B7EC6);
				d = hh(d, a, b, c, arr[k + 0],  s32, 0xEAA127FA);
				c = hh(c, d, a, b, arr[k + 3],  s33, 0xD4EF3085);
				b = hh(b, c, d, a, arr[k + 6],  s34, 0x4881D05);
				a = hh(a, b, c, d, arr[k + 9],  s31, 0xD9D4D039);
				d = hh(d, a, b, c, arr[k + 12], s32, 0xE6DB99E5);
				c = hh(c, d, a, b, arr[k + 15], s33, 0x1FA27CF8);
				b = hh(b, c, d, a, arr[k + 2],  s34, 0xC4AC5665);
				a = ii(a, b, c, d, arr[k + 0],  s41, 0xF4292244);
				d = ii(d, a, b, c, arr[k + 7],  s42, 0x432AFF97);
				c = ii(c, d, a, b, arr[k + 14], s43, 0xAB9423A7);
				b = ii(b, c, d, a, arr[k + 5],  s44, 0xFC93A039);
				a = ii(a, b, c, d, arr[k + 12], s41, 0x655B59C3);
				d = ii(d, a, b, c, arr[k + 3],  s42, 0x8F0CCC92);
				c = ii(c, d, a, b, arr[k + 10], s43, 0xFFEFF47D);
				b = ii(b, c, d, a, arr[k + 1],  s44, 0x85845DD1);
				a = ii(a, b, c, d, arr[k + 8],  s41, 0x6FA87E4F);
				d = ii(d, a, b, c, arr[k + 15], s42, 0xFE2CE6E0);
				c = ii(c, d, a, b, arr[k + 6],  s43, 0xA3014314);
				b = ii(b, c, d, a, arr[k + 13], s44, 0x4E0811A1);
				a = ii(a, b, c, d, arr[k + 4],  s41, 0xF7537E82);
				d = ii(d, a, b, c, arr[k + 11], s42, 0xBD3AF235);
				c = ii(c, d, a, b, arr[k + 2],  s43, 0x2AD7D2BB);
				b = ii(b, c, d, a, arr[k + 9],  s44, 0xEB86D391);
				
				a = add_unsigned(a, AA);
				b = add_unsigned(b, BB);
				c = add_unsigned(c, CC);
				d = add_unsigned(d, DD);
			}
			
			//output the 128-bit digest
			var r:String = word_to_hex(a) + word_to_hex(b) + word_to_hex(c) + word_to_hex(d);
			return r.toLowerCase();
		}
		
		private function convert_to_word_array(str:String):Array{
			var count:Number;
			var str_len:int		= str.length;
			var word_count1:int = str_len + 8;
			var word_count2:int = (word_count1 - (word_count1 % 64)) / 64;
			var word_count:int	= (word_count2 + 1) * 16;
			
			var arr:Array = new Array(word_count - 1);
			var byte_pos:int	= 0;
			var byte_count:int	= 0;
			while(byte_count < str_len){
				count		= (byte_count - (byte_count % 4)) / 4;
				byte_pos	= (byte_count % 4) * 8;
				arr[count]	= (arr[count] | (str.charCodeAt(byte_count) << byte_pos));
				byte_count++;
			}
			
			count				= (byte_count - (byte_count % 4)) / 4;
			byte_pos			= (byte_count % 4) * 8;
			arr[count]			= arr[count] | (0x80 << byte_pos);
			arr[word_count - 2]	= str_len << 3;
			arr[word_count - 1]	= str_len >>> 29;
			
			return arr;
		}
		
		private function add_unsigned(x1:Number, y1:Number):Number{
			var x4:Number	= (x1 & 0x40000000);
			var y4:Number	= (y1 & 0x40000000);
			var x8:Number	= (x1 & 0x80000000);
			var y8:Number	= (y1 & 0x80000000);
			var r:Number	= (x1 & 0x3FFFFFFF) + (y1 & 0x3FFFFFFF);
			
			if(x4 & y4){
				return (r ^ 0x80000000 ^ x8 ^ y8);
			}
			if(x4 | y4){
				if(r & 0x40000000){
					return (r ^ 0xC0000000 ^ x8 ^ y8);
				}else{
					return (r ^ 0x40000000 ^ x8 ^ y8);
				}
			}else{
				return (r ^ x8 ^ y8);
			}
		}
		
		private function word_to_hex(str:Number):String{
			var r:String	= '';
			var temp:String	= '';
			var byte:Number;
			
			for(var i:int = 0; i <= 3; i++){
				byte	= (str >>> (i * 8)) & 255;
				temp	= '0' + byte.toString(16);
				r		+= temp.substr(temp.length - 2, 2);
			}
			return r;
		}
		
		private function ff(a, b, c, d, x, s, ac):Number{
			a = add_unsigned(a, add_unsigned(add_unsigned(f(b, c, d), x), ac));
			return add_unsigned(rotate_left(a, s), b);
		}
		
		private function gg(a, b, c, d, x, s, ac):Number{
			a = add_unsigned(a, add_unsigned(add_unsigned(g(b, c, d), x), ac));
			return add_unsigned(rotate_left(a, s), b);
		}
		
		private function hh(a, b, c, d, x, s, ac):Number{
			a = add_unsigned(a, add_unsigned(add_unsigned(h(b, c, d), x), ac));
			return add_unsigned(rotate_left(a, s), b);
		}
		
		private function ii(a, b, c, d, x, s, ac):Number{
			a = add_unsigned(a, add_unsigned(add_unsigned(i(b, c, d), x), ac));
			return add_unsigned(rotate_left(a, s), b);
		}
		
		/*------------------------------------------------------------
		UTILITY FUNCTIONS
		------------------------------------------------------------*/
		private function rotate_left(v:Number, bits:int):Number{
			return (v << bits) | (v >>> (32 - bits));
		}
		
		private function f(a, b, c):Number{
			return (a & b) | ((~a) & c);
		}
		
		private function g(a, b, c):Number{
			return (a & c) | (b & (~c));
		}
		
		private function h(a, b, c):Number{
			return (a ^ b ^ c);
		}
		
		private function i(a, b, c):Number{
			return (b ^ (a | (~c)));
		}
	}
}