/**
 * Display_factory
 *
 * Class defintiion
 * @description	This is a concrete creator class of the factory method.
 * @inheritance	Display_factory -> ADisplay_factory
 * @interface	none
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080417
 * @package		com.kaaterskil.display.factories
 */

package com.kaaterskil.display.factories{
	import flash.utils.*;
	
	import com.kaaterskil.display.movies.*;
	
	public class Display_factory extends ADisplay_factory{
		/**
		 * Constants
		 */
		public static const TEXT_FIELD	:int = 0;
		public static const FILE		:int = 1;
		public static const IMAGE		:int = 2;
		public static const MOVIE		:int = 3;
		
		/**
		 * Since the product class to instantiate is not known until
		 * runtime, we need to declare some variables (unused) so that
		 * all the possible classes will be compiled.
		 */
		private var text_field			:Text_product;
		private var image_field			:Story_image_product;
		private var download			:Download_product;
		private var video_player		:Basic_video_player;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Creator function
		 * @param type	One of the class ids identified above.
		 */
		override protected function create(id:int):IDisplay{
			var types:Array = get_types();
			for each(var obj:Object in types){
				if(obj.type == id){
					return new(getDefinitionByName(obj.class_name));
				}
			}
			return null;
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Build array of acceptable classes for this factory
		 */
		private function get_types():Array{
			var class_name:String;
			
			var arr:Array = new Array();
			for(var i:int = 0; i < 4; i++){
				switch(i){
					case 0:
						class_name = 'com.kaaterskil.display.factories.Text_product';
						break;
					case 1:
						class_name = 'com.kaaterskil.display.factories.Download_product';
						break;
					case 2:
						class_name = 'com.kaaterskil.display.factories.Story_image_product';
						break;
					case 3:
						class_name = 'com.kaaterskil.display.movies.Basic_video_player';
						break;
				}
				var obj:Object = {type:i, class_name:class_name};
				arr.push(obj);
			}
			return arr;
		}
	}
}