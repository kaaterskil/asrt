/**
 * Menu_handler.as
 *
 * Class definition
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080418
 * @package		com.kaaterskil.display.handlers
 */

package com.kaaterskil.display.handlers{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import com.kaaterskil.utilities.iterators.*;
	import com.kaaterskil.utilities.libraries.*;
	import com.kaaterskil.display.menus.*;
	
	public class Menu_handler extends Sprite implements IMenu_handler{
		/**
		 * Containers
		 */
		private var _container:Sprite;
		
		/**
		 * Libraries
		 */
		private var _index:Library;
		
		/**
		 * Parameters
		 */
		private var _selected_menu:IMenu;
		
		/**
		 * Constructor
		 */
		public function Menu_handler():void{
			this.name	= 'menu_handler';
			create_container();
		}
		
		/*------------------------------------------------------------
		GETTER / SETTERS METHODS
		------------------------------------------------------------*/
		/**
		 * Return the selected menu id
		 */
		public function get menu_id():int{
			return _selected_menu.menu_id;
		}
		
		/**
		 * Returns the first story's top left coordinate. This method 
		 * returns the lower of the selected menu's lowest sibling 
		 * y-value or the selected menu's lowest child y-value.
		 */
		public function get story_coords():Point{
			var parent_id:int		= _selected_menu.parent_id;
			var bounds:Rectangle	= AMenu(_selected_menu).getBounds(_container);
			
			//first compare the Settings singleton's top value with 
			//the bottom of the selected menu
			var y_coord:Number = Math.max(bounds.bottom, Settings.CONTENT_TOP);
			
			//create sibling and child points
			var sibling:Point	= new Point(0, y_coord);
			var child:Point 	= new Point(0, y_coord);
			
			//get greatest sibling y-value
			var iterator:IIterator	= _index.iterator();
			while(iterator.has_next()){
				var menu:AMenu = iterator.next() as AMenu;
				if(menu.parent_id == parent_id){
					bounds		= menu.getBounds(_container);
					sibling.y	= Math.max(sibling.y, bounds.bottom);
				}
			}
			
			//get greatest child y-value
			iterator = _selected_menu.get_submenus();
			while(iterator.has_next()){
				menu	= iterator.next() as AMenu;
				bounds	= menu.getBounds(_container);
				child.y	= Math.max(child.y, bounds.bottom);
			}
			
			return new Point(0, Math.max(sibling.y, child.y));
		}
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Renders menu to screen
		 */
		public function render():void{
			var iterator:IIterator = Settings.get_instance().get_menus();
			var start_point:Point	= new Point();
			
			_index = new Library();
			_index.add_array(draw_menus(iterator, start_point));
		}
		
		/**
		 * Removes the menus from the display list
		 */
		public function remove():void{
			while(_container.numChildren > 0){
				var menu:IMenu = _container.getChildAt(0) as IMenu;
				remove_listeners(menu);
				_container.removeChildAt(0);
			}
		}
		
		/*------------------------------------------------------------
		DRAWING METHODS
		------------------------------------------------------------*/
		/**
		 * Draws menus.
		 * @param iterator		The iterator instance of a menu or 
		 *						submenu library object.
		 * @param start_point	A point object with the starting 
		 *						coordinates of the first menu item in 
		 *						the library.
		 * @return arr			An array of IMenu object references.
		 */
		private function draw_menus(iterator:IIterator, start_point:Point):Array{
			var point:Point	= start_point;
			
			var arr:Array = [];
			while(iterator.has_next()){
				//get parameters
				var prams:Object = iterator.next();
				
				//instantiate a menu_item object
				var item:Basic_menu = new Basic_menu(prams);
				add_listeners(item);
				_container.addChild(item);
				
				//adjust position if necessary
				var bounds:Rectangle = item.getBounds(this);
				if(point.x + bounds.width > Settings.CONTENT_RIGHT){
					point = new Point(start_point.x, bounds.bottom);
				}
				item.x = point.x;
				item.y = point.y;
				bounds = item.getBounds(this);
				
				//test for submenus - runs this method recursively
				if(prams.submenus != null){
					var sub_library:Library = new Library();
					sub_library.add_array(prams.submenus);
					
					var sub_point:Point = new Point(0, bounds.bottom);
					item.submenus = draw_menus(sub_library.iterator(), sub_point);
				}
				
				//add main menu item to index
				arr.push(item);
				
				//increment
				point.x += (bounds.width + Settings.MENU_SEPARATOR);
			}
			return arr;
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Create container
		 */
		private function create_container():void{
			_container		= new Sprite();
			_container.name	= 'menu_handler_container';
			addChild(_container);
		}
		
		/**
		 * Sets the menu bar.
		 */
		private function set_menu(menu:IMenu):void{
			var menu_id:int		= menu.menu_id;
			var parent_id:int	= menu.parent_id;
			
			if(parent_id == 0){
				remove();
				render();
			}
			select_menu_item(menu_id, parent_id, _index.iterator());
		}
		
		/**
		 * Selects a menu item. Runs recursively to open submenus and
		 * highl;ight the selected manu and its parent.
		 */
		private function select_menu_item(menu_id:int, parent_id:int, iterator:IIterator):void{
			while(iterator.has_next()){
				var menu:IMenu = iterator.next() as IMenu;
				if(menu.menu_id == menu_id){
					menu.select();
				}else if(menu.menu_id == parent_id){
					menu.select(true);
				}else{
					menu.deselect();
				}
				
				//test submenus
				var submenus:IIterator = menu.get_submenus();
				if(submenus.has_next() > 0){
					select_menu_item(menu_id, parent_id, submenus);
				}
			}
		}
		
		/*------------------------------------------------------------
		EVENT METHODS
		------------------------------------------------------------*/
		/**
		 * Add event listeners to menu item
		 */
		private function add_listeners(target:IMenu):void{
			target.addEventListener(MouseEvent.ROLL_OVER,	rollover_handler);
			target.addEventListener(MouseEvent.ROLL_OUT, 	rollout_handler);
			target.addEventListener(MouseEvent.CLICK, 		click_handler);
		}
		
		/**
		 * Remove event listeners from menu item
		 */
		private function remove_listeners(target:IMenu):void{
			target.removeEventListener(MouseEvent.ROLL_OVER,	rollover_handler);
			target.removeEventListener(MouseEvent.ROLL_OUT, 	rollout_handler);
			target.removeEventListener(MouseEvent.CLICK, 		click_handler);
		}
		
		/**
		 * On rollover handler
		 */
		private function rollover_handler(e:MouseEvent):void{
			e.target.rollover();
		}
		
		/**
		 * On rollout handler
		 */
		private function rollout_handler(e:MouseEvent):void{
			e.target.rollout();
		}
		
		/**
		 * Mouse cick handler
		 */
		private function click_handler(e:MouseEvent):void{
			var menu:IMenu	= e.currentTarget as IMenu;
			_selected_menu	= menu;
			set_menu(menu);
		}
	}
}