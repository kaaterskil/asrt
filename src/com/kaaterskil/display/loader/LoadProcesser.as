package com.kaaterskil.display.loader {
	/**
	 * @author Blair
	 */
	public interface LoadProcesser {
		function get isLoaded() : Boolean;
		function load(src:String) : void;
	}
}
