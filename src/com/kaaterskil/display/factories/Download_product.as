/**
 * Download_product.as
 *
 * Class definition
 * @description	A factory method product.
 * @inheritance	Download_product -> ADisplay -> Sprite
 * @interface	IDisplay
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080423
 * @package		com.kaaterskil.display.factories
 */

package com.kaaterskil.display.factories{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	
	import com.kaaterskil.utilities.loaders.*;
	
	public class Download_product extends ADisplay{
		/**
		 * Containers
		 */
		private var _container:Sprite;
		private var _icon:Image_loader;
		private var _link:Text_product;
		
		/**
		 * Parameters
		 */
		private var _href:String;
		private var _format:TextFormat;
		private var _text:String
		
		/**
		 * Constructor
		 */
		public function Download_product():void{}
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Initialization
		 */
		override public function init(prams:Object, container:DisplayObjectContainer = null):void{
			this.name	= 'download_file_' + prams.filename;
			_href		= prams.src;
			_format		= prams.format;
			_text		= prams.filename;
			
			draw_icon();
		}
		
		override public function set_position(point:Point):void{
			this.x = point.x;
			this.y = point.y
		}
		
		/*------------------------------------------------------------
		DRAWING METHODS
		------------------------------------------------------------*/
		/**
		 * Draw icon
		 */
		private function draw_icon():void{
			var src:String = Settings.get_host() + get_icon_filename();
			
			_icon = new Image_loader();
			_icon.addEventListener(Image_loader.INIT_EVENT, draw_link);
			_icon.process_load(src);
			addChild(_icon);
		}
		
		/**
		 * Draw link text
		 */
		private function draw_link(e:Event):void{
			//set link format with new data
			_format.url			= _href;
			_format.target		= '_blank';
			
			 var obj:Object = new Object();
			 obj.x		= _icon.x + _icon.width + 2;
			 obj.y		= 0;
			 obj.name	= 'link';
			 obj.prams = new Object();
			 obj.prams.props = {antiAliasType:		AntiAliasType.ADVANCED,
							    autoSize:			TextFieldAutoSize.LEFT,
								background:			true,
								embedFonts:			true,
								multiline:			false,
								selectable:			false,
								htmlText:			_text,
								wordWrap:			false
								};
			obj.prams.format = _format;
			
			var factory:Display_factory = new Display_factory();
			factory.init(obj, this, Display_factory.TEXT_FIELD);
			
			_link = factory._instance as Text_product;
			addChild(_link);
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Get icon file path
		 */
		private function get_icon_filename():String{
			var r:String = '';
			
			var ext:String = _href.substr(_href.length - 3, 3);
			switch(ext.toLowerCase()){
				case 'doc':
					r = 'images/icondoc.gif';
					break;
				case 'xls':
					r = 'images/iconxls.gif';
					break;
				case 'pdf':
					r = 'images/iconpdf.gif'
					break;
			}
			return r;
		}
	}
}