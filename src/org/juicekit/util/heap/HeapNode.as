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

package org.juicekit.util.heap
{
	/**
	 * A node in a heap data structure.
	 * For use with the <code>FibonacciHeap</code> class.
	 * @see flare.analytics.util.FibonacciHeap
	 */
	public class HeapNode
	{
		/** Arbitrary client data property to store with the node. */
		public var data:*;
		/** The parent node of this node. */
		public var parent:HeapNode;
		/** A child node of this node. */
		public var child:HeapNode;
		/** The right child node of this node. */
		public var right:HeapNode;
		/** The left child node of this node. */
		public var left:HeapNode;
		/** Boolean flag useful for marking this node. */
		public var mark:Boolean;
		/** Flag indicating if this node is currently in a heap. */
		public var inHeap:Boolean = true;
		/** Key value used for sorting the heap nodes. */
		public var key:Number;
		/** The degree of this heap node (number of child nodes). */
		public var degree:int;
		
		/**
		 * Creates a new HeapNode
		 * @param data arbitrary data to store with this node
		 * @param key the key value to sort on
		 */
		function HeapNode(data:*, key:Number)
		{
			this.data = data;
			this.key = key;
			right = this;
			left = this;
		}
	} // end of class HeapNode
}