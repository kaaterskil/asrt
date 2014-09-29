/**
 * Kaaterskil Library
 * Copyright (C) 2008-2011 Kaaterskil Management, LLC.
 * 
 * This program is free software: you can redistribute it 
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
 * <http://www.gnu.org/licenses/> or write to the Free Software 
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
 * In accordance with Section 7(b) of the GNU Affero General 
 * Public License version 3, these Appropriate Legal Notices 
 * must display the words "Powered by Kaaterskil".
 */
package com.kaaterskil.display {
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	/**
	 * TextProperties
	 *
	 * @author Blair Caple
	 * @version $Id: $
	 */
	public class TextProperties {
		private var antiAliasType : AntiAliasType;
		private var autoSize : TextFieldAutoSize;
		private var background : Boolean;
		private var embedFont : Boolean;
		private var multiline : Boolean;
		private var selectable : Boolean;
		private var htmlText : String;
		private var wordwrap : Boolean;
		
		public function TextProperties(
			antiAliasType : AntiAliasType, 
			autosize : TextFieldAutoSize, 
			background : Boolean, 
			embedFont : Boolean, 
			multiline : Boolean, 
			selectable : Boolean, 
			htmlText : String, 
			wordwrap : Boolean) {
			
			this.antiAliasType = antiAliasType;
			this.autoSize = autosize;
			this.background = background; 
			this.embedFont = embedFont;
			this.multiline = multiline;
			this.selectable = selectable;
			this.htmlText = htmlText;
			this.wordwrap = wordwrap;
		}
		
		public function getAntiAliasType() : AntiAliasType {
			return antiAliasType;
		}
		
		public function getAutosize() : TextFieldAutoSize {
			return autoSize;
		}
		
		public function getBackground() : Boolean {
			return background;
		}
		
		public function isEmbedFont() : Boolean {
			return embedFont;
		}
		
		public function isMultiline() : Boolean {
			return multiline;
		}
		
		public function isSelectable() : Boolean {
			return selectable;
		}
		
		public function getHtmlText() : String {
			return htmlText;
		}
		
		public function isWordwrap() : Boolean {
			return wordwrap;
		}
	}
}
