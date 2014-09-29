/**
 * Kaaterskil Library
 *
 * @package		com.kaaterskil.utilities.loaders
 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
 */

package com.kaaterskil.utilities.loaders{
	/**
	 * IURLLoader interface
	 *
	 * @description	This interface extends the ILoader interface 
	 *				by altering the required parameters germane 
	 *				to URL loaders.
	 * @package		com.kaaterskil.utilities.loaders
	 * @copyright	Copyright (c) 2008 Kaaterskil Management, LLC
	 * @version		080417
	 */
	public interface IURLLoader{
		function process_load(src:*, vars:* = null, format:String = 'text',
									   method:String = 'GET'):void;
	}
}