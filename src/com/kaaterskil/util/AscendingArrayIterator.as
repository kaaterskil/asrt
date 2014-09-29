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
package com.kaaterskil.util {
	import com.kaaterskil.util.Iterator;
	import com.kaaterskil.util.NoSuchElementException;

	/**
	 * An array iterator whose pointer begins at the first element.
	 *
	 * @author Blair Caple
	 * @version $Id: $
	 */
	public class AscendingArrayIterator implements Iterator {
		private var index : int;
		private var data : Array;
		
		function AscendingArrayIterator(data : Array) {
			index = 0;
			this.data = data;
		}
		
		public function hasNext() : Boolean {
			return index < data.length;
		}

		public function next() : * {
			if(index >= data.length){
				throw new NoSuchElementException();
			}
			return data[index++];
		}

		public function reset() : void {
			index = 0;
		}
	}
}
