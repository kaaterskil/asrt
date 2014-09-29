/**
 * AStory_decorator.as
 *
 * Class definition
 * @description	An abstract decorator class.
 * @inheritance	AStory_decorator -> AStory -> Sprite
 * @interface	IStory
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080416
 * @package		com.kaaterskil.display.stories
 */

package com.kaaterskil.display.stories{
	import flash.display.*;
	import flash.text.*;
	
	/**
	 * All public methods delegate to the decorated class.
	 */
	public class AStory_decorator extends AStory{
		private var _story:IStory;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function AStory_decorator(story:IStory):void{
			_story = story;
		}
		
		/*------------------------------------------------------------
		GETTER / SETTER METHODS
		------------------------------------------------------------*/
		/**
		 * Get params
		 */
		override public function get_prams():Object{
			return _story.get_prams();
		}
		
		/**
		 * Get display container (and contents)
		 */
		override public function get_container():DisplayObjectContainer{
			return _story.get_container();
		}
		
		/**
		 * Get format
		 */
		override public function get_format(id:String):TextFormat{
			return _story.get_format(id);
		}
		
		/**
		 * Get text index length
		 */
		override public function index_length():int{
			return _story.index_length();
		}
		
		/**
		 * Read text index
		 */
		override public function read_index(i:int = -1):Object{
			return _story.read_index(i);
		}
		
		/**
		 * Add item to text index
		 */
		override public function push_index(obj:Object):void{
			_story.push_index(obj);
		}
		
		/**
		 * Remove item from text index
		 */
		override public function splice_index(start_index:int, count:int = 1):void{
			_story.splice_index(start_index, count);
		}
		
		/*------------------------------------------------------------
		DRAWING METHODS
		------------------------------------------------------------*/
		/**
		 * Draw headline text
		 */
		override public function draw_headline():void{
			_story.draw_headline();
		}
		
		/**
		 * Draw body text
		 */
		override public function draw_body(text_width:Number = 0):void{
			_story.draw_body(text_width);
		}
	}
}