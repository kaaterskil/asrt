/**
 * Array_library.as
 *
 * Class definition
 * @inheritance	none
 * @interface	ILibrary
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080415
 * @package		com.kaaterskil.utilities.libraries
 */

package com.kaaterskil.utilities.libraries{
	import com.kaaterskil.utilities.*;
	import com.kaaterskil.utilities.iterators.*;
	
	public class Array_library implements ILibrary{
		private var _data:Array;
		
		public function Array_library():void{
			_data = new Array();
		}
		
		public function add_array(arr:Array):void{
			_data = arr;
		}
		
		public function add_element(obj:Object):void{
			_data.push(obj);
		}
		
		public function enumerate():void{
			trace(Common.enumerate_obj(_data));
		}
		
		//ILibrary interface
		public function get_size():int{
			return _data.length;
		}
		
		//ILibrary interface
		public function iterator(type:String = null):IIterator{
			switch(type){
				case 'Iterator_desc':
					return new Iterator_desc(_data);
					break;
				default:
					return new Iterator_asc(_data);
					break;
			}
		}
	}
}