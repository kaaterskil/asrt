/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.libraries
 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
 */

package com.kaaterskil.utilities.libraries{
	import com.kaaterskil.utilities.*;
	import com.kaaterskil.utilities.iterators.*;
	
	/**
	 * Library class
	 *
	 * @package		com.kaaterskil.utilities.libraries
	 * @inheritance	none
	 * @interface	ILibrary, ISearcher
	 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
	 * @version		080415
	 */
	public class Library implements ILibrary, ISearcher{
		private var _data:Array;
		
		public function Library():void{
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
		
		//ISearcher interface
		public function get_element(prop:String, val:*):Object{
			var obj:Object;
			for(var e:Object in _data){
				if(_data[e].hasOwnProperty(prop) && _data[e][prop].indexOf(val) != -1){
					obj = _data[e];
					break;
				}
			}
			return obj;
		}
		
		//ISearcher interface
		public function get_property(prop1:String, val:*, prop2:String):*{
			var r:*;
			for(var e:Object in _data){
				if(_data[e].hasOwnProperty(prop1) && _data[e][prop1].indexOf(val) != -1){
					r = _data[e][prop2];
					break;
				}
			}
			return r;
		}
	}
}