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
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.Sort;
	
	
	/**
	 * Utility class for sorting and creating sorting functions. This class
	 * provides a static <code>$()</code> method for creating sorting
	 * comparison functions from sort criteria. Instances of this class can be
	 * used to encapsulate a set of sort criteria and retrieve a corresponding
	 * sorting function.
	 *
	 * <p>Sort criteria are generally expressed as an array of property names
	 * to sort on. These properties are accessed by sorting functions using the
	 * <code>Property</code> class. Sort criteria are expressed as an
	 * array of property names to sort on. These properties are accessed
	 * by sorting functions using the <code>Property</code> class.
	 * The default is to sort in ascending order. If the field name
	 * includes a "-" (negative sign) prefix, that variable will instead
	 * be sorted in descending order.
	 * </p>
	 * 
	 * <p>A "#" (hash) prefix will perform a natural sorting algorithm outlined
	 * at <a href="http://www.davekoelle.com/alphanum.html">
	 * http://www.davekoelle.com/alphanum.html</a>.
	 *
	 * <p>"The Alphanum Algorithm sorts strings containing a mix of letters and
	 * numbers. Given strings of mixed characters and numbers, it sorts the
	 * numbers in value order, while sorting the non-numbers in ASCII order.
	 * The end result is a natural sorting order."</p>
	 *
	 * @author Jon Buffington
	 * @author Chris Gemignani
	 * @author Flare team
	 */
	public class Sort
	{
		/** Prefix indicating an ascending sort order. */
		public static const ASC:Number = '+'.charCodeAt(0);
		/** Prefix indicating a descending sort order. */
		public static const DSC:Number = '-'.charCodeAt(0);
		/** Prefix indicating an alphanum sort order. */
		public static const ALPHANUM:Number = '#'.charCodeAt(0);
		
		private var _comp:Function;
		private var _crit:Array;
		
		/** Gets the sorting comparison function for this Sort instance. */
		public function get comparator():Function {
			return _comp;
		}
		
		/** The sorting criteria. Sort criteria are expressed as an
		 *  array of property names to sort on. These properties are accessed
		 *  by sorting functions using the <code>Property</code> class.
		 *  The default is to sort in ascending order. If the field name
		 *  includes a "-" (negative sign) prefix, that variable will instead
		 *  be sorted in descending order. */
		public function get criteria():Array {
			return Arrays.copy(_crit);
		}
		
		public function set criteria(crit:*):void {
			if (crit is String) {
				_crit = [crit];
			} else if (crit is Array) {
				_crit = Arrays.copy(crit as Array);
			} else {
				throw new ArgumentError("Invalid Sort specification type. " +
					"Input must be either a String or Array");
			}
			_comp = $(_crit);
		}
		
		/**
		 * Creates a new Sort instance to encapsulate sorting criteria.
		 * @param crit the sorting criteria. Sort criteria are expressed as an
		 *  array of property names to sort on. These properties are accessed
		 *  by sorting functions using the <code>Property</code> class.
		 *  The default is to sort in ascending order. If the field name
		 *  includes a "-" (negative sign) prefix, that variable will instead
		 *  be sorted in descending order.
		 */
		public function Sort(crit:*) {
			this.criteria = crit;
		}
		
		/**
		 * Sorts the input array according to the sort criteria.
		 * @param list an array to sort
		 */
		public function sort(list:Array):void
		{
			mergeSort(list, comparator, 0, list.length - 1);
		}
		
		// --------------------------------------------------------------------
		// Static Methods
		
		/**
		 * Default comparator function that compares two values based on blind
		 *  application of the less-than and greater-than operators.
		 * @param a the first value to compare
		 * @param b the second value to compare
		 * @return -1 if a &lt; b, 1 if a &gt; b, 0 otherwise.
		 */
		public static function defaultComparator(a:*, b:*):int {
			return a > b ? 1 : a < b ? -1 : 0;
		}
		
		private static function getComparator(cmp:*):Function
		{
			var c:Function;
			if (cmp is Function) {
				c = cmp as Function;
			} else if (cmp is Array) {
				c = $(cmp as Array);
			} else if (cmp == null) {
				c = defaultComparator;
			} else {
				throw new ArgumentError("Unknown parameter type: " + cmp);
			}
			return c;
		}
		
		
		/**
		 * Sorts an ArrayCollection by a specification given in 
		 * <code>sortParams</code>. 
		 * 
		 * @param ac An array collection to sort
		 * @param sortParams An array containing a set of data field names to 
		 * sort on in priority order. The default is to sort in ascending order. If the field name
		 * is prefixed by "-", the variable will be sorted in descending order.
		 */ 
		public static function sortArrayCollectionBy(ac:ArrayCollection, sortParams:Array):void {
			var sort:mx.collections.Sort = new mx.collections.Sort();
			sort.compareFunction = Sort.$(sortParams);
			ac.sort = sort;
			ac.refresh();
		}
		
		
		/**
		 * Creates a comparator function using the specification given
		 * by the input arguments. The resulting sorting function can be used
		 * to sort objects based on their properties.
		 * @param a A multi-parameter list or a single array containing a set
		 * of data field names to sort on, in priority order. The default is
		 * to sort in ascending order. If the field name includes a "-"
		 * (negative sign) prefix, that variable will instead be sorted in
		 * descending order.
		 * @return a comparison function for use in sorting objects.
		 */
		public static function $(...a):Function
		{
			if (a && a.length > 0 && a[0] is Array) a = a[0];
			if (a == null || a.length < 1)
				throw new ArgumentError("Bad input.");
			
			if (a.length == 1) {
				return sortOn(a[0]);
			} else {
				var sorts:Array = [];
				for each (var field:String in a) {
					sorts.push(sortOn(field));
				}
				return multisort(sorts);
			}
		}
		
		
		private static function multisort(f:Array):Function
		{
			// The fields parameter allows this to be used with 
			// ArrayCollection Sort.compareFunction
			// it is currently unused
			return function(a:Object, b:Object, fields:Array=null):int {
				var c:int;
				for (var i:uint = 0; i < f.length; ++i) {
					if ((c = f[i](a, b)) != 0) return c;
				}
				return 0;
			}
		}
		
		private static function sortOn(field:String):Function
		{
			var c:Number = field.charCodeAt(0);
			var asc:Boolean = (c == ASC || c != DSC);
			if (c == ASC || c == DSC) field = field.substring(1);
			
			// check for alphanum
			c = field.charCodeAt(0);
			var alphanum:Boolean = (c == ALPHANUM);
			if (alphanum) field = field.substring(1);
			
			var p:Property = Property.$(field);
			
			// The fields parameter allows this to be used with 
			// ArrayCollection Sort.compareFunction
			// it is currently unused
			if (alphanum) {
				return function(a:Object, b:Object, fields:Array=null):int {
					var da:* = p.getValue(a);
					var db:* = p.getValue(b);
					trace(da, db, alphanumCompare(da, db));
					return (asc ? 1 : -1) * alphanumCompare(da, db);
				}
			} else {
				return function(a:Object, b:Object, fields:Array=null):int {
					var da:* = p.getValue(a);
					var db:* = p.getValue(b);
					return (asc ? 1 : -1) * (da > db ? 1 : da < db ? -1 : 0);
				}
			}
		}

		
		// --------------------------------------------------------------------
		// alphanum sorting
		// --------------------------------------------------------------------	
				
		private static const ZERO_ASCII:Number = "0".charCodeAt(0);	// Decimal 48
		private static const NINE_ASCII:Number = "9".charCodeAt(0);	// Decimal 57
				
		/**
		 * @private
		 *
		 * Returns true if the charCode maps to the ASCII numeral character codes.
		 */
		private static function isDigit(chCode:Number):Boolean {
			return chCode >= ZERO_ASCII && chCode <= NINE_ASCII;
		}
		
		/**
		 * @private
		 *
		 * Transform a string into it numeric and alphabetic parts.
		 */
		private static function splitIntoAlphaOrNum(s:String):Array {
			var retVal:Array = new Array;
			
			const len:int = s.length;
			if (len > 0) {
				var accum:String = new String;
				var wasNum:Boolean = isDigit(s.charCodeAt(0));
				accum += s.charAt(0);
				for (var ix:int = 1; ix < len; ix++) {
					if (isDigit(s.charCodeAt(ix))) {
						if (wasNum) {
							// Continues to be numeric.
							accum += s.charAt(ix);
						}
						else {
							// Changed to numeric.
							wasNum = true;
							
							// Capture existing alphabetic.
							retVal.push(accum);
							
							// Start capturing numeric.
							accum = s.charAt(ix);
						}
					}
					else if (wasNum) {
						// Changed to alphabetic.
						wasNum = false;
						
						// Capture existing numeric.
						retVal.push(Number(accum));
						
						// Start capturing alphabetic.
						accum = s.charAt(ix);
					}
					else {
						// Continues to be alphabetic.
						accum += s.charAt(ix);
					}
				}
				
				// Capture remaining.
				if (wasNum) {
					retVal.push(Number(accum));
				}
				else {
					retVal.push(accum);
				}
			}
			
			return retVal;
		}
		
		// Use constants to document the obscure integral comparison return values.
		private static const BOTH_ARE_EQUIV:int = 0;
		private static const LEFT_IS_LESS_THAN_RIGHT:int = -1;
		private static const LEFT_IS_GREATER_THAN_RIGHT:int = 1;
		
		
		/**
		 * Public function intended to be used directly by sortable types such
		 * as <code>ICollectionView</code> or types that accept custom comparison
		 * functions (e.g., <code>DataGridColumn</code>).
		 *
		 * @see mx.collections.ICollectionView
		 * @see mx.controls.dataGridClasses.DataGridColumn
		 */
		public static function alphanumCompare(left:Object, right:Object, fields:Array=null):int {
			var retVal:int = BOTH_ARE_EQUIV;
			
			const ls:Array = splitIntoAlphaOrNum(left.toString());
			const rs:Array = splitIntoAlphaOrNum(right.toString());
			
			const partsN:int = ls.length;
			var ix:int = 0;
			var lPart:*, rPart:*;
			
			while ((retVal === BOTH_ARE_EQUIV) && (ix < partsN)) {
				lPart = ls[ix];
				rPart = rs[ix];
				
				if ((lPart is Number && rPart is Number)
					|| (lPart is String && rPart is String)) {
					// Handle the case were the left and right are both
					// the same type and are therefore comparable using
					// the built-in operators.
					if (lPart > rPart) {
						retVal = LEFT_IS_GREATER_THAN_RIGHT;
					}
					else if (lPart < rPart) {
						retVal = LEFT_IS_LESS_THAN_RIGHT;
					}
					else {
						retVal = BOTH_ARE_EQUIV;
					}
				}
				else if (!rPart) {
					retVal = LEFT_IS_GREATER_THAN_RIGHT;
				}
				else {
					// Handle the case were the left and right are
					// different types. Use the built-in String comparison.
					var lStr:String = lPart.toString();
					var rStr:String = rPart.toString();
					
					if (lStr > rStr) {
						retVal = LEFT_IS_GREATER_THAN_RIGHT;
					}
					else if (lStr < rStr) {
						retVal = LEFT_IS_LESS_THAN_RIGHT;
					}
					else {
						// Make an arbitrary decision that the left is
						// greater than the right since they cannot be equal
						// if they are different types.
						retVal = LEFT_IS_GREATER_THAN_RIGHT;
					}
				}
				
				ix++;
			}
			return retVal;
		}
		
		
		// --------------------------------------------------------------------
		// sorting
		// --------------------------------------------------------------------
		
		private static const SORT_THRESHOLD:int = 16;
		
		private static function insertionSort(a:Array, cmp:Function, p:int, r:int):void
		{
			var i:int, j:int, key:Object;
			for (j = p + 1; j <= r; ++j) {
				key = a[j];
				i = j - 1;
				while (i >= p && cmp(a[i], key) > 0) {
					a[i + 1] = a[i];
					i--;
				}
				a[i + 1] = key;
			}
		}
		
		private static function mergeSort(a:Array, cmp:Function, p:int, r:int):void
		{
			if (p >= r) {
				return;
			}
			if (r - p + 1 < SORT_THRESHOLD) {
				insertionSort(a, cmp, p, r);
			} else {
				var q:int = (p + r) / 2;
				mergeSort(a, cmp, p, q);
				mergeSort(a, cmp, q + 1, r);
				merge(a, cmp, p, q, r);
			}
		}
		
		private static function merge(a:Array, cmp:Function, p:int, q:int, r:int):void
		{
			var t:Array = new Array(r - p + 1);
			var i:int, p1:int = p, p2:int = q + 1;
			
			for (i = 0; p1 <= q && p2 <= r; ++i)
				t[i] = cmp(a[p2], a[p1]) > 0 ? a[p1++] : a[p2++];
			for (; p1 <= q; ++p1,++i)
				t[i] = a[p1];
			for (; p2 <= r; ++p2,++i)
				t[i] = a[p2];
			for (i = 0,p1 = p; i < t.length; ++i,++p1)
				a[p1] = t[i];
		}
		
	} // end of class Sort
}