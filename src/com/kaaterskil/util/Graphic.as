/**
 * Graphic.as
 *
 * @copyright 2007 Kaaterskil Management, LLC
 * @version 071114
 * @package com.kaaterskil.utilities
 */

package com.kaaterskil.utilities{
	import flash.display.*;
	import flash.geom.*;
	
	/**
	 * The Graphic class wraps around the drawing methods of the Flash
	 * Graphics class, and can be used to build more complex shapes.
	 */
	public class Graphic{
		/**
		 * The target object
		 */
		private var _target_obj:Graphics;
		
		/**
		 * Test if lineStyle() has been set
		 */
		private var _is_style_set:Boolean;
		
		/**
		 * Constructor
		 */
		public function Graphic(target:Graphics):void{
			_target_obj = target;
		}
		
		/**
		 * Get or set the target Shape, Sprite or MovieClip. This can
		 * also be accomplished through the constructor.
		 */
		public function get target():Graphics{
			return _target_obj;
		}
		
		public function set target(target:Graphics):void{
			_target_obj = target;
		}
		
		/*------------------------------------------------------------
		LINE STYLE FUNCTIONS
		------------------------------------------------------------*/		
		/**
		 * Sets line style.
		 * @param thickness			The thickness in pixels
		 * @param rgb				The RGB hex color
		 * @param opacity			The alpha value as a decimal
		 * @param pixel_hinting		Hints strokes to full pixel (Boolean)
		 * @param scale_mode		Directs how to scale line thickness
		 * @param caps				The style of cap at the end of a line
		 * @param joints			The style of angles
		 * @param miter_limit		The limit at which an angle is cut-off
		 */
		public function lineStyle(thickness:Number		= 1, 
								  rgb:Number			= 0x000000, 
								  opacity:Number		= 1, 
								  pixel_hinting:Boolean	= false, 
								  scale_mode:String		= 'normal', 
								  caps:String			= null, 
								  joints:String			= null, 
								  miter_limit:Number	= 3):void{
			
			_target_obj.lineStyle(thickness, 
								  rgb, 
								  opacity, 
								  pixel_hinting, 
								  scale_mode, 
								  caps, 
								  joints, 
								  miter_limit);
			_is_style_set = true;
		}
		
		/**
		 * Set line gradient style.
		 * @param type				The gradient type to use
		 * @param colors			RGB hex colors
		 * @param alphas			Alpha values
		 * @param ratios			Color distribution values
		 * @param matrix			Specifies a transformation matrix
		 * @param spread_method		Specifies which spread method to use
		 * @param interpolation		A value from the interpolation class
		 * @param focal_point		The location of the focal point
		 */
		public function lineGradientStyle(type:String, 
										  colors:Array, 
										  alphas:Array, 
										  ratios:Array,
										  matrix:Matrix			= null, 
										  spread_method:String	= 'pad', 
										  interpolation:String	= 'rgb', 
										  focal_point:Number	= 0):void{
			if(!_is_style_set){
				lineStyle();
			}
			_target_obj.lineGradientStyle(type, 
										  colors, 
										  alphas, 
										  ratios, 
										  matrix,
										  spread_method, 
										  interpolation, 
										  focal_point);
		}
		
		/*------------------------------------------------------------
		FILL FUNCTIONS
		------------------------------------------------------------*/		
		/**
		 * Begin fill
		 * @param rgb		The RGB hex color
		 * @param opactity	The fill opactity as a decimal
		 */
		public function beginFill(rgb:Number, opacity:Number = 1):void{
			_target_obj.beginFill(rgb, opacity);
		}
		
		/**
		 * Begin gradient fill
		 * @param type				The gradient type to use
		 * @param colors			RGB hex colors
		 * @param alphas			Alpha values
		 * @param ratios			Color distribution values
		 * @param matrix			Specifies a transformation matrix
		 * @param spread_method		Specifies which spread method to use
		 * @param interpolation		A value from the interpolation class
		 * @param focal_point		The location of the focal point
		 */
		public function beginGradientFill(type:String,
										  colors:Array,
										  alphas:Array,
										  ratios:Array,
										  matrix:Matrix			= null,
										  spread_method:String	= 'pad',
										  interpolation:String	= 'rgb',
										  focal_point:Number	= 0):void{
			
			_target_obj.beginGradientFill(type, 
										  colors, 
										  alphas, 
										  ratios, 
										  matrix,
										  spread_method, 
										  interpolation, 
										  focal_point);
		}
		
		/**
		 * Begin bitmap fill
		 * @param bitmap	The bitmap image to be displayed
		 * @param matrix	The matrix object for transformations
		 * @param repeat	Test to repeat ina  tiled pattern
		 * @param smooth	Test for pixellation algorithm
		 */
		public function beginBitmapFill(bitmap:BitmapData,
										matrix:Matrix		= null,
										repeat:Boolean		= true,
										smooth:Boolean		= false):void{
			
			_target_obj.beginBitmapFill(bitmap, matrix, repeat, smooth);
		}
		
		/**
		 * End fill
		 */
		public function endFill():void{
			_target_obj.endFill();
		}
		
		/*------------------------------------------------------------
		LINE FUNCTIONS
		------------------------------------------------------------*/		
		/**
		 * Draw line
		 */
		public function draw_line(x_start:Number, 
								  y_start:Number, 
								  x_end:Number, 
								  y_end:Number):void{
			if(!_is_style_set){
				lineStyle();
			}
			_target_obj.moveTo(x_start, y_start);
			_target_obj.lineTo(x_end, y_end);
		}
		
		/**
		 * Draw curve
		 */
		public function draw_curve(x_start:Number, 
								   y_start:Number, 
								   control_x:Number, 
								   control_y:Number, 
								   anchor_x:Number, 
								   anchor_y:Number):void{
			if(!_is_style_set){
				lineStyle();
			}
			_target_obj.moveTo(x_start, y_start);
			_target_obj.curveTo(control_x, control_y, anchor_x, anchor_y);
		}
		
		/*------------------------------------------------------------
		SHAPE FUNCTIONS
		------------------------------------------------------------*/		
		/**
		 * Draw rectangle
		 */
		public function draw_rectangle(x_start:Number, 
									   y_start:Number, 
									   x_width:Number, 
									   y_height:Number):void{
			if(!_is_style_set){
				lineStyle();
			}
			_target_obj.drawRect(x_start, y_start, x_width, y_height);
		}
		
		/**
		 * Draw rounded rectangle
		 */
		public function draw_rounded_rectangle(x_start:Number, 
											   y_start:Number, 
											   x_width:Number, 
											   y_height:Number, 
											   radius:Number):void{
			if(!_is_style_set){
				lineStyle();
			}
			_target_obj.drawRoundRect(x_start ,y_start, x_width, y_height, radius);
		}
		
		/**
		 * Draw circle
		 */
		public function draw_circle(x_origin:Number, 
									y_origin:Number, 
									radius:Number):void{
			if(!_is_style_set){
				lineStyle();
			}
			_target_obj.drawCircle(x_origin, y_origin, radius);
		}
		
		/**
		 * Draw slice
		 */
		public function draw_slice(x_origin:Number, 
								   y_origin:Number, 
								   radius:Number, 
								   arc:Number, 
								   angle_start:Number):void{
			draw_arc(x_origin, y_origin, radius, arc, angle_start, true);
		}
		
		/**
		 * Draw arc. The arc will be drawm in eight segments.
		 */
		public function draw_arc(x_origin:Number, 
								 y_origin:Number, 
								 radius:Number, 
								 arc:Number,
								 angle_start:Number = 0, 
								 show_radial_lines:Boolean = false):void{
			if(arc > 360){
				arc = 360;
			}
			arc = Math.PI / 180 * arc;
			var angle_delta:Number = arc / 8;
			
			//Compute the distance from the origin to the control points
			var distance:Number = radius / Math.cos(angle_delta / 2);
			
			//convert from degrees to radians
			angle_start *= Math.PI / 180;
			
			var angle:Number = angle_start;
			var x_control:Number;
			var y_control:Number;
			var x_anchor:Number;
			var y_anchor:Number;
			
			var x_start:Number = x_origin + Math.cos(angle_start) * radius;
			var y_start:Number = y_origin + Math.sin(angle_start) * radius;
			
			//move to the starting point
			if(show_radial_lines){
				moveTo(x_origin, y_origin);
				lineTo(x_start, y_start);
			}else{
				moveTo(x_start, y_start);
			}
			
			//create the eight segments
			for(var i:int = 0; i < 8; i++){
				//increment the angle
				angle += angle_delta;
				
				//compute the control points
				x_control = x_origin + Math.cos(angle - (angle_delta / 2)) * distance;
				y_control = y_origin + Math.sin(angle - (angle_delta / 2)) * distance;
				
				//compute the anchor points (end point of the curve)
				x_anchor = x_origin + Math.cos(angle) * radius;
				y_anchor = y_origin + Math.sin(angle) * radius;
				
				//draw the segment
				curveTo(x_control, y_control, x_anchor, y_anchor);
			}
			if(show_radial_lines){
				lineTo(x_origin, y_origin);
			}
		}
		
		/**
		 * Draw ellipse
		 */
		public function draw_ellipse(x_origin:Number, 
									 y_origin:Number, 
									 x_radius:Number, 
									 y_radius:Number):void{
			var angle_delta:Number = Math.PI / 4;
			var angle:Number = 0;
			
			var x_distance:Number = x_radius / Math.cos(angle_delta / 2);
			var y_distance:Number = y_radius / Math.cos(angle_delta / 2);
			var x_control:Number;
			var y_control:Number;
			var x_anchor:Number;
			var y_anchor:Number;
			
			moveTo(x_origin + x_radius, y_origin);
			
			for(var i:int = 0; i < 8; i++){
				//increment angle
				angle += angle_delta;
				
				//compute beginning and ending points to the curve segment
				x_control = x_origin + Math.cos(angle - (angle_delta / 2)) * x_distance;
				y_control = y_origin + Math.sin(angle - (angle_delta / 2)) * y_distance;
				x_anchor = x_origin + Math.cos(angle) * x_radius;
				y_anchor = y_origin + Math.sin(angle) * y_radius;
				
				//draw curve segment
				curveTo(x_control, y_control, x_anchor, y_anchor);
			}
		}
		
		/**
		 * Draw triangle
		 */
		public function draw_triangle(x_a:Number, 
									  y_a:Number, 
									  ab:Number, 
									  ac:Number, 
									  angle:Number, 
									  rotate:Number = 0):void{
			//convert from degrees to radians
			rotate = rotate * Math.PI / 180;
			angle = angle * Math.PI / 180;
			
			//calculate the coordinates for points b and c
			var x_b:Number = Math.cos(angle - rotate) * ab;
			var y_b:Number = Math.sin(angle - rotate) * ab;
			var x_c:Number = Math.cos(-rotate) * ac;
			var y_c:Number = Math.sin(-rotate) * ac;
			
			var x_centroid:Number = 0;
			var y_centroid:Number = 0;
			
			//move to point a and draw line ac
			var x_start:Number = x_a - x_centroid;
			var y_start:Number = y_a - y_centroid;
			var x_end:Number = x_c - x_centroid + x_a;
			var y_end:Number = y_c - y_centroid + y_a;
			draw_line(x_start, y_start, x_end, y_end);
			
			//draw line cb
			var x_coord:Number = x_b - x_centroid + x_a;
			var y_coord:Number = y_b - y_centroid + y_a;
			lineTo(x_coord, y_coord);
			
			//draw line ba
			lineTo(x_start, y_start);
		}
		
		/*------------------------------------------------------------
		UTILITIES
		------------------------------------------------------------*/		
		/**
		 * Clear operator
		 */
		public function clear():void{
			_target_obj.clear();
			_is_style_set = false;
		}
		
		/**
		 * Move to
		 */
		public function moveTo(x_coord:Number, y_coord:Number):void{
			_target_obj.moveTo(x_coord, y_coord);
		}
		
		/**
		 * Line to
		 */
		public function lineTo(x_coord:Number, y_coord:Number):void{
			if(!_is_style_set){
				lineStyle();
			}
			_target_obj.lineTo(x_coord, y_coord);
		}
		
		/**
		 * Curve to
		 */
		public function curveTo(x_control:Number, 
								 y_control:Number, 
								 x_anchor:Number, 
								 y_anchor:Number):void{
			if(!_is_style_set){
				lineStyle();
			}
			_target_obj.curveTo(x_control, y_control, x_anchor, y_anchor);
		}
	}
}