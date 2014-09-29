/**
 * Basic_menu.as
 *
 * Class definition
 * @description	A concreate decorated class.
 * @inheritance	Basic_menu -> AMenu -> Sprite
 * @interface	IMenu -> IEventDispatcher
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080420
 * @package		cpm.kaaterskil.display.menus
 */

package com.kaaterskil.display.menus{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import com.kaaterskil.display.factories.*;
	import com.kaaterskil.utilities.*;
	import com.kaaterskil.utilities.iterators.*;
	import com.kaaterskil.utilities.libraries.*;
	
	public class Basic_menu extends AMenu{
		/**
		 * Constants
		 */
		private static const FORMAT_SELECTED	:String = 'menu_format_selected';
		private static const FORMAT_ROLLOUT		:String = 'menu_format_rollout';
		private static const FORMAT_ROLLOVER	:String = 'menu_format_rollover';
		
		/**
		 * Containers
		 */
		private var _container:Text_product;
		
		/**
		 * Parameters
		 */
		private var _menu_id:int;
		private var _parent_id:int;
		private var _submenus:Library;
		private var _text:String;
		
		/**
		 * Flags
		 */
		private var _is_submenu:Boolean;
		private var _is_selected:Boolean;
		
		/**
		 * Constructor
		 */
		public function Basic_menu(prams:Object):void{
			_submenus		= new Library();
			_menu_id		= prams.id;
			_parent_id		= prams.parent_id;
			_text			= prams.text;
			_is_submenu		= prams.parent_id > 0 ? true : false;
			_is_selected	= false;
			
			this.name		= 'menu_' + String(prams.id);
			this.visible	= _is_submenu ? false : true;
			
			if(_text != ''){
				draw_text();
			}
		}
		
		/*------------------------------------------------------------
		GETTER / SETTER METHODS
		------------------------------------------------------------*/
		/**
		 * Returns the menu id
		 */
		override public function get menu_id():int{
			return _menu_id;
		}
		
		/**
		 * Returns the menu's parent id
		 */
		override public function get parent_id():int{
			return _parent_id;
		}
		
		/**
		 * Returns the submenu index
		 */
		override public function get_submenus():IIterator{
			return _submenus.iterator();
		}
		override public function set submenus(arr:Array):void{
			_submenus = new Library();
			_submenus.add_array(arr);
		}
		
		/**
		 * Returns the selected textFormat from the Settings singleton.
		 */
		override public function get_format(id:String):TextFormat{
			return find_format(id);
		}
		override public function set format(new_id:String):void{
			var format:TextFormat = find_format(new_id);
			if(_container != null){
				var len:int = _container.get_field_property('length');
				_container.reset_format(format, 0, len);
			}
		}
		
		/**
		 * Sets visibility
		 */
		override public function set visibility(pram:Boolean):void{
			this.visible = pram;
		}
		
		/**
		 * Returns the _is_selected flag
		 */
		override public function is_selected():Boolean{
			return _is_selected;
		}
		
		/**
		 * Returns the _is_submenu flag
		 */
		override public function is_submenu():Boolean{
			return _is_submenu;
		}
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Selects the menu
		 */
		override public function select(is_parent:Boolean = false):void{
			if(is_parent){
				this.format = Basic_menu.FORMAT_SELECTED;
				open_submenus();
				_is_selected = false;
			}else if(!_is_selected){
				this.format = Basic_menu.FORMAT_SELECTED;
				open_submenus();
				_is_selected = true;
			}
		}
		
		/**
		 * Deselects the menu
		 */
		override public function deselect():void{
			this.format = Basic_menu.FORMAT_ROLLOUT;
			close_submenus();
			_is_selected = false;
		}
		
		/**
		 * Opens the submenu
		 */
		override public function open_submenus():void{
			if(_submenus.get_size() > 0){
				var iterator:IIterator = _submenus.iterator();
				while(iterator.has_next()){
					var submenu:AMenu = iterator.next() as AMenu;
					submenu.visible = true;
				}
			}
		}
		
		/**
		 * Closes the submenu
		 */
		override public function close_submenus():void{
			if(_submenus.get_size() > 0){
				var iterator:IIterator = _submenus.iterator();
				while(iterator.has_next()){
					var submenu:AMenu = iterator.next() as AMenu;
					submenu.visible = false;
				}
			}
		}
		
		/**
		 * On rollover. This method is called by the Menu_handler 
		 * event handler.
		 */
		override public function rollover():void{
			if(!_is_selected){
				this.format = Basic_menu.FORMAT_ROLLOVER;
			}
		}
		
		/**
		 * On rollout. This method is called by the Menu_handler 
		 * event handler.
		 */
		override public function rollout():void{
			if(!_is_selected){
				this.format = Basic_menu.FORMAT_ROLLOUT;
			}
		}
		
		/*------------------------------------------------------------
		DRAWING METHODS
		------------------------------------------------------------*/
		/**
		 * Sets the menu text
		 */
		private function draw_text():void{
			//build parameters
			var props:Object = {AntiAliasType:	AntiAliasType.ADVANCED,
								autoSize:		TextFieldAutoSize.LEFT,
								embedFonts:		true,
								text:			_text,
								selectable:		false
								};
			var format:TextFormat = find_format(Basic_menu.FORMAT_ROLLOUT);
			var obj:Object = {name:		'menu_text',
							  prams:	{props:props, format:format}
							  };
							  
			//create text field
			var factory:Display_factory = new Display_factory();
			factory.init(obj, this, Display_factory.TEXT_FIELD);
			_container = factory._instance as Text_product;
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Returns the selected textFormat from the Settings singleton.
		 */
		private function find_format(id:String):TextFormat{
			var iterator:IIterator = Settings.get_instance().get_formats();
			while(iterator.has_next()){
				var obj:Object = iterator.next();
				if(obj.name == id){
					return obj.format;
				}
			}
			var msg:String = 'No text format found for ' + id;
			throw new Error(msg);
		}
	}
}