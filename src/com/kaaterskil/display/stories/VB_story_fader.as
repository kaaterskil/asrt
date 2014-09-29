/**
 * VB_story_download.as
 *
 * Class definition
 * @description	A decorator class.
 * @inheritance	VB_story_fader -> AStory_decorator -> AStory -> Sprite
 * @interface	IStory
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080417
 * @package		com.kaaterskil.display.stories
 */

package com.kaaterskil.display.stories{
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import flash.display.*;
	
	import com.kaaterskil.utilities.*;
	
	public class VB_story_fader extends AStory_decorator{
		private var _container:DisplayObjectContainer;
		
		/**
		 * Constructor
		 */
		public function VB_story_fader(story:IStory):void{
			super(story);
			_container = get_container();
			set_alpha();
			fade_in();
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Sets all story text block alpha properties to zero.
		 */
		private function set_alpha():void{
			var num:int = _container.numChildren;
			for(var i:int = 0; i < num; i++){
				var c:* 		= _container.getChildAt(i);
				var str:String	= c.name.toLowerCase();
				if(str.indexOf('body') != -1 || str.indexOf('headline') != -1){
					c.alpha = 0;
				}
			}
		}
		
		/**
		 * Fade in the story text blocks
		 */
		private function fade_in():void{
			var num:int = _container.numChildren;
			for(var i:int = 0; i < num; i++){
				var c:* 		= _container.getChildAt(i);
				var str:String	= c.name.toLowerCase();
				if(str.indexOf('body') != -1 || str.indexOf('headline') != -1){
					var tw:Tween = Common.do_tween('fade_in', c, 'alpha', None.easeNone, 
												   0, 1, Settings.STORY_FADE_IN_DELAY);
				}
			}
		}
	}
}