/**
 * IPreloader.as
 *
 * Interface definition
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080423
 * @package		com.kaaterskil.display.preloaders
 */

package com.kaaterskil.display.preloaders{
	import flash.display.*;
	import com.kaaterskil.display.factories.*;
	
	public interface IPreloader{
		function process(prams:Object, container:DisplayObjectContainer = null):IDisplay;
	}
}