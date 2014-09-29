/**
 * IMenu.as
 *
 * Interface definition
 * @description	This is an interface for a decorated pattern
 *				that renders menu items.
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080420
 * @package		com.kaaterskil.display.menus
 */
 
 package com.kaaterskil.display.menus{
	 import flash.events.IEventDispatcher;
	 import flash.text.*;
	 
	 import com.kaaterskil.utilities.iterators.*;
	 
	 public interface IMenu extends IEventDispatcher{
		 //getters, setters and tests
		 function get menu_id():int;
		 function get parent_id():int;
		 function get_submenus():IIterator;
		 function set submenus(arr:Array):void;
		 function get_format(id:String):TextFormat;
		 function set format(new_id:String):void;
		 function set visibility(pram:Boolean):void;
		 function is_selected():Boolean;
		 function is_submenu():Boolean;
		 
		 //methods
		 function select(is_parent:Boolean = false):void;
		 function deselect():void;
		 function open_submenus():void;
		 function close_submenus():void;
		 function rollover():void;
		 function rollout():void;
	 }
 }