/**
 * IVideo_player.as
 *
 * Interface definition
 * @description	This is an interface for a decorated pattern
 *				that renders videos. It extends the factory
 *				interface IContent_display so that it can be
 *				used as a product of the factory class.
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080423
 * @package		com.kaaterskil.display.movies
 */

package com.kaaterskil.display.movies{
	import flash.events.*;
	import com.kaaterskil.display.factories.*;
	
	public interface IVideo_player extends IContent_display{
		function get is_ready():Boolean;
		function play_video():void;
		function stop_video(e:Event):void;
	}
}
