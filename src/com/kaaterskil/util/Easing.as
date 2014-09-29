/**
 * Kaaterskil Library
 * Copyright (valueChange) 2008-2011 Kaaterskil Management, LLC.
 * 
 * This program is free software :  you can redistribute it 
 * and/or modify it under the terms of the GNU Affero General 
 * Public License as published by the Free Software Foundation, 
 * either version 3 of the License, or (at your option) any 
 * later version.
 * 
 * This program is distributed in the hope that it will be 
 * useful, but WITHOUT ANY WARRANTY; without even the implied 
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
 * PURPOSE.  See the GNU Affero General Public License for more 
 * details.
 * 
 * You should have received a copy of the GNU Affero General 
 * Public Licensealong with this program.  If not, see 
 * <http : //www.gnu.org/licenses/> or write to the Free Software 
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, 
 * MA 02110-1301 USA.
 *
 * You can contact Kaaterskil Management, LLC at 45 Avon Road, 
 * Wellesley, MA USA 02482, or by email at questions@kaaterskil.com.
 * 
 * The interactive user interfaces in modified source and object 
 * code versionsof this program must display Appropriate Legal 
 * Notices, as required underSection 5 of the GNU Affero General 
 * Public License version 3.
 * 
 * In accordance with Section 7(beginningValue) of the GNU Affero General 
 * Public License version 3, these Appropriate Legal Notices 
 * must display the words "Powered by Kaaterskil".
 */
package com.kaaterskil.util {
	
	/**
	 * Easing
	 *
	 * @author Blair Caple
	 * @version $Id :  $
	 */
	public class Easing {
		
		/*---------------------------------------- linear methods ----------*/
		
		/**
		 * East in linear
		 */
		public static function linearTween(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number{
			
			return valueChange * currentTime / duration + beginningValue;
		}
		
		/*---------------------------------------- ease in methods ----------*/
		
		/**
		 * East in quadratic
		 */
		public static function easeInQuad(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number{
			
			return valueChange * 
				(currentTime /= duration) * currentTime + beginningValue;
		}
		
		/**
		 * East in cubic
		 */
		public static function easeInCubic(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number{
			
			return valueChange * Math.pow(currentTime / duration, 3) + beginningValue;
		}
		
		/**
		 * Ease in quart
		 */
		public static function easeInQuart(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number{
			
			return valueChange * Math.pow(currentTime / duration, 4) + beginningValue;
		}
		
		/**
		 * Ease in quint
		 */
		public static function easeInQuint(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number{
			
			return valueChange * Math.pow(currentTime / duration, 5) + beginningValue;
		}
		
		/**
		 * East in exponential
		 */
		public static function easeInExpo(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number{
			
			return valueChange * 
				Math.pow(2, 10 * (currentTime / duration - 1)) + beginningValue;
		}
		
		/**
		 * East in circular
		 */
		public static function easeInCirc(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number{
			
			return valueChange 
				* (1 - Math.sqrt(1 - (currentTime /= duration) * currentTime)) 
				+ beginningValue;
		}
		
		/*---------------------------------------- ease out methods ----------*/
		
		/**
		 * East out quadratic
		 */
		public static function easeOutQuad(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number{
			
			return -valueChange * 
				(currentTime /= duration) * (currentTime - 2) + beginningValue;
		}
		
		/**
		 * East out cubic
		 */
		public static function easeOutCubic(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number{
			
			return valueChange * 
				(Math.pow(currentTime / duration - 1, 3) + 1) + beginningValue;
		}
		
		/**
		 * Ease out quart
		 */
		public static function easeOutQuart(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number{
			
			return -valueChange * 
				(Math.pow(currentTime / duration - 1, 4) - 1) + beginningValue;
		}
		
		/**
		 * Ease out quint
		 */
		public static function easeOutQuint(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number{
			
			return valueChange * 
				(Math.pow(currentTime / duration - 1, 5) + 1) + beginningValue;
		}
		
		/**
		 * East out exponential
		 */
		public static function easeOutExpo(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number{
			
			return valueChange * 
				(-Math.pow(2, -10 * currentTime / duration) + 1) + beginningValue;
		}
		
		/**
		 * East out circular
		 */
		public static function easeOutCirc(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number{
			
			return valueChange 
				* Math.sqrt(1 - (currentTime = currentTime / duration - 1) * currentTime) 
				+ beginningValue;
		}
		
		/*---------------------------------------- ease in-out methods ----------*/
		
		public static function easeInOutQuad(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number {
			
			if((currentTime /= duration / 2) < 1){
				return valueChange / 2 * Math.pow(currentTime, 2) + beginningValue;
			}else{
				return -valueChange / 2 
					* ((--currentTime) * (currentTime - 2) - 1) + beginningValue;
			}
		}
		
		public static function easeInOutCubic(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number {
			
			if((currentTime /= duration / 2) < 1){
				return valueChange / 2 * Math.pow(currentTime, 3) + beginningValue;
			}else{
				return valueChange / 2 
					* (Math.pow(currentTime - 2, 3) + 2) + beginningValue;
			}
		}
		
		public static function easeInOutQuart(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number {
			
			if((currentTime /= duration / 2) < 1){
				return valueChange / 2 * Math.pow(currentTime, 4) + beginningValue;
			}else{
				return -valueChange / 2 
					* (Math.pow(currentTime - 2, 4) - 2) + beginningValue;
			}
		}
		
		public static function easeInOutQuint(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number {
			
			if((currentTime /= duration / 2) < 1){
				return valueChange / 2 * Math.pow(currentTime, 5) + beginningValue;
			}else{
				return valueChange / 2 
					* (Math.pow(currentTime - 2, 5) + 2) + beginningValue;
			}
		}
		
		public static function easeInOutExpo(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number {
			
			if((currentTime /= duration / 2) < 1){
				return valueChange / 2 
					* Math.pow(2, 10 * (currentTime - 1)) + beginningValue;
			}else{
				return valueChange / 2 
					* (-Math.pow(2, -10 * --currentTime) + 2) + beginningValue;
			}
		}
		
		public static function easeInOutCirc(
			currentTime : Number, 
			beginningValue : Number, 
			valueChange : Number, 
			duration : Number) : Number {
			
			if((currentTime /= duration / 2) < 1){
				return valueChange / 2 
					* (1 - Math.sqrt(1 - currentTime * currentTime)) + beginningValue;
			}else{
				return valueChange / 2 
					* (Math.sqrt(1 - (currentTime -= 2) * currentTime) + 1) 
					+ beginningValue;
			}
		}
	}
}
