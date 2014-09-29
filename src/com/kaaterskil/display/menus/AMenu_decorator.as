/**
 * AMenu_decorator.as
 *
 * Class definition
 * @description	An abstract decorator class.
 * @inheritance	AMenu_decorator -> AMenu -> Sprite
 * @interface	IMenu -> IEventDispatcher
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080420
 * @package		com.kaaterskil.display.menus
 */
 
package com.kaaterskil.display.menus{
	import flash.display.*;
	import flash.text.*;
	
	import com.kaaterskil.utilities.iterators.*;
	
	/**
	 * All public methods delegate to the decorated class.
	 */
	public class AMenu_decorator extends AMenu{
		private var _menu:IMenu;
		
		public function AMenu_decorator(menu:IMenu):void{
			_menu = menu;
		}
		
		/*------------------------------------------------------------
		GETTER / SETTERS
		------------------------------------------------------------*/
		override public function get menu_id():int{
			return _menu.menu_id();
		}
		
		override public function get parent_id():int{
			return _menu.parent_id();
		}
		
		override public function get_submenus():IIterator{
			return _menu.get_submenus();
		}
		
		override public function set submenus(arr:Array):void{
			_menus.submenus = arr;
		}
		
		override public function get_format(id:String):TextFormat{
			return _menu.get_format(id);
		}
		
		override public function set format(new_id:String):void{
			_menu.format = new_id;
		}
		
		override public function set visibility(pram:Boolean):void{
			_menu.visibility = pram;
		}
		
		override public function is_selected():Boolean{
			return _menu.is_selected();
		}
		
		override public function is_submenu():Boolean{
			return _menu.is_submenu();
		}
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		override public function select(is_parent:Boolean = false):void{
			_menu.select(is_parent);
		}
		
		override public function deselect():void{
			_menu.deselect();
		}
		
		override public function open_submenus():void{
			_menu.open_submenus()
		}
		
		override public function close_submenus():void{
			_menu.close_submenus();
		}
		
		override public function rollover():void{
			_menu.rollover();
		}
		
		override public function rollout():void{
			_menu.rollout();
		}
	}
}