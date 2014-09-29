/**
 * Story_handler.as
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080416
 * @package com.kaaterskil.display.handlers
 */

package com.kaaterskil.display.handlers{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.*;
	
	import com.kaaterskil.utilities.*;
	import com.kaaterskil.utilities.iterators.*;
	import com.kaaterskil.utilities.libraries.*;
	import com.kaaterskil.display.stories.*;
	
	public class Story_handler extends Sprite implements IContent_handler{
		/**
		 * Containers
		 */
		private var _container:Sprite;
		
		/**
		 * Libraries
		 */
		private var _story_index:Array;
		
		/**
		 * Parameters
		 */
		private var _start_position:Point;
		private var _selected_menu:int;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Story_handler():void{
			_story_index	= [];
			this.name		= 'story_handler';
			create_container();
		}
		
		/**
		 * Draw stories
		 * @params prams	An object containing starting x/y positions.
		 * @params menu_id	The id number of the selected menu.
		 */
		public function render(point:Point, menu_id:int):void{
			_selected_menu = menu_id;
			_start_position = point;
			
			if(_story_index.length > 0){
				remove();
			}else{
				render_part2();
			}
		}
		
		/**
		 * Clear stories
		 */
		public function remove():void{
			if(_story_index.length > 0){
				clear_display();
			}
		}
		
		
		/*------------------------------------------------------------
		DRAWING METHODS
		------------------------------------------------------------*/
		/**
		 * Create container
		 */
		private function create_container():void{
			_container = new Sprite();
			_container.name = 'story_handler_container';
			addChild(_container);
		}
		
		/**
		 * Render stories. This method gets an instance of the IIterator
		 * interface with a clone of the story array. It loops through
		 * the object and draws stories that match the selected menu,
		 * adding the story to the display list and the index tracker.
		 */
		private function render_part2():void{
			var point:Point = new Point(_start_position.x, _start_position.y);
			
			var iterator:IIterator = Settings.get_instance().get_stories();
			while(iterator.has_next()){
				var obj:Object = iterator.next();
				if(obj.menu_id == _selected_menu){
					//create story
					var story:AStory = new Basic_story(obj);
					_story_index.push(story);
					_container.addChild(story);
					story.x = point.x;
					story.y = point.y;
					
					//use decorator versions for more functionality
					if(obj.body is Array){
						story = new VB_story(story);
					}
					if(obj.downloads != null){
						story = new VB_story_download(story);
					}
					if(Settings.STORY_IS_FADE_IN){
						story = new VB_story_fader(story);
					}
					
					//increment coordinates
					point.y += story.height + Settings.STORY_SEPARATOR;
				}
			}
		}
		
		/**
		 * Clear stories
		 */
		private function clear_display():void{
			while(_container.numChildren > 0){
				var c:* = _container.getChildAt(0);
				_container.removeChildAt(0);
			}
			_story_index = new Array();
			render_part2();
		}
	}
}