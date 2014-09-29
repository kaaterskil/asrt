/**
 * AStory.as
 *
 * Class definition
 * @description	This is the abstract decorated class, and provides 
 *				base functionality to other extended decorated 
 *				classes, such as creating a containing display object,
 *				retrieving text format information from an application's
 *				global Settings class and creating text fields using the
 *				custom Text_field class.
 * @inheritance	AStory -> Sprite
 * @interface	IStory
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080416
 * @package		com.kaaterskil.display.stories
 */

package com.kaaterskil.display.stories{
	import flash.display.*;
	import flash.errors.*;
	import flash.text.*;
	
	public class AStory extends Sprite implements IStory{
		/**
		 * Constructor
		 */
		public function AStory():void{}

		/**
		 * Get parameters
		 */
		public function get_prams():Object{
			throw new IllegalOperationError('Abstract method get_prams() must be overridden by a subclass.');
		}

		/**
		 * Get container
		 */
		public function get_container():DisplayObjectContainer{
			throw new IllegalOperationError('Abstract method get_container() must be overridden by a subclass.');
		}

		/**
		 * Get index length
		 */
		public function index_length():int{
			throw new IllegalOperationError('Abstract method index_length() must be overridden by a subclass.');
		}

		/**
		 * Get index
		 */
		public function read_index(i:int = -1):Object{
			throw new IllegalOperationError('Abstract method read_index() must be overridden by a subclass.');
		}

		/**
		 * Add to index
		 */
		public function push_index(obj:Object):void{
			throw new IllegalOperationError('Abstract method push_index() must be overridden by a subclass.');
		}

		/**
		 * Splice index
		 */
		public function splice_index(start_index:int, count:int = 1):void{
			throw new IllegalOperationError('Abstract method splice_index() must be overridden by a subclass.');
		}
		
		/**
		 * Get text format
		 */
		public function get_format(id:String):TextFormat{
			throw new IllegalOperationError('Abstract method get_format() must be overridden by a subclass.');
		}

		/**
		 * Draw headline text
		 */
		public function draw_headline():void{
			throw new IllegalOperationError('Abstract method draw_headline() must be overridden by a subclass.');
		}
		
		/**
		 * Draw body text
		 */
		public function draw_body(text_width:Number = 0):void{
			throw new IllegalOperationError('Abstract method draw_body() must be overridden by a subclass.');
		}
	}
}