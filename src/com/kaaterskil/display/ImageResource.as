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
	import com.kaaterskil.display.Resource;

	import flash.text.TextFormat;

	/**
	 * ImageResource
	 *
	 * @author Blair Caple
	 * @version $Id: $
	 */
	public class ImageResource extends Resource {
		private var description : String;
		private var position : Number = -1;
		
		public function ImageResource(
			name : String, 
			src : String, 
			textFormat : TextFormat, 
			filename : String, 
			position : Number = -1, 
			description : String = null) {
				
			super(name, src, textFormat, filename);
			this.description = description;
			this.position = position;
		}
		
		public function getDescription() : String {
			return description;
		}
		
		public function getPosition() : Number {
			return position;
		}
	}
}
