/*
* Copyright (c) 2007-2010 Regents of the University of California.
*   All rights reserved.
*
*   Redistribution and use in source and binary forms, with or without
*   modification, are permitted provided that the following conditions
*   are met:
*
*   1. Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the distribution.
*
*   3.  Neither the name of the University nor the names of its contributors
*   may be used to endorse or promote products derived from this software
*   without specific prior written permission.
*
*   THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
*   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*   ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
*   FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
*   DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
*   OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
*   HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
*   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
*   OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
*   SUCH DAMAGE.
*/

package org.juicekit.util
{
	import org.juicekit.interfaces.IPredicate;
	
	/**
	 * Utility methods for creating filter functions. The static
	 * <code>$()</code> method takes an arbitrary object and generates a
	 * corresponding filter function.
	 *
	 * <p>Filter functions are functions that take one argument and return a
	 * <code>Boolean</code> value. The input argument to a filter function
	 * passes the filter if the function returns true and fails the
	 * filter if the function returns false.</p>
	 */
	public class Filter
	{
		/**
		 * Constructor, throws an error if called, as this is an abstract class.
		 */
		public function Filter()
		{
			throw new Error("This is an abstract class.");
		}
		
		/**
		 * Convenience method that returns a filter function determined by the
		 * input object.
		 * <ul>
		 *  <li>If the input is null or a <code>Function</code>, it is simply
		 *      returned.</li>
		 *  <li>If the input is an <code>IPredicate</code>, its
		 *      <code>predicate</code> function is returned.</li>
		 *  <li>If the input is a <code>String</code>, a <code>Property</code>
		 *      instance with the string as the property name is generated, and
		 *      the <code>predicate</code> function of the property is
		 *      returned.</li>
		 *  <li>If the input is a <code>Class</code> instance, a function that
		 *      performs type-checking for that class type is returned.</li>
		 *  <li>In any other case, an error is thrown.</li>
		 * </ul>
		 * @param f an input object specifying the filter criteria
		 * @return the filter function
		 */
		public static function $(f:*):Function
		{
			if (f == null || f is Function) {
				return f;
			} else if (f is IPredicate) {
				return IPredicate(f).predicate;
			} else if (f is String) {
				return Property.$(f).predicate;
			} else if (f is Class) {
				return typeChecker(Class(f));
			} else {
				throw new ArgumentError("Unrecognized filter type");
			}
		}
		
		/**
		 * Returns a filter function that performs type-checking.
		 * @param type the <code>Class</code> type to check for
		 * @return a <code>Boolean</code>-valued type checking filter function
		 */
		public static function typeChecker(type:Class):Function
		{
			return function(o:Object):Boolean {
				return o is type;
			}
		}
		
	} // end of class Filter
}