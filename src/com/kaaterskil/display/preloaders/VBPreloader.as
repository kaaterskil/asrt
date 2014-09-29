/**
 * VBPreloader.as
 *
 * Class definition
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080423
 * @package		com.kaaterskil.display.preloaders
 */

package com.kaaterskil.display.preloaders{
	import flash.display.*;
	import flash.text.*;
	
	import com.kaaterskil.display.factories.*;
	import com.kaaterskil.utilities.iterators.*;
	
	public class VBPreloader implements IPreloader{
		public function VBPreloader():void{}
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Processes a preload request and returns a factory product
		 * depending on the preload mimetype. The load request is pooled
		 * with other requests.
		 */
		public function process(file:Object, container:DisplayObjectContainer = null):IDisplay{
			var urls:Object = {docs:	Settings.get_host() + Settings.DIRECTORY_UPLOAD_DOCS, 
							   images:	Settings.get_host() + Settings.DIRECTORY_UPLOAD_IMAGES, 
							   movies:	Settings.get_host() + Settings.DIRECTORY_UPLOAD_MOVIES
							   };
							   
			var ptn1:RegExp	= /image/;
			var ptn2:RegExp	= /(text|pdf|excel|word|powerpoint|gzip|gtar|rtf|zip)/;
			var ptn3:RegExp = /(application|audio|video)/;
			
			//build product parameters
			if(file.mimetype.match(ptn1)){
				//for images
				var src:String			= urls.images + file.filepath;
				var format:TextFormat	= get_format('image_text');
				var product_type:int	= Display_factory.IMAGE;
				
			}else if(file.mimetype.match(ptn2)){
				//for files
				src				= urls.docs + file.filepath;
				format			= get_format('link_text');
				product_type	= Display_factory.FILE;
				
			}else if(file.mimetype.match(ptn3)){
				//for movies
				src				= urls.movies + file.filepath;
				format			= get_format('link_text');
				product_type	= Display_factory.MOVIE;
			}else{
				return null;
			}
			var prams:Object = {filename:		file.filename,
								description:	file.description,
								src:			src,
								position:		file.position,
								format:			format
								};
			
			//create product
			var factory:Display_factory = new Display_factory();
			factory.init(prams, container, product_type);
			
			//return to parser
			return factory._instance;
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Returns a TextFormat object matching a passed id string
		 */
		private function get_format(id:String):TextFormat{
			var iterator:IIterator = Settings.get_instance().get_formats();
			while(iterator.has_next()){
				var obj:Object = iterator.next();
				if(obj.name == id){
					return obj.format;
					break;
				}
			}
			var msg:String = 'TextFormat not found for id ' + id;
			throw new Error(msg);;
		}
	}
}