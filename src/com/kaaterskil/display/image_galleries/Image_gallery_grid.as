/**
 * Image_gallery_grid.as
 *
 * Class definition
 * @description A concrete decorator class.
 * @inheritance	Image_gallery_grid -> AImage_gallery_decorator
 *				-> AImage_gallery -> AContent_display -> ADisplay -> Sprite
 * @interface	IImage_gallery -> IContent_display -> IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		0804245
 * @package		com.kaaterskil.display.image_galleries
 */
 
package com.kaaterskil.display.image_galleries{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.*;
	
	import com.kaaterskil.display.factories.*;
	import com.kaaterskil.utilities.*;
	import com.kaaterskil.utilities.iterators.*;
	
	public class Image_gallery_grid extends AImage_gallery_decorator{
		/**
		 * Libaries
		 */
		private var _data:Array;
		
		/**
		 * Parameters
		 */
		private var _container:DisplayObjectContainer;
		private var _iterator:IIterator;
		private var _items:int;
		private var _cells:int;
		private var _columns:int;
		private var _rows:int;
		
		/**
		 * Constructor
		 */
		public function Image_gallery_grid(gallery:IImage_gallery):void{
			super(gallery);
			
			_container	= get_container();
			_iterator	= get_index();
			_items		= index_length;
			
			_data = get_grid();
			assign_to_grid();
		}
		
		private function get_grid():Array{
			var dims:Object		= get_max_dims();
			var tmp_rows:int	= Settings.CONTENT_HEIGHT / (dims.h + Settings.IMAGE_MARGIN);
			_columns			= Math.floor(Settings.CONTENT_WIDTH / (dims.w + Settings.IMAGE_MARGIN));
			_rows				= Math.min(Math.ceil(_items / _columns), tmp_rows);
			_cells				= _columns * _rows;
			
			var arr:Array	= [];
			var point:Point	= new Point();
			for(var i:int = 0; i < _columns; i++){
				arr.push([]);
				point.x = Settings.CONTENT_WIDTH * i / _columns;
				for(var j:int = 0; j < _rows; j++){
					point.y = Settings.CONTENT_HEIGHT * j / _rows;
					arr[arr.length - 1].push({x:point.x, 
											 y:point.y, 
											 instance:null
											 });
				}
			}
			return arr;
		}
		
		/**
		 * Positions a gellery item and assgn it to the _data cell.
		 */
		private function assign_to_grid():void{
			var i:int = 0;
			
			_iterator.reset();
			while(_iterator.has_next()){
				var item:Object = _iterator.next();
				
				//assign to grid tracker
				var cell:Object = get_cell_id(i);
				_data[cell.col][cell.row].instance = item.instance;
				
				//position item in grid
				item.instance.x	= _data[cell.col][cell.row].x;
				item.instance.y	= _data[cell.col][cell.row].y;
				i++;
			}
		}
		
		/**
		 * Returns a cell reference
		 */
		private function get_cell_id(i:int):Object{
			var c:int	= i < _columns ? i : i % _columns;
			var r:int	= Math.floor(i / _columns);
			
			var obj:Object = {col:c, row:r};
			return obj;
		}
		
		/**
		 * Returns the maximum image height and width
		 */
		private function get_max_dims():Object{
			var obj:Object = {w:0, h:0}
			
			_iterator.reset();
			while(_iterator.has_next()){
				var item:Object = _iterator.next();
				obj.w			= Math.max(obj.w, item.instance.width);
				obj.h			= Math.max(obj.h, item.instance.height);
			}
			return obj;
		}
	}
}