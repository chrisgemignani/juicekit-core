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
import flash.display.DisplayObject;

import org.juicekit.animate.interpolate.Interpolator;
import org.juicekit.util.Property;

/**
 * Transition that interpolates (in-be<em>tweens</em>) properties
 * of a target object over a time interval. The <tt>values</tt> property
 * represents the set of properties to tween and their final values. Any
 * arbitrary property (not just visual properties) can be tweened. The
 * Tween class handles tweening of Numbers, colors, Dates, Points,
 * Rectangles, and numeric Arrays. Properties of other types are simply
 * swapped when then Transition half-completes. Tweening for custom types
 * is possible, see the <tt>flare.animate.interpolate.Interpolator</tt>
 * class for more.
 *
 * <p>Starting values are automatically determined from the tweened object.
 * Once determined, these starting values are stored to allow both forward
 * and backward playback. Use the <tt>reset</tt> method to force a tween to
 * redetermine the starting values the next time it is played. Tweens also
 * provide a <code>remove</code> flag for DisplayObjects. When set to true,
 * a display object will be removed from the display list at the end of the
 * tween. Note that playing the tween is reverse will not revert this
 * removal.</p>
 *
 * <p>Internally, a Tween creates a set of Interpolator objects to compute
 * intermediate values for each property included in <tt>values</tt>. Note
 * that property names can involve nested properties. For example,
 * <tt>{"filters[0].blurX":5}</tt> is a valid tweening property, as both
 * array access (<tt>[]</tt>) and property access (<tt>.</tt>) syntax are
 * supported.</p>
 *
 * <p>To manage a collection of objects being tweened simultaneously, use a
 * <tt>Transitioner</tt> object.</p>
 */
public class Tween extends Transition
{
  // -- Properties ------------------------------------------------------

  private var _interps:Array = new Array();
  private var _target:Object;
  private var _from:Object;
  private var _remove:Boolean = false;
  private var _visible:Object = null;
  private var _values:Object;

  /** The target object whose properties are tweened. */
  public function get target():Object {
    return _target;
  }

  public function set target(t:Object):void {
    _target = t;
  }

  /** Flag indicating if the target object should be removed from the
   *  display list at the end of the tween. Only applies when the target
   *  is a <code>DisplayObject</code>. */
  public function get remove():Boolean {
    return _remove;
  }

  public function set remove(b:Boolean):void {
    _remove = b;
  }

  /** The properties to tween and their target values. */
  public function get values():Object {
    return _values;
  }

  public function set values(o:Object):void {
    _values = o;
  }

  /** Optional starting values for tweened properties. */
  public function get from():Object {
    return _from;
  }

  public function set from(s:Object):void {
    _from = s;
  }


  // - Methods ----------------------------------------------------------

  /**
   * Creates a new Tween with the specified parameters.
   * @param target the target object
   * @param duration the duration of the tween, in seconds
   * @param values the properties to tween and their target values
   * @param remove a display list removal flag (for
   *  <code>DisplayObject</code> target objects
   * @param easing the easing function to use
   */
  public function Tween(target:Object, duration:Number = 1,
                        values:Object = null, remove:Boolean = false, easing:Function = null)
  {
    super(duration, 0, easing);

    _target = target;
    _remove = remove;
    _values = values == null ? {} : values;
    _from = {};
  }

  /** @inheritDoc */
  public override function dispose():void
  {
    // reclaim any old interpolators
    while (_interps.length > 0) {
      Interpolator.reclaim(_interps.pop());
    }
    // remove all target values
    for (var name:String in _values) {
      delete _values[name];
    }
    _visible = null;
    _remove = false;
    _target = null;
  }

  /**
   * Sets up this tween by creating interpolators for each tweened
   * property.
   */
  protected override function setup():void
  {
    // reclaim any old interpolators
    while (_interps.length > 0) {
      Interpolator.reclaim(_interps.pop());
    }

    // build interpolators
    var vc:Object, v0:Object, v1:Object;
    for (var name:String in _values) {
      // create interpolator only if start/cur/end values don't match
      vc = Property.$(name).getValue(_target);
      v0 = _from.hasOwnProperty(name) ? _from[name] : vc;
      v1 = _values[name];

      if (vc != v1 || vc != v0) {
        if (name == "visible") {
          // special handling for visibility
          _visible = Boolean(v1);
        } else {
          _interps.push(Interpolator.create(_target, name, v0, v1));
        }
      }
    }
  }

  /**
   * Updates target object visibility, if appropriate.
   */
  protected override function start():void
  {
    // set visibility
    var item:DisplayObject = _target as DisplayObject;
    if (item != null && Boolean(_visible))
      item.visible = true;
  }

  /**
   * Steps the tween, updating the tweened properties.
   */
  internal override function step(ef:Number):void
  {
    // run the interpolators
    for each (var i:Interpolator in _interps) {
      i.interpolate(ef);
    }
  }

  /**
   * Ends the tween, updating target object visibility and display
   * list membership, if appropriate.
   */
  protected override function end():void
  {
    // set visibility, remove from display list if requested
    var item:DisplayObject = _target as DisplayObject;
    if (item != null) {
      if (_remove && item.parent != null)
        item.parent.removeChild(item);
      if (_visible != null)
        item.visible = Boolean(_visible);
    }
  }

} // end of class Tween
}