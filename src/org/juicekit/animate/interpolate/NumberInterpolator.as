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
/**
 * Interpolator for <code>Number</code> and <code>int</code> values.
 */
public class NumberInterpolator extends Interpolator {
    private var _start:Number;
    private var _end:Number;

    /**
     * Creates a new NumberInterpolator.
     * @param target the object whose property is being interpolated
     * @param property the property to interpolate
     * @param start the starting number to interpolate from
     * @param end the target number to interpolate to
     */
    public function NumberInterpolator(target:Object, property:String,
                                       start:Object, end:Object) {
        super(target, property, start, end);
    }

    /**
     * Initializes this interpolator.
     * @param start the starting value of the interpolation
     * @param end the target value of the interpolation
     */
    protected override function init(start:Object, end:Object):void {
        _start = Number(start);
        _end = Number(end);
        if (isNaN(_start)) _start = _end;
        _end = _end - _start;
    }

    /**
     * Calculate and set an interpolated property value.
     * @param f the interpolation fraction (typically between 0 and 1)
     */
    public override function interpolate(f:Number):void {
        _prop.setValue(_target, _start + f * _end);
    }

} // end of class NumberInterpolator
}