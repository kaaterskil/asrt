/**
 * IStory.as
 *
 * Interface definition
 * @description	This is the interface for a decorator pattern 
 *				that renders stories, images, movies, galleries
 *				of images and downloads to the screen.
 * @copyright	2008 Kaaterskil Management, LLC
 * @version		080416
 * @package		com.kaaterskil.display.stories
 */

package com.kaaterskil.display.stories{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFormat;
	
	public interface IStory{
		//returns an associative array of story parameters
		function get_prams():Object;
		
		//returns the topmost display container of a story
		function get_container():DisplayObjectContainer;
		
		//return the length of the tracking index
		function index_length():int;
		
		//returns either a tracking index element or its last element
		function read_index(i:int = -1):Object;
		
		//adds a text display object to the tracking index
		function push_index(obj:Object):void;
		
		//removes a text display object from the tracking index
		function splice_index(start_index:int, count:int = 1):void;
		
		//returns a specified text format object
		function get_format(id:String):TextFormat;
		
		//draws the headline text
		function draw_headline():void;
		
		//draws the body text
		function draw_body(text_width:Number = 0):void;
	}
}