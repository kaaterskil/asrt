/**
 * Basic_story.as
 *
 * Class definition
 * @description	This is the base decorated class of the decorator 
 *				pattern. It provides the minimum functionality of 
 *				the Story classes: drawing simple headline and
 *				body text fields, creating a containing display object,
 *				retrieving text formats from the application's global
 *				Settings class and creating text fields using the
 *				factory generated Text_product class class. Decorator
 *				classes will expand on this limited functionality.
 * @inheritance	Basic_story -> AStory -> Sprite
 * @interface	IStory
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080417
 * @package		com.kaaterskil.display.stories
 */

package com.kaaterskil.display.stories{
	import flash.display.*;
	import flash.errors.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.*;
	
	import com.kaaterskil.display.factories.*;
	import com.kaaterskil.utilities.*;
	import com.kaaterskil.utilities.iterators.*;

	public class Basic_story extends AStory{
		/**
		 * Containers
		 */
		private var _container:Sprite;
		
		/**
		 * Libraries
		 */
		private var _text_index:Array;
		
		/**
		 * Parameters
		 */
		private var _prams:Object;
		Font_embedder;
				
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Basic_story(prams:Object = null):void{
			_text_index = new Array();
			_prams		= prams;
			this.name	= 'story'
			create_container();
			draw_headline();
			draw_body();
		}
		
		/*------------------------------------------------------------
		GETTER / SETTER METHODS
		------------------------------------------------------------*/
		//from IStory interface
		override public function get_prams():Object{
			return _prams;
		}
		
		//from IStory interface
		override public function get_container():DisplayObjectContainer{
			return _container;
		}
		
		/**
		 * Get text format. This method creates an Iterator object to
		 * return a copy of the selected text format from the global
		 * Settings singleton. The format object has two properties: 
		 * a string id and a TextFomat object. If no format is found,
		 * the method throws an error.
		 * @param id	The name of the selected text format
		 */
		//from IStory interface
		override public function get_format(id:String):TextFormat{
			var iterator:IIterator = Settings.get_instance().get_formats();
			while(iterator.has_next()){
				var obj:Object = iterator.next();
				if(obj.name == id){
					return obj.format;
				}
			}
			var msg:String = 'No text format found for ' + id;
			throw new Error(msg);
		}
		
		//from IStory interface
		override public function index_length():int{
			return _text_index.length;
		}
		
		//from IStory interface
		override public function read_index(i:int = -1):Object{
			if(i >= 0 && i < _text_index.length){
				return _text_index[i];
			}else{
				return _text_index[_text_index.length - 1];
			}
		}
		
		//from IStory interface
		override public function push_index(obj:Object):void{
			_text_index.push(obj);
		}
		
		//from IStory interface
		override public function splice_index(start_index:int, count:int = 1):void{
			if((start_index + count > 0) && (start_index + count < _text_index.length)){
				_text_index.splice(start_index, count);
			}
		}
		
		/*------------------------------------------------------------
		DRAWING METHODS
		------------------------------------------------------------*/
		//from IStory interface
		override public function draw_headline():void{
			if(_prams.hasOwnProperty('headline') && _prams.headline != null){
				var point:Point = new Point(0, 0);
				var props:Object = {AntiAliasType:	AntiAliasType.ADVANCED,
									autoSize:		TextFieldAutoSize.LEFT,
									embedFonts:		true,
									multiline:		true,
									text:			_prams.headline,
									visible:		true,
									width:			Settings.CONTENT_WIDTH,
									wordWrap:		true
									};
				var format:TextFormat = get_format('headline');
				var obj:Object = {x:		point.x,
								  y:		point.y,
								  name:		'headline',
								  prams:	{props:props, format:format}
								  };
				draw_text_field(obj);
			}
		}
		
		//from IStory interface
		override public function draw_body(text_width:Number = 0):void{
			if(_prams.hasOwnProperty('body') && _prams.body != null && _prams.body is String){
				//set initial vertical placement
				var point:Point = new Point(0, 0);
				for(var i:int = 0; i < _container.numChildren; i++){
					var c:DisplayObject = _container.getChildAt(i);
					if(c.name == 'headline'){
						point.y = c.y + c.height + Settings.HEADLINE_MARGIN;
						break;
					}
				}
				
				//get text width
				if(text_width == 0){
					text_width = Settings.CONTENT_WIDTH;
				}
				
				//set text parameters
				var props:Object = {AntiAliasType:	AntiAliasType.ADVANCED,
									autoSize:		TextFieldAutoSize.LEFT,
									embedFonts:		true,
									multiline:		true,
									text:			_prams.body,
									visible:		true,
									width:			text_width,
									wordWrap:		true
									};
				var format:TextFormat = get_format('roman');
				var obj:Object = {x:		point.x,
								  y:		point.y,
								  name:		'body',
								  prams:	{props:props, format:format}
								  };
				draw_text_field(obj);
			}
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Create container
		 */
		private function create_container():void{
			_container = new Sprite();
			_container.name = 'story_container';
			addChild(_container);
		}
		
		/**
		 * Draw text field
		 */
		private function draw_text_field(obj:Object):void{
			//create text field
			var factory:Display_factory = new Display_factory();
			factory.init(obj, _container, Display_factory.TEXT_FIELD);
			
			//add to library
			push_index(factory._instance);
		}
	}
}