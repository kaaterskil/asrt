/**
 * Object_tween
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
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class Object_tween extends EventDispatcher{
		/**
		 * Containers
		 */
		private var _timer:Timer;
		private var _target:Object;
		
		/**
		 * Parameters
		 */
		private var _properties:Object;
		public var _duration:int;
		public var _repeat:int;
		
		/**
		 * Trackers
		 */
		public var _counter:int
		
		/*------------------------------------------------------------
		CONTROL METHODS
		------------------------------------------------------------*/
		/**
		 * Constructor
		 */
		public function Object_tween(obj:Object, props:Object, delay:int = 50, dur:int = 1000):void{
			_target		= obj;
			_duration	= dur;
			_repeat		= Math.ceil(dur / delay);
			
			set_params(props);
			start_tween(delay, _repeat);
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
			dispatchEvent(new Event('object_tween_complete'));
		}
		
		/**
		 * Update the tween object properties
		 */
		public function update_tween(e:TimerEvent):void{
			_counter++;
			if(_counter < _repeat){
				apply_tween(_counter, _repeat);
				dispatchEvent(new Event('object_tween_change'));
			}else{
				_counter = 0;
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
					switch(e){
						case 'tint':
							var ct:ColorTransform = _target.transform.colorTransform;
							obj[e].from = ct;
						case 'color':
							var rgb:RGB = RGB.create_from_number(_target.transform.colorTransform.color);
							obj[e].from = rgb;
							break;
						default:
							obj[e].from = _target[e];
					}
				}else{
					switch(e){
						case 'tint':
							if(prop.from is ColorTransform){
								obj[e].from = prop.from;
							}else if(prop.from is Number){
								var color:RGB = RGB.create_from_number(prop.from);
								ct = new ColorTransform();
								ct.redMultiplier	= prop.from;
								ct.greenMultiplier	= prop.from;
								ct.blueMultiplier	= prop.from;
								obj[e].from = ct;
							}
							break;
							
						case 'color':
							if(prop.from is ColorTransform){
								rgb = RGB.create_from_number(prop.from.color);
							}else if(prop.from is String){
								rgb = RGB.create_from_hex(prop.from);
							}else if(prop.from is Number){
								rgb = RGB.create_from_number(prop.from);
							}
							obj[e].from = rgb;
							break;
							
						default:
							obj[e].from = prop.from;
					}
				}
				
				if(prop.to != null){
					switch(e){
						case 'tint':
							if(prop.to is ColorTransform){
								obj[e].to = prop.to;
							}else if(prop.to is Number){
								ct = new ColorTransform();
								ct.redMultiplier	= prop.to;
								ct.greenMultiplier	= prop.to;
								ct.blueMultiplier	= prop.to;
								obj[e].to = ct;
							}
							break;
							
						case 'color':
							if(prop.to is ColorTransform){
								rgb = RGB.create_from_number(prop.to.color);
							}else if(prop.to is String){
								rgb = RGB.create_from_hex(prop.to);
							}else if(prop.to is Number){
								rgb = RGB.create_from_number(prop.to);
							}
							obj[e].to = rgb;
							break;
					}
				}
				
				if(prop.by != null){
					switch(e){
						case 'tint':
							var frm:Number = obj.from.redMultiplier;
							var fgm:Number = obj.from.greenMultiplier;
							var fbm:Number = obj.from.blueMultiplier;
							
							if(prop.by is ColorTransform){
								var brm:Number = prop.by.redMultiplier;
								var bgm:Number = prop.by.greenMultiplier;
								var bbm:Number = prop.by.blueMultiplier;
							}else if(prop.by is Number){
								brm = prop.by;
								bgm = prop.by;
								bbm = prop.by;
							}
							
							ct = new ColorTransform();
							ct.redMultiplier	= frm + brm > 0 ? Math.max(frm + brm, 1) : 0;
							ct.greenMultiplier	= fgm + bgm > 0 ? Math.max(fgm + bgm, 1) : 0;
							ct.blueMultiplier	= fbm + bbm > 0 ? Math.max(fbm + bbm, 1) : 0;
							obj[e].to = ct;
							break;
						
						case 'color':
							var fro:int = obj.from.get_red()
							var fgo:unt = obj.from.get_green();
							var fbo:int = obj.from.get_blue();
							
							if(prop.by is ColorTransform){
								var bro:int = prop.by.redOffset;
								var bgo:int = prop.by.greenOffset;
								var bbo:int = prop.by.blueOffset;
							}else{
								if(prop.by is String){
									rgb = RGB.create_from_hex(prop.by);
								}else if(prop.by is Number){
									rgb = RGB.create_from_number(prop.by);
								}
								bro = rgb.get_red();
								bgo = rgb.get_green();
								bbo = rgb.get_blue();
							}
							
							rgb = new RGB();
							rgb.set_red(fro + bro);
							rgb.set_green(fgo + bgo);
							rgb.set_blue(fbo + bbo);
							obj[e].to = rgb;
							break;
							
						default:
							obj[e].to = obj[e].from + [e].by;
					}
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
				switch(e){
					case 'tint':
						var frm:Number = prop.from.redMultiplier;
						var fgm:Number = prop.from.greenMultiplier;
						var fbm:Number = prop.from.blueMultiplier;
						
						var trm:Number = prop.to.redMultiplier;
						var tgm:Number = prop.to.greenMultiplier;
						var tbm:Number = prop.to.blueMultiplier;
						
						var rm:Number = prop.easing(counter, frm, trm - frm, duration);
						var gm:Number = prop.easing(counter, fgm, tgm - fgm, duration);
						var bm:Number = prop.easing(counter, fbm, tbm - fbm, duration);
						
						var ct:ColorTransform = prop.from;
						ct.redMultiplier	= rm;
						ct.greenMultiplier	= gm;
						ct.blueMultiplier	= bm;
						_target.transform.colorTransform = ct;
						break;
						
					case 'color':
						var fr:int = prop.from.get_red();
						var fg:int = prop.from.get_green();
						var fb:int = prop.from.get_blue();
						
						var tr:int = prop.to.get_red();
						var tg:int = prop.to.get_green();
						var tb:int = prop.to.get_blue();
						
						var red:int		= prop.easing(counter, fr, tr - fr, duration);
						var green:int	= prop.easing(counter, fg, tg - fg, duration);
						var blue:int	= prop.easing(counter, fb, tb - fb, duration);
						
						var rgb:RGB = new RGB(red, green, blue);
						ct = new ColorTransform();
						ct.color = rgb.get_number();
						_target.transform.colorTransform = ct;
						break;
						
					case 'text_size':
						//get text size and create new TextFormat object
						var d:Number = prop.easing(counter, prop.from, (prop.to - prop.from), duration);
						var tf:TextFormat = new TextFormat();
						tf.size = d;
						
						//get current x coordinate and text width
						var sx:Number = _target.x;
						var sw:Number = _target.width;
						
						//set new text format
						if(_target.hasOwnProperty('_field')){
							_target._field.setTextFormat(tf);
						}else{
							_target.setTextFormat(tf);
						}
						
						//adjust position (centered)
						var ew:Number = _target.width;
						_target.x = sx + ((sw - ew) / 2);
						break;
						
					default:
						_target[e] = prop.easing(counter, prop.from, (prop.to - prop.from), duration);
				}
			}//end for
		}//end method
	}
}