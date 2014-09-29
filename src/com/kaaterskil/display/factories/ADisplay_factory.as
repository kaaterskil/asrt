/**
 * ADisplay_factory.as
 *
 * Class definition
 * @description	The abstract creator class of a parameterized 
 *				factory method. The class expects an array of 
 *				objects passed to the factory method as the 
 *				parameters. To encapsulate the parameters, the
 *				object properties should be in the format:
 *				{type:int, concreteClassName:string}
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080417
 * @package		com.kaaterskil.display.factories
 */
 
package com.kaaterskil.display.factories{
	import flash.display.*;
	import flash.errors.*;
	
	public class ADisplay_factory{
		public var _instance:IDisplay;
		
		/**
		 * Initialization
		 */
		public function init(prams:Object, container:DisplayObjectContainer, type:int):void{
			_instance = this.create(type);
			_instance.init(prams, container);
		}
		
		/**
		 * Instantiate the product
		 */
		protected function create(type:int):IDisplay{
			throw new IllegalOperationError('Abstract method create() must be overridden in a subclass.');
			return null;
		}
	}
}