/**
 * ISettings.as
 *
 * Interface definition
 * @copyright 2008 Kaaterskil Management, LLC
 * @version 080416
 * @package com.kaaterskil.utilities
 */

package com.kaaterskil.utilities{
	import com.kaaterskil.utilities.iterators.*;
	
	public interface ISettings{
		function init():void;
		
		//this method returns a copy of the story data
		function get_stories():IIterator;
		
		//this function returns a copy of the text formats
		function get_formats():IIterator;
	}
}