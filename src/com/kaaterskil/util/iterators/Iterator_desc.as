/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.iterators
 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
 */
 
package com.kaaterskil.utilities.iterators{
	/**
	 * Iterator_desc class
	 *
	 * This class traverses an array in descending order
	 * 
	 * @package		com.kaaterskil.utilities.iterators
	 * @inheritance	none
	 * @interface	IIterator
	 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
	 * @version		080415
	 */
	public class Iterator_desc implements IIterator{
		private var _index:int;
		private var _library:Array;
		
		public function Iterator_desc(library:Array):void{
			_library	= library;
			_index		= _library.length - 1;
		}
		
		public function reset():void{
			_index = _library.length - 1;
		}
		
		public function next():Object{
			return _library[_index--];
		}
		
		public function has_next():Boolean{
			return _index >= 0;
		}
	}
}