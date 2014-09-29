/**
 * Attribute_handler.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080412
 * @package com.kaaterskil.cart
 */

package com.kaaterskil.cart{
	import flash.display.*;
	import flash.events.*;
	import.flash.text.*;
	
	import com.kaaterskil.utilities.*;
	
	public class Attribute_handler extends Sprite{
		/**
		 * Parameters
		 */
		private var _prams:Array;
		private var _sort_index:Array;
		
		public function Attribute_handler(attributes:Array, sales:Array):void{
			_prams = attributes;
		}
		
		public function build_display():DisplayObjectContainer{
			_prams.sortOn('attribute_sort_order', Array.NUMERIC);
		}
	}
}