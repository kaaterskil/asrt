/**
 * Progress_bar.as
 *
 * Class definition
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080524
 * @package		com.kaaterskil.display.preloaders
 */

package com.kaaterskil.display.preloaders{
	import flash.display.*;
	import flash.text.*;
	import com.kaaterskil.display.factories.Text_product;
	
	/**
	 * This class draws a progress bar. The constructor places it on
	 * the stage or any in any other display object container alogn
	 * with two parameters: a width and a TextFormat object. Repeated
	 * calls to the reset_bar() method will update the class with the
	 * new width of the progress line along with any text to display.
	 */
	public class Progress_bar extends Sprite{
		private var _container:Sprite;
		private var _width:Number;
		private var _format:TextFormat;
		
		/**
		 * Constructor.
		 * @param obj	A parameterized object with at least two 
		 *				parameters: a) the width of the containing 
		 *				element, and b) a TextFormat object for the
		 *				progress text.
		 */
		public function Progress_bar(obj:Object):void{
			_width	= obj.width;
			_format	= obj.format;
			draw_container();
			draw_bar(0);
		}
		
		/**
		 * Resets progress bar.
		 * @param pct	The percent of total completion.
		 * @param str	The text to display
		 */
		public function reset_bar(pct:Number, str:String):void{
			remove_child('bar_container');
			draw_bar(pct, str);
		}
		
		/*------------------------------------------------------------
		PRIVATE NETHODS
		------------------------------------------------------------*/
		/**
		 * Draws a master container.
		 */
		private function draw_container():void{
			_container = new Sprite();
			_container.name = 'master_container';
			addChild(_container);
		}
		
		/**
		 * Draws a progress bar.
		 * @param pct	The percent of total completion.
		 * @param str	The text to display (optional)
		 */
		private function draw_bar(pct:Number, str:String = ''):void{
			//remove existing bar
			remove_child('bar_container');
			
			//create container
			var container:Sprite = new Sprite();
			container.name = 'bar_container';
			_container.addChild(container);
			
			//get parameters
			var margin:Number	= 20;
			var x_coord:Number	= margin;
			var w_max:Number	= _width - (margin * 2);
			var w_pct:Number	= Math.round(w_max * pct);
			
			//draw title
			 var obj:Object = new Object();
			 obj.x		= 0;
			 obj.y		= 0;
			 obj.name	= 'bar_text';
			 obj.prams	= new Object();
			 obj.prams.props	= {antiAliasType:	AntiAliasType.ADVANCED, 
			 					   autoSize:		TextFieldAutoSize.LEFT, 
								   embedFonts:		true, 
								   multiline:		true, 
								   text:			str, 
								   visible:			true, 
								   width:			w_max, 
								   wordWrap:		true
								   };
			obj.prams.format	= _format;
			
			var txt:Text_product = new Text_product();
			txt.init(obj);
			container.addChild(txt);
			
			//draw bar
			obj = {x:0, y:txt.y + txt.height};
			var bar:Shape = new Shape();
			bar.name = 'progress_bar';
			bar.graphics.clear();
			bar.graphics.lineStyle(2, 0xff0000, 1);
			bar.graphics.moveTo(obj.x, obj.y);
			bar.graphics.lineTo(obj.x + w_pct, obj.y);
			container.addChild(bar);
			
			//set coordinates
			var h:Number = bar.y + bar.height;
			var y_coord:Number	= (this.height - h) / 2;
			container.x = x_coord;
			container.y = y_coord;
		}
		
		/**
		 * Removes a specified display object from the container.
		 * @params str	The name property of the object to remove
		 */
		private function remove_child(str:String):void{
			for(var i:int = 0; i < _container.numChildren; i++){
				var c:DisplayObject = _container.getChildAt(i);
				if(c.name == str){
					_container.removeChildAt(i);
					break;
				}
			}
		}
	}//end class
}