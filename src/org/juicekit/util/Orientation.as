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
	/**
	 * Constants defining layout orientations.
	 */
	public class Orientation
	{
		/** Constant indicating a left-to-right layout orientation. */
		public static const LEFT_TO_RIGHT:String = "leftToRight";
		/** Constant indicating a right-to-left layout orientation. */
		public static const RIGHT_TO_LEFT:String = "rightToLeft";
		/** Constant indicating a top-to-bottom layout orientation. */
		public static const TOP_TO_BOTTOM:String = "topToBottom";
		/** Constant indicating a bottom-to-top layout orientation. */
		public static const BOTTOM_TO_TOP:String = "bottomToTop";
		
		/** Constant indicating a vertical layout orientation. */
		public static const VERTICAL:String = "vertical";
		/** Constant indicating a horizontal layout orientation. */
		public static const HORIZONTAL:String = "horizontal";
		/** Constant indicating an up layout orientation. */
		public static const UP:String = "up";
		/** Constant indicating an up layout orientation. */
		public static const DOWN:String = "down";
		/** Constant indicating an up layout orientation. */
		public static const RIGHT:String = "right";
		/** Constant indicating an up layout orientation. */
		public static const LEFT:String = "left";
		
		/**
		 * This is an abstract class and can not be instantiated.
		 */
		public function Orientation() {
			throw new Error("This is an abstract class.");
		}
		
		/**
		 * Returns true if the input string indicates a vertical orientation.
		 * @param an orientation string
		 * @return true if the input string indicates a vertical orientation
		 */
		public static function isVertical(orient:String):Boolean
		{
			return (orient == TOP_TO_BOTTOM || orient == BOTTOM_TO_TOP || orient == VERTICAL || orient == UP || orient == DOWN);
		}
		
		/**
		 * Returns true if the input string indicates a horizontal orientation.
		 * @param an orientation string
		 * @return true if the input string indicates a horizontal orientation
		 */
		public static function isHorizontal(orient:String):Boolean
		{
			return (orient == LEFT_TO_RIGHT || orient == RIGHT_TO_LEFT || orient == HORIZONTAL || orient == LEFT || orient == RIGHT);
		}
		
	} // end of class Orientation
}