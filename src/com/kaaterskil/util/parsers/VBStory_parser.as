/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.parsers
 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
 */

package com.kaaterskil.utilities.parsers{
	import flash.events.*;
	
	import com.kaaterskil.utilities.*;
	import com.kaaterskil.display.factories.*;
	import com.kaaterskil.display.preloaders.*;
	
	/**
	 * VBStory_parser class
	 *
	 * This class parses the xml_stories.php document from the
	 * Voice Box (c) content management system.
	 * 
	 * @package		com.kaaterskil.utilities.parsers
	 * @inheritance	VBStory_parser -> EventDispatcher
	 * @interface	IParser
	 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
	 * @version		080416
	 */
	public class VBStory_parser extends EventDispatcher implements IParser{
		/**
		 * Constants
		 */
		public static const PARSE_COMPLETE:String = 'file_parsed';
		
		/**
		 * Libraries
		 */
		private var _xml:XML;
		
		/**
		 * Tests
		 */
		private var _preload_counter:int;
		private var _preloads:int;
		
		public function VBStory_parser(xml:XML):void{
			_preload_counter	= 0;
			_preloads			= 0;
			_xml				= xml;
		}
		
		//from IParser
		public function parse():Array{
			var stories:Array	= new Array();
			var tags:Array		= ['a', 'b', 'em', 'i', 'li', 'p', 'span', 'u', 'strong'];
			
			for each(var story:XML in _xml.*){
				//get main properties
				var story_id:int		= int(story.contentID);
				var menu_id:int			= int(story.menuID);
				var headline:String		= String(story.headline);
				var body_xml:XMLList	= story.bodyRaw.*;
				
				//build an array of html body elements
				//build an array of body elements
				var body:Array = new Array();
				for each(var child:XML in body_xml.*){
					//test for an acceptable tag
					var tag_name:String = child.name() != null ? child.name() : 'p';
					if(Common.in_array(tag_name, tags)){
						var str:String = child.toString();
						
						//clean up text
						var ptn1:RegExp = /[^\w\n\t\.\-\:, ='"<>@]*/gm;
						var ptn2:RegExp = / {2,}/gm;
						str = Common.str_replace_regexp(str, ptn1, '');
						str = Common.str_replace_regexp(str, ptn2, ' ');
						
						//add to array
						body.push({tag:tag_name, text:str});
					}
				}
				
				//build array of downloads for each story
				var arr1:Array	= new Array();
				var arr2:Array	= new Array();
				for each(var download:XML in story.downloads.*){
					var filepath:String		= String(download.path);
					var filename:String		= String(download.title);
					var title:String		= String(download.description);
					var type_id:int			= int(download.typeID);
					var position:int		= int(download.position);
					var gallery_type:int	= int(download.gallery);
					var mimetype:String		= String(download.mimeType);
					
					var obj:Object = {
						filepath:		filepath, 
						filename:		filename, 
						description:	title, 
						type:			type_id, 
						position:		position, 
						gallery_type:	gallery_type, 
						mimetype:		mimetype, 
						instance:		null
					};
									  
					//create download instance
					var preloader:IPreloader = new VBPreloader();
					var instance:IDisplay = preloader.process(obj)
					
					//increment preloader if download is an image
					//and set a listener for it when it loads
					var ptn:RegExp = /image/;
					if(obj.mimetype.match(ptn) != null){
						_preloads++;
						ADisplay(instance).addEventListener(Event.INIT, preload_test);
					}
					
					//add instance to download array if not a gallery
					if(gallery_type == 0){
						obj.instance = instance;
					}
					
					//add to downloads
					arr1.push(obj);
					
					//build gallery array
					if(gallery_type > 0){
						//add download instance to gallery
						obj.instance = instance;
						
						var test:Boolean = false;
						for(var i:int = 0; i < arr2.length; i++){
							if(obj.position == arr2[i].position){
								arr2[i].index.push(obj);
								test = true;
								break;
							}
						}
						if(!test){
							arr2.push({position:	position,
									  gallery_type:	gallery_type,
									  index:		[obj]
									  });
						}
					}
				}
				
				//build an array of comments
				var arr3:Array = new Array();
				for each(var comment:XML in story.comments.*){
					var author:String		= String(comment.author);
					var comment_txt:String	= String(comment.comment_body);
					arr3.push({author:author, comment:comment_txt});
				}
				
				stories.push({story_id:	story_id,
							 menu_id:	menu_id,
							 headline:	headline,
							 body:		body,
							 downloads:	arr1,
							 galleries:	arr2,
							 comments:	arr3
							 });
			}
			dispatchEvent(new Event(VBStory_parser.PARSE_COMPLETE));
			return stories;
		}
		
		/*------------------------------------------------------------
		EVENT METHODS
		------------------------------------------------------------*/
		/**
		 * Test if preload is complete
		 * 
		 * Called by each factory product when loading is complete or 
		 * videos are ready to play. When all preloads are complete, 
		 * an event is called to trigger the Settings singleotn, which 
		 * will relay the event to the main class to draw the first page.
		 */
		private function preload_test(e:Event):void{
			e.target.removeEventListener(Event.INIT, preload_test);
			_preload_counter++;
			
			if(_preload_counter == _preloads){
				dispatchEvent(new Event(Event.INIT));
			}
		}
	}
}