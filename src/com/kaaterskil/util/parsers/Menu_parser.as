/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.parsers
 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
 */

package com.kaaterskil.utilities.parsers{
	import flash.events.*;
	
	/**
	 * Menu_parser class
	 *
	 * This class parses the xml_menus.php document from the
	 * Voice Box (c) content management system.
	 * 
	 * @package		com.kaaterskil.utilities.parsers
	 * @inheritance	Menu_parser -> EventDispatcher
	 * @interface	IParser
	 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
	 * @version		080416
	 */
	public class Menu_parser extends EventDispatcher implements IParser{
		public static const PARSE_COMPLETE:String = 'file_parsed';
		private var _xml:XML;
		
		public function Menu_parser(xml:XML):void{
			_xml = xml;
		}
		
		public function parse():Array{
			return parse_xml(_xml);
		}
		
		private function parse_xml(xml:XML, parent_id:int = 0):Array{
			var arr:Array = new Array();
			for each(var menu:XML in xml.*){
				arr.push({});
				
				arr[arr.length - 1]['parent_id'] = parent_id;
				
				//get temporary parent id
				var tmp:int = 0;
				for each(var p:XML in menu.*){
					var key:String = p.name().toString().toLowerCase();
					if(key.indexOf('id') != -1){
						tmp = int(p.toString());
						break;
					}
				}
				
				//parse xml
				for each(var prop:XML in menu.*){
					key = prop.name().toString();
					if(prop.hasComplexContent()){
						//trace(prop + ': ' + tmp);
						arr[arr.length - 1][key] = parse_xml(prop, tmp);
					}else{
						arr[arr.length - 1][key] = prop.toString();
					}
				}
			}
			dispatchEvent(new Event(Menu_parser.PARSE_COMPLETE));
			return arr;
		}
	}
}