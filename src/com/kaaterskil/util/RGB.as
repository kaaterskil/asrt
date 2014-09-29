/**
 * RGB.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080215
 * @package com.kaaterskil.utilities
 *
 * Many thanks to the Swiss Flash User Group
 */

package com.kaaterskil.utilities{
	public class RGB{
		public var _red:Number;
		public var _green:Number;
		public var _blue:Number;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function RGB(rv:int = 0, gv:int = 0, bv:int = 0):void{
			_red	= rv;
			_green	= gv;
			_blue	= bv;
		}
		
		/**
		 * Returns a color object from a hax value.
		 */
		public static function create_from_hex(hv:String):RGB{
			var color:RGB = new RGB();
			if(hv.length == 7){
				color._red		= int('0x' + hv.substr(1, 2));
				color._green	= int('0x' + hv.substr(3, 2));
				color._blue		= int('0x' + hv.substr(5, 2));
			}else{
				trace('Hex color value is not valid.');
			}
			return color;
		}
		
		/**
		 * Returns a color object from a number value.
		 */
		public static function create_from_number(nv:Number):RGB{
			var color:RGB = new RGB();
			if(!isNaN(nv) && nv >= 0 && nv <= 0xFFFFFF){
				color._red		= nv >> 16 & 0xFF;
				color._green	= nv >> 8 & 0xFF;
				color._blue		= nv & 0xFF;
			}else{
				trace('Color value must be a number between 0 and 0xFFFFFF.');
			}
			return color;
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		public function set_red(v:int):void{
			if(!isNaN(v)){
				_red = Math.max(Math.min(v, 255), 0);
			}
		}
		
		public function set_green(v:int):void{
			if(!isNaN(v)){
				_green = Math.max(Math.min(v, 255), 0);
			}
		}
		
		public function set_blue(v:int):void{
			if(!isNaN(v)){
				_blue = Math.max(Math.min(v, 255), 0);
			}
		}
		
		public function get_red():int{
			return _red;
		}
		
		public function get_green():int{
			return _green;
		}
		
		public function get_blue():int{
			return _blue;
		}
		
		public function get_number():Number{
			return (_red << 16 | _green << 8 | _blue);
		}
		
		public function get_hex():String{
			return '0x' + _red.toString(16) + _green.toString(16) + _blue.toString(16);
		}
	}
}