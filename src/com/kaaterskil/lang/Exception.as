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
package com.kaaterskil.lang {
	/**
	 * Exception
	 *
	 * @author Blair Caple
	 * @version $Id: $
	 */
	public class Exception extends Error {
		/** 
		 * The throwable that caused this throwable to get thrown, 
		 * or null if this throwable was not caused by another 
		 * throwable, or if the causative throwable is unknown. 
		 * If this field is equal to this throwable itself, it 
		 * indicates that the cause of this throwable has not yet 
		 * been initialized.
		 */
		private var cause : Error;
		
		/**
		 * Constructs a new Exception with the specified detail 
		 * message and cause.
		 * 
		 * @param message The detail message.
		 * @param cause The cause, or null if the cause is 
		 * 			nonexistent or unknown.
		 */
		public function Exception(message : String = null, cause : Error = null) {
			super(message);
			if(null !== cause) {
				this.cause = cause;
			} else {
				this.cause = null;
			}
		}
		
		/**
		 * Returns the cause of this exception or null.
		 * 
		 * @return the cause of this exception or null.
		 */
		public function getCause() : Error {
			return cause == this ? null : cause;
		}
		
		/**
		 * Initialize the cause of this exception to the specified value. 
		 * (The cause is the error that caused this exeption to get 
		 * thrown.)
		 * 
		 * This method can be called at most once. It is generally 
		 * called from within the constructor or immediately after 
		 * creating the excetion.
		 * 
		 * @param cause The cuase. A null value is permitted and 
		 * 			indicates that the cause is nonexistent or unknown.
		 * @return A reference to this instance.
		 * @throws IllegalStateException if this exception was 
		 * 			created wiht this constructor or this method has 
		 * 			already been called on this instance.
		 * @throws IllegalArgumentException is cause if this instance. 
		 * 			(An exceptio cannot be its own cause.)
		 */
		public function initCause(cause : Error) : Error {
			if(this.cause == this){
			 throw new IllegalStateException("Can't overwrite cause");	
			}
			if(cause == this) {
				throw new IllegalArgumentException("Self-causation not permitted");
			}
			this.cause = cause;
			return this;
		}
	}
}
