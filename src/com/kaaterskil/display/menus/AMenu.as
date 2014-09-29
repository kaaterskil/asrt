/**
 * AMenu.as
 *
 * Class definition
 * @description	This is an abtract decorated class and provides
 *				base functionality to other decorated menu classes.
 * @inheritance	AMenu -> Sprite
 * @interface	IMenu -> IEventDispatcher
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080420
 * @package		com.kaaterskil.display.menus
 */
 
package com.kaaterskil.display.menus{
	import flash.display.*;
	import flash.errors.*;
	import flash.text.*;
	
	import com.kaaterskil.utilities.iterators.*;
	
	public class AMenu extends Sprite implements IMenu{
		public function AMenu():void{}
		
		/*------------------------------------------------------------
		GETTERS
		------------------------------------------------------------*/
		public function get menu_id():int{
			throw new IllegalOperationError('Abstract method get menu_id() must be overridden by a subclass.');
		}
		
		public function get parent_id():int{
			throw new IllegalOperationError('Abstract method get parent_id() must be overridden by a subclass.');
		}
		
		public function get_submenus():IIterator{
			throw new IllegalOperationError('Abstract method get submenus() must be overridden by a subclass.');
		}
		
		public function set submenus(arr:Array):void{
			throw new IllegalOperationError('Abstract method set submenus() must be overridden by a subclass.');
		}
		
		public function get_format(id:String):TextFormat{
			throw new IllegalOperationError('Abstract method get format() must be overridden by a subclass.');
		}
		
		public function set format(new_id:String):void{
			throw new IllegalOperationError('Abstract method set format() must be overridden by a subclass.');
		}
		
		public function set visibility(pram:Boolean):void{
			throw new IllegalOperationError('Abstract method set visibility() must be overridden by a subclass.');
		}
		
		public function is_selected():Boolean{
			throw new IllegalOperationError('Abstract method get is_selected() must be overridden by a subclass.');
		}
		
		public function is_submenu():Boolean{
			throw new IllegalOperationError('Abstract method get is_submenu() must be overridden by a subclass.');
		}
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		public function select(is_parent:Boolean = false):void{
			throw new IllegalOperationError('Abstract method select() must be overridden by a subclass.');
		}
		
		public function deselect():void{
			throw new IllegalOperationError('Abstract method deselect() must be overridden by a subclass.');
		}
		
		public function open_submenus():void{
			throw new IllegalOperationError('Abstract method open_submenus() must be overridden by a subclass.');
		}
		
		public function close_submenus():void{
			throw new IllegalOperationError('Abstract method close_submenus() must be overridden by a subclass.');
		}
		
		public function rollover():void{
			throw new IllegalOperationError('Abstract method rollover() must be overridden by a subclass.');
		}
		
		public function rollout():void{
			throw new IllegalOperationError('Abstract method rollout() must be overridden by a subclass.');
		}
	}
}