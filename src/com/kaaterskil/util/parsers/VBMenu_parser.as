/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.parsers
 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
 */

package com.kaaterskil.utilities.parsers{
	import flash.events.*;
	
	/**
	 * VBMenu_parser class
	 *
	 * This class parses the xml_menus.php document from the
	 * Voice Box (c) content management system.
	 * 
	 * @package		com.kaaterskil.utilities.parsers
	 * @inheritance	VBMenu_parser -> EventDispatcher
	 * @interface	IParser
	 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
	 * @version		080416
	 */
	public class VBMenu_parser extends EventDispatcher implements IParser{
		public static const PARSE_COMPLETE:String = 'file_parsed';
		private var _xml:XML;
		
		public function VBMenu_parser(xml:XML):void{
			_xml = xml;
		}
		
		public function parse():Array{
			var menus:Array = new Array();
			
			//loop through each menu
			for each(var menu:XML in _xml.*){
				var menu_id:int			= int(menu.menuID);
				var menu_title:String	= String(menu.menuTitle);
				var submenu_items:*		= menu.menuItems;
				
				//loop through submenus
				var submenus:Array = new Array();
				if(submenu_items is XMLList){
					for each(var submenu:XML in menu.menuItems.*){
						var item_id:int			= int(submenu.itemID);
						var item_title:String	= String(submenu.itemTitle);
						
						submenus.push({id:			item_id,
									  parent_id:	menu_id,
									  text:			item_title,
									  submenus:		null
					}
									  });
				}
				menus.push({id:			menu_id,
						   parent_id:	0,
						   text:		menu_title,
						   submenus:	submenus
						   });
			}
			dispatchEvent(new Event(VBMenu_parser.PARSE_COMPLETE));
			return menus;
		}
	}
}