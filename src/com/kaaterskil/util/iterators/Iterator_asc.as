/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.iterators
 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
 */
 
package com.kaaterskil.utilities.iterators{
	/**
	 * Iterator_asc class
	 *
	 * This class traverses an array in ascending order
	 * 
	 * @package		com.kaaterskil.utilities.iterators
	 * @inheritance	none
	 * @interface	IIterator
	 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
	 * @version		080415
	 */
	public class Iterator_asc implements IIterator{
		private var _index:int;
		private var _library:Array;
		
		public function Iterator_asc(library:Array):void{
			_index		= 0;
			_library	= library;
		}
		
		public function reset():void{
			_index = 0;
		}
		
		public function next():Object{
			return _library[_index++];
		}
		
		public function has_next():Boolean{
			return _index < _library.length;
		}
	}
}