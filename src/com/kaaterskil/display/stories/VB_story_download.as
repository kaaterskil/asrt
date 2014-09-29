/**
 * VB_story_download.as
 *
 * Class definition
 * @description A decorator class.
 * @inheritance	VB_story_download -> AStory_decorator -> AStory -> Sprite
 * @interface	IStory
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080423
 * @package		com.kaaterskil.display.stories
 */

package com.kaaterskil.display.stories{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	
	import com.kaaterskil.display.factories.*;
	import com.kaaterskil.display.image_galleries.*;
	import com.kaaterskil.display.movies.*;
	import com.kaaterskil.utilities.*;
	
	public class VB_story_download extends AStory_decorator{
		/**
		 * Libraries
		 */
		private var _download_index:Array;
		private var _gallery_index:Array;
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function VB_story_download(story:IStory):void{
			super(story);
			process_downloads();
		}
		
		/**
		 * Process images, movies and download links
		 */
		public function process_downloads():void{
			//for downloads
			var prams:Object = get_prams();
			var container:DisplayObjectContainer = get_container();
			for each(var item:Object in prams.downloads){
				switch(item.type){
					case Settings.FILETYPE_DOCUMENT:
						var file:ADisplay = item.instance;
						_download_index.push(file)
						container.addChild(file);
						set_download_positions();
						break;
						
					case Settings.FILETYPE_IMAGE:
						if(item.gallery == 0){
							var image:AContent_display = item.instance;
							container.addChild(image);
							set_position(image);
						}
						break;
						
					case Settings.FILETYPE_MOVIE:
						var movie:AContent_display = item.instance;
						set_position(movie);
						container.addChild(movie);
						container.parent.addEventListener(Event.REMOVED_FROM_STAGE, 
														  (movie as AVideo_player).stop_video);
						(movie as AVideo_player).play_video();
						break;
				}
			}
			
			//for image galleries
			for each(item in prams.galleries){
				var gallery:AImage_gallery = new Basic_image_gallery();
				gallery.init(item, container);
				set_position(gallery as AContent_display);
				
				//use decorator versions for functionality
				switch(item.gallery_type){
					case Settings.GALLERY_IS_SWAP:
						gallery = new Image_gallery_swapper(gallery);
						container.parent.addEventListener(Event.REMOVED_FROM_STAGE, gallery.stop_timer);
						break;
						
					case Settings.GALLERY_IS_GRID:
						gallery = new Image_gallery_grid(gallery);
						gallery.x = 0;
						gallery.y = 0;
						break;
						
					case Settings.GALLERY_IS_CRAWL:
						break;
				}
				
			}
			
			//now that the items are in place, let's adjust the story
			//geometry so the text flows around them.
			reflow_story_text();
		}
		
		/*------------------------------------------------------------
		TEXT REFLOW METHODS
		------------------------------------------------------------*/
		/**
		 * Redraws text in new text flields to flow around images
		 */
		private function reflow_story_text():void{
			//Create an array of image and video coordinates and dimensions
			var images:Array = get_image_bounds();
			if(images.length > 0){
				//Build an array of text block surrounding the items
				var blocks:Array = get_text_blocks(images);
				
				//remove existing body text
				if(blocks.length > 0){
					remove_body_text();
				}
				
				//create new text
				var test:Boolean = reflow_text(blocks);
				
				//adjust download positions
				if(test){
					set_download_positions();
				}
			}
		}
		
		/**
		 * Builds an array of image dimensions around which text must flow.
		 */
		private function get_image_bounds():Array{
			var container:DisplayObjectContainer = get_container();
			
			var arr:Array = new Array();
			for(var i:int = 0; i < container.numChildren; i++){
				var child:* = container.getChildAt(i);
				if(child is IContent_display){
					var bounds:Rectangle = child.getBounds(container);
					arr.push({position:child.get_layout(), 
							  dims:bounds, top:bounds.top, bottom:bounds.bottom});
				}
			}
			if(arr.length > 0){
				arr.sortOn(['top', 'bottom'], [Array.NUMERIC, Array.NUMERIC]);
			}
			return arr;
		}
		
		/**
		 * Builds an array of text blocks that describe the text flow.
		 */
		private function get_text_blocks(images:Array):Array{
			var container:DisplayObjectContainer = get_container();
			var point:Point			= new Point();
			var full_width:Number	= Settings.CONTENT_WIDTH;
			var full_height:Number	= Settings.CONTENT_HEIGHT;
			
			//get starting point, i.e. bottom of headline
			var body_pt:Point = new Point();
			for(var i:int = 0; i < container.numChildren; i++){
				var c:* = container.getChildAt(i);
				if(c.name.toLowerCase().indexOf('headline') != -1){
					body_pt = c.getBounds(container).topLeft;
					body_pt.y += c.height + Settings.HEADLINE_MARGIN;
					break;
				}
			}
			
			var arr:Array = new Array();
			for(i = 0; i < images.length; i++){
				var image:Object = images[i];
				//1. initialize variables
				var bounds:Rectangle = new Rectangle();
				var type:String		= 'F';
				var dims:Rectangle	= new Rectangle(point.x, 
													point.y > 0 ? point.y : image.dims.y > 0 ? image.dims.y : 0, 
													full_width, 
													image.dims.height);
				//2. get basic text metrics
				var metrics:TextLineMetrics;
				for(var j:int = 0; j < container.numChildren; j++){
					c = container.getChildAt(j);
					if(c.name.toLowerCase().indexOf('body_text') != -1){
						metrics = c.get_line_metrics(0);
						bounds	= c.getBounds(container);
						break;
						
					}
				}
				
				//3. add a text block if text begins above first image
				if(i == 0){
					var h:Number = dims.top - Settings.IMAGE_MARGIN - body_pt.y;
					if(h > 0){
						arr.push({dims:new Rectangle(dims.left, 
													 bounds.top, 
													 full_width,
													 h), 
								 type:'F'
								 });
					}
				}
				
				//4. adjust the block for image margins
				dims.bottom += Settings.IMAGE_MARGIN;
				if(image.position > 2){
					dims.top -= Settings.IMAGE_MARGIN;
				}
				if(image.position == 0 || image.position == 3 || image.position == 6){
					//for left margins
					dims.left = image.dims.right + Settings.IMAGE_MARGIN;
					type = 'R';
				}else{
					dims.right = image.dims.left - Settings.IMAGE_MARGIN;
					type = 'L';
				}
			
				//5. test for second column, i.e. if image is centered
				var has_2nd_col:Boolean = false;
				if(image.position == 1 || image.position == 4 || image.position == 7){
					has_2nd_col			= true;
					type				= '2' + type;
					var left2:Number	= image.dims.right + Settings.IMAGE_MARGIN;
					var width2:Number	= full_width - left2;
				}
				
				//6. add text block(s)
				arr.push({dims:dims, type:type});
				if(has_2nd_col){
					arr.push({dims:new Rectangle(left2, 
												 dims.top, 
												 width2, 
												 dims.height), 
							 type:'2R'
							 });
				}
				point.y += dims.height;
				
				//7. test what's below
				if(i + 1 < images.length){
					var next_image:Object = images[i + 1];
					
					//get the top of the next image
					point.y = next_image.dims.top;
					if(next_image.position > 2){
						point.y -= Settings.IMAGE_MARGIN;
					}
					
					//if the next image begins below the current image
					if(point.y > dims.bottom){
						//add a full width text block between images
						arr.push({dims:new Rectangle(point.x, 
													 dims.bottom, 
													 full_width, 
													 (point.y - dims.bottom)), 
								 type:'F'
								 });
					
					//if the top of the next image is higher than the 
					//bottom of the current image
					}else if(point.y < dims.bottom){
						//shorten up the current block height
						if(has_2nd_col && next_image.dims.left == 0){
							//adjust left column
							arr[arr.length - 2].dims.height = point.y - dims.top;
						}else{
							//adjust right column
							arr[arr.length - 1].dims.height = point.y - dims.top;
						}
						
						//add truncated line if height will permit it
						h = (image.dims.bottom + Settings.IMAGE_MARGIN) - 
							(next_image.dims.top - Settings.IMAGE_MARGIN);
						if(h >= metrics.height){
							if(image.position != 0 && image.position != 3 && image.position != 6){
								//if current image is centered or on the right
								var x:Number = next_image.dims.right + Settings.IMAGE_MARGIN
								var w:Number = (image.dims.left - Settings.IMAGE_MARGIN) - x;
								type = 'LT';
							}else{
								x = image.dims.right + Settings.IMAGE_MARGIN
								w = (next_image.dims.left - Settings.IMAGE_MARGIN) - x;
								type = 'RT';
							}
							type = has_2nd_col ? '2' + type : type;
							arr.push({dims:new Rectangle(x, 
														 next_image.dims.top - Settings.IMAGE_MARGIN, 
														 h, 
														 w), 
									 type:type
									 });
						}
					}
				}else if(full_height > dims.bottom){
					//add full-width text block at bottom if there is room
					h = full_height - dims.bottom;
					if(h >= metrics.height){
						arr.push({dims:new Rectangle(0, 
													 dims.bottom, 
													 full_width, 
													 h), 
								 type:'F'
								 });
					}
				}
				
				//set next top left
				point = new Point(0, arr[arr.length - 1].bottom);
			}
			return arr;
		}
		
		/**
		 * Removes existing body text fields
		 */
		private function remove_body_text():void{
			//remove from display list
			var container:DisplayObjectContainer = get_container();
			for(var i:int = container.numChildren - 1; i >= 0; i--){
				var c:* = container.getChildAt(i);
				if(c.name.toLowerCase().indexOf('body_text') != -1){
					container.removeChildAt(i);
				}
			}
			//remove from tracker
			for(i = index_length() - 1; i >= 0; i--){
				var e:* = read_index(i);
				if(e.name.indexOf('body_text') != -1){
					splice_index(i - 1, 1);
				}
			}
		}
		
		/**
		 * Build new text blocks.
		 * @param blocks	An array of text blocks within which the
		 * 					text should flow.
		 */
		private function reflow_text(blocks:Array):Boolean{
			var container:DisplayObjectContainer = get_container();
			var point:Point 	= new Point();
			var ptn:RegExp		= /[\s\n\r]/;
			var prior_chars:int	= 0;
			var start_char:int	= 0;
			var end_char:int	= 0;
			
			for(var i:int = 0; i < blocks.length; i++){
				var block:Object = blocks[i];
				
				//draw new text field.
				//places all the body text in the field 
				draw_body(block.dims.width);
				
				//update field with attributes
				var fld = read_index();
				fld.name	= 'body_text_' + i;
				fld.x		= block.dims.left;
				fld.y		= point.y == 0 ? block.dims.top : point.y;
				
				//remove text before desired starting line
				if(prior_chars > 0){
					end_char += prior_chars;
					fld.replace_text(0, end_char, '');
				}
				
				//set last visible line
				//adjust bottom for the text block's actual y coordinate
				var metrics:TextLineMetrics	= fld.get_line_metrics(0);
				var lines:int				= fld.get_field_property('numLines');
				var height_test:Number		= (block.dims.top + block.dims.height) - fld.y;
				var start_line:int			= Math.round(height_test / metrics.height);
				
				//remove text after the computed ending line
				if(start_line < lines){
					//test if line starts with a newline, CR or whitespace
					start_char = fld.get_line_offset(start_line);
					if(fld.get_field_property('text').charAt(start_char).match(ptn) != null){
						start_line--;
						start_char = fld.get_line_offset(start_line);
					}
					fld.replace_text(start_char, fld.get_field_property('length'), '');
					
					//set the number of stripped characters to add to 
					//the beginning of the next text block
					prior_chars = start_char - 1;
					
					//make sure the next text block doesn't start on
					//a newline, CR or whitespace
					while(fld.get_field_property('text').charAt(prior_chars).match(ptn)){
						prior_chars++;
					}
				}else{
					prior_chars = fld.get_field_property('length');
				}
				
				//set next text field's y coordinate
				point.y = fld.y + fld.height;
				point.y += block.type.indexOf('T') == -1 ? 0 : 4;	//adjust visually
				if(block.type == '2R'){
					//set y coord for left column
					for(var j:int = i; j >= 0; j--){
						if(blocks[j].type == '2L' && (j - 1 >= 0 && blocks[j - 1].type != '2L')){
							for(var k:int = 0; k < container.numChildren; k++){
								var child:* = container.getChildAt(k);
								if(child.name == 'body_text_' + j){
									point.y = child.y;
								}
							}
							break;
						}
					}//end for
				}
			}//end for
			return true;
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Adjust downloaded item positions. This method will position
		 * all downloads below the last text field and bring them to
		 * the top of the display list so that any links are clickable.
		 */
		private function set_download_positions():void{
			var point:Point = new Point();
			
			//get the coordinates of the last text field
			for(var i:int = index_length() - 1; i >= 0; i--){
				var fld:* = read_index(i);
				if(fld.get_property('length') > 1){
					point.x = fld.x;
					point.y = fld.y + fld.height + 4;
					break;
				}
			}
			
			//get the last download position
			for each(var download:Download_product in _download_index){
				download.x = point.x;
				download.y = point.y;
				
				//increment y coordinate
				point.y += download.height + 4;
			}
			
			//bring downloads to the front of the display
			var container:DisplayObjectContainer = get_container();
			for(i = 0; i < container.numChildren; i++){
				var child:* = container.getChildAt(i);
				if(child is Download_product){
					container.swapChildrenAt(i, container.numChildren - 1);
				}
			}
		}
		
		/**
		 * Sets an item's position. The item can be either an image or
		 * a movie.
		 */
		private function set_position(img:AContent_display):void{
			//initialize geometry
			var point:Point	= new Point();
			var w:Number	= Settings.CONTENT_WIDTH;
			var h:Number	= Settings.CONTENT_HEIGHT;
			
			//get bottom of headline
			var container:DisplayObjectContainer = get_container();
			for(var i:int = 0; i < container.numChildren; i++){
				var child:* = container.getChildAt(i);
				if(child.name.toLowerCase().indexOf('headline') != -1){
					point.y = child.y + child.height + Settings.HEADLINE_MARGIN;
					break;
				}
			}
			
			//get last text field
			var text_fld:* = read_index();
			
			switch(img.get_layout()){
				case 0:
					//top left
					break;
				case 1:
					//top center
					point.x += (w - img.width) / 2;
					break;
				case 2:
					//top right
					point.x += w - img.width;
					break;
				case 3:
					//center left
					point.y += (h - img.height) / 2;
					break;
				case 4:
					//center center
					point.x += (w - img.width) / 2;
					point.y += (h - img.height) / 2;
					break;
				case 5:
					//center right
					point.x += w - img.width;
					point.y += (h - img.height) / 2;
					break;
				case 6:
					//bottom left
					point.y = text_fld.y + text_fld.height + 2;
					break;
				case 7:
					//bottom center
					point.x = (w - img.width) / 2;
					point.y = text_fld.y + text_fld.height + 2;
					break;
				case 8:
					//bottom right
					point.x = w - img.width;
					point.y = text_fld.y + text_fld.height + 2;
					break;
			}
			img.set_position(point);
		}//end function
	}
}