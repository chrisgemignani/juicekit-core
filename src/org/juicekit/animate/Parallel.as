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

package org.juicekit.animate
{
	import org.juicekit.util.Arrays;
	
	/**
	 * Transition that runs multiple transitions simultaneously (in parallel).
	 * The duration of this parallel transition is computed as the maximum
	 * total duration (duration + delay) among the sub-transitions. If the
	 * duration is explicitly set, the sub-transition lengths will be
	 * uniformly scaled to fit within the new time span.
	 */
	public class Parallel extends Transition
	{
		// -- Properties ------------------------------------------------------
		
		/** Array of parallel transitions */
		protected var _trans:/*Transition*/Array = [];
		/** @private */
		protected var _equidur:Boolean;
		/** @private */
		protected var _dirty:Boolean = false;
		/** @private */
		protected var _autodur:Boolean = true;
		
		/**
		 * If true, the duration of this sequence is automatically determined
		 * by the longest sub-transition. This is the default behavior.
		 */
		public function get autoDuration():Boolean {
			return _autodur;
		}
		
		public function set autoDuration(b:Boolean):void {
			_autodur = b;
			computeDuration();
		}
		
		/** @inheritDoc */
		public override function get duration():Number {
			if (_dirty) computeDuration();
			return super.duration;
		}
		
		public override function set duration(dur:Number):void {
			_autodur = false;
			super.duration = dur;
			_dirty = true;
		}
		
		// -- Methods ---------------------------------------------------------
		
		/**
		 * Creates a new Parallel transition.
		 * @param transitions a list of sub-transitions
		 */
		public function Parallel(...transitions) {
			easing = Easing.none;
			for each (var t:Transition in transitions) {
				_trans.push(t);
			}
			_dirty = true;
		}
		
		/**
		 * Adds a new sub-transition to this parallel transition.
		 * @param t the transition to add
		 */
		public function add(t:Transition):void {
			if (running) throw new Error("Transition is running!");
			_trans.push(t);
			_dirty = true;
		}
		
		/**
		 * Removes a sub-transition from this parallel transition.
		 * @param t the transition to remove
		 * @return true if the transition was found and removed, false
		 *  otherwise
		 */
		public function remove(t:Transition):Boolean {
			if (running) throw new Error("Transition is running!");
			var rem:Boolean = Arrays.remove(_trans, t) >= 0;
			if (rem) _dirty = true;
			return rem;
		}
		
		/**
		 * Staggers the start of each sub-transition by a given interval. This
		 * method will overwrite the delay settings for each sub-transition.
		 * @param delay the delay between the start of each sub-transition.
		 * @param reverse if true, staggering will be applied in the reverse
		 *  order in which sub-transitions were added.
		 * @return returns this parallel transition
		 */
		public function stagger(delay:Number = 0.05, reverse:Boolean = false):Parallel
		{
			var d:Number = 0, i:uint = 0;
			if (reverse) {
				for (i = _trans.length; --i >= 0;) {
					_trans[i].delay = d;
					d += delay;
				}
			} else {
				for each (var t:Transition in _trans) {
					t.delay = d;
					d += delay;
				}
			}
			_dirty = true;
			return this;
		}
		
		/**
		 * Computes the duration of this parallel transition.
		 */
		protected function computeDuration():void {
			var d:Number = 0, td:Number;
			if (_trans.length > 0) d = _trans[0].totalDuration;
			_equidur = true;
			for each (var t:Transition in _trans) {
				td = t.totalDuration;
				if (_equidur && td != d) _equidur = false;
				d = Math.max(d, t.totalDuration);
			}
			if (_autodur) super.duration = d;
			_dirty = false;
		}
		
		/** @inheritDoc */
		public override function dispose():void {
			while (_trans.length > 0) {
				_trans.pop().dispose();
			}
		}
		
		// -- Transition Handlers ---------------------------------------------
		
		/** @inheritDoc */
		public override function play(reverse:Boolean = false):void
		{
			if (_dirty) computeDuration();
			super.play(reverse);
		}
		
		/**
		 * Sets up each sub-transition.
		 */
		protected override function setup():void
		{
			for each (var t:Transition in _trans) {
				t.doSetup();
			}
		}
		
		/**
		 * Starts each sub-transition.
		 */
		protected override function start():void
		{
			for each (var t:Transition in _trans) {
				t.doStart(_reverse);
			}
		}
		
		/**
		 * Steps each sub-transition.
		 * @param ef the current progress fraction.
		 */
		internal override function step(ef:Number):void
		{
			var t:Transition;
			if (_equidur) {
				// if all durations are the same, we can skip some calculations
				for each (t in _trans) {
					t.doStep(ef);
				}
			} else {
				// otherwise, make sure we respect the different lengths
				var d:Number = duration;
				for each (t in _trans) {
					var td:Number = t.totalDuration;
					var f:Number = d == 0 || td == d ? 1 : td / d;
					t.doStep(ef > f ? 1 : f == 1 ? ef : ef / f);
				}
			}
		}
		
		/**
		 * Ends each sub-transition.
		 */
		protected override function end():void
		{
			for each (var t:Transition in _trans) {
				t.doEnd();
			}
		}
		
	} // end of class Parallel
}