/**
 * VB_story.as
 *
 * Class definition
 * @description A decorator class.
 * @inheritance	VB_story -> AStory_decorator -> AStory -> Sprite
 * @interface	IStory
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080417
 * @package		com.kaaterskil.display.stories
 */
 
package com.kaaterskil.display.stories{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	
	import com.kaaterskil.display.factories.*;
	import com.kaaterskil.utilities.*;
	
	public class VB_story extends AStory_decorator{
		private var text_fld:Text_product;
		Font_embedder;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function VB_story(story:IStory):void{
			super(story);
			draw_body();
		}
		
		/*------------------------------------------------------------
		DRAWING METHODS
		------------------------------------------------------------*/
		/**
		 * Draw body text
		 */
		override public function draw_body(text_width:Number = 0):void{
			var body_pram:* = get_prams().body;			
			if(body_pram is Array){
				//set initial vertical placement
				var point:Point = new Point(0, 0);
				var container = get_container();
				
				//remove existing body text
				for(var i:int = container.numChildren - 1; i >= 0; i--){
					var c:DisplayObject = container.getChildAt(i);
					if(c.name.toLowerCase() == 'body_text'){
						container.removeChildAt(i);
					}
				}
				
				//get bottom of headline
				for(i = 0; i < container.numChildren; i++){
					c = container.getChildAt(i);
					if(c.name.toLowerCase().indexOf('headline') != -1){
						var bounds:Rectangle = c.getBounds(container);
						point = bounds.topLeft;
						point.y += bounds.height + Settings.HEADLINE_MARGIN;
						break;
					}
				}
				
				//get text width
				if(text_width == 0){
					text_width = Settings.CONTENT_WIDTH;
				}
				
				//set text parameters
				var props:Object = {
					AntiAliasType:	AntiAliasType.ADVANCED, 
					autoSize:		TextFieldAutoSize.LEFT, 
					//border:			true, 
					//borderColor:	0xff0000, 
					embedFonts:		true, 
					multiline:		true, 
					text:			'', 
					visible:		true, 
					width:			text_width, 
					wordWrap:		true
				};
				var format:TextFormat = get_format('roman');
				var obj:Object = {
					x:		point.x, 
					y:		point.y, 
					name:	'body_text', 
					prams:	{props:props, format:format}
				};
								  
				//draw empty text field
				draw_text_field(obj);
				
				//loop through body array
				var char:int = 0;
				for(i = 0; i < body_pram.length; i++){
					var element:Object	= body_pram[i];
					var tag:String		= element.tag.toLowerCase();
					var str:String		= element.text;
					
					//add termination characters - test next element type
					//newline for paragraphs and lists, whitepsace for others
					if((i + 1) < body_pram.length){
					   if (body_pram[i + 1].tag == 'p'){
						   str += '\n\n';
					   }else if(body_pram[i + 1].tag == 'li'){
						   str += '\n';
					   }else if(body_pram[i + 1].tag == 'i' || body_pram[i + 1].tag == 'em'){
						   str += '  ';
					   }else{
						   str += ' ';
					   }
					}
					
					//set format
					switch(tag){
						case 'p':
							format = get_format('roman');
							break;
						case 'em':
						case 'i':
							format = get_format('italic');
							break;
						case 'strong':
						case 'b':
							format = get_format('bold');
							break;
						case 'u':
							format = get_format('underline');
							break;
						case 'li':
							format = get_format('indent');
							break;
						case 'a':
							var href:String = element.text;
							if(element.text.indexOf('@') != -1){
								href = 'mailto:' + href;
							}
							format = get_format('link');
							format.url = href;
							break;
						default:
							format = get_format('roman');
							break;
					}
				
					//append text and apply format
					var len = str.length;
					var fld:* = read_index();
					fld.append(str);
					fld.reset_format(format, char, char + len);
					char += len;
				}//end for
			}
		}//end function
		
		/**
		 * Draw text field
		 */
		private function draw_text_field(obj:Object):void{
			var container:DisplayObjectContainer = get_container();
			
			//create text field
			var factory:Display_factory = new Display_factory();
			factory.init(obj, container, Display_factory.TEXT_FIELD);
			
			//add to library
			push_index(factory._instance);
		}
		
	}
}