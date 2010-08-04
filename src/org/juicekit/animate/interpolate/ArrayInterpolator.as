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

package org.juicekit.animate.interpolate {
import org.juicekit.util.Arrays;

/**
 * Interpolator for numeric <code>Array</code> values. Each value
 * contained in the array should be a numeric (<code>Number</code> or
 * <code>int</code>) value.
 */
public class ArrayInterpolator extends Interpolator {
    private var _start:Array;
    private var _end:Array;
    private var _cur:Array;

    /**
     * Creates a new ArrayInterpolator.
     * @param target the object whose property is being interpolated
     * @param property the property to interpolate
     * @param start the starting array of values to interpolate from
     * @param end the target array to interpolate to. This should be an
     *  array of numerical values.
     */
    public function ArrayInterpolator(target:Object, property:String,
                                      start:Object, end:Object) {
        super(target, property, start, end);
    }

    /**
     * Initializes this interpolator.
     * @param start the starting value of the interpolation
     * @param end the target value of the interpolation
     */
    protected override function init(start:Object, end:Object):void {
        _end = end as Array;
        if (!end) throw new Error("Target array is null!");
        if (_start && _start.length != _end.length) _start = null;
        _start = Arrays.copy(start as Array, _start);

        if (_start.length != _end.length)
            throw new Error("Array dimensions don't match");

        var cur:Array = _prop.getValue(_target) as Array;
        if (cur == end) cur = null;
        _cur = Arrays.copy(_start, cur);
    }

    /**
     * Calculate and set an interpolated property value.
     * @param f the interpolation fraction (typically between 0 and 1)
     */
    public override function interpolate(f:Number):void {
        for (var i:uint = 0; i < _cur.length; ++i) {
            _cur[i] = _start[i] + f * (_end[i] - _start[i]);
        }
        _prop.setValue(_target, _cur);
    }

} // end of class ArrayInterpolator
}