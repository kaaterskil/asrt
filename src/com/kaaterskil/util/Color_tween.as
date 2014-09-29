/**
 * Color_tween
 *
 * Class definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080215
 * @package com.kaaterskil.utilities
 */
 
package com.kaaterskil.utilities{
	import fl.transitions.easing.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.utils.Timer;
	
	public class Color_tween extends EventDispatcher{
		/**
		 * Containers
		 */
		private var _timer:Timer;
		private var _target:Object;
		
		/**
		 * Parameters
		 */
		private var _properties:Object;
		private var _duration:int;
		
		/**
		 * Trackers
		 */
		private var _counter:int
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Color_tween(obj:Object, props:Object; delay:int = 80, dur:int = 1000):void{
			_target		= obj;
			_duration	= dur;
			
			set_params(props);
			start_tween(delay, Math.ceil(dur / delay));
		}
		
		/**
		 * Start the tween
		 */
		private function start_tween(delay, repeat:int = 0):void{
			if(_target != null){
				_timer = new Timer(delay, repeat);
				_timer.addEventListener(TimerEvent.TIMER, update_tween);
				_timer.start();
			}else{
				trace('Null target');
			}
		}
		
		/**
		 * Stop the tween
		 */
		public function stop_tween():void{
			_timer.removeEventListener(TimerEvent.TIMER, update_tween);
			_timer.stop();
		}
		
		/**
		 * Update the tween object properties
		 */
		public function update_tween(e.TimerEvent):void{
			_counter++;
			if(counter < _duration){
				apply_tween(counter, duration);
			}else{
				apply_tween(1, 1);
				stop_tween();
			}
			e.updateAfterEvent();
		}
		
		/*------------------------------------------------------------
		UTILITY METHODS
		------------------------------------------------------------*/
		/**
		 * Set parameters.
		 * @param obj	An object with various properties. The first 
		 *				specifies start and end values along with the
		 *				easing function name. The second specifies only
		 *				the final value and the easing function name,
		 *				assuming that the target property already has a
		 *				specified starting value. The third specifies a
		 *				delta value and an easing function name, assuming
		 *				that the target property already has a specified
		 *				starting value and that the timer fires indefinitely.
		 *				obj = {x:{from:200, to:300, easing:func}} or
		 *				obj = {x:{to:300, easing:func}} or
		 *				obj = {x:{by:300, easing:func}}
		 */
		private function set_params(obj:Object):void{
			for(var e:String in obj){
				var prop:Object = obj[e];
				if(prop.easing == null){
					obj[e] = None.easeNone;
				}
				if(prop.from == null){
					obj[e].from = _target[e];
				}
				if(prop.by != null){
					obj[e].to = obj[e].from + obj[e].by;
				}
			}
			_properties = obj;
		}
		
		/**
		 * Set property values.
		 */
		private function apply_tween(counter:int, duration:int):void{
			for(var e:String in _properties){
				var prop = _properties[e];
				_target[e] = prop.easing(counter, prop.from, (prop.to - prop.from), duration);
			}
		}
	}
}