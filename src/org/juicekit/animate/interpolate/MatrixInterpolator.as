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
import flash.geom.Matrix;

/**
 * Interpolator for <code>flash.geom.Matrix</code> values.
 */
public class MatrixInterpolator extends Interpolator {
    private var _startA:Number, _startB:Number, _startC:Number;
    private var _startD:Number, _startX:Number, _startY:Number;
    private var _rangeA:Number, _rangeB:Number, _rangeC:Number;
    private var _rangeD:Number, _rangeX:Number, _rangeY:Number;
    private var _cur:Matrix;

    /**
     * Creates a new MatrixInterpolator.
     * @param target the object whose property is being interpolated
     * @param property the property to interpolate
     * @param start the starting matrix value to interpolate from
     * @param end the target matrix value to interpolate to
     */
    public function MatrixInterpolator(target:Object, property:String,
                                       start:Object, end:Object) {
        super(target, property, start, end);
    }

    /**
     * Initializes this interpolator.
     * @param start the starting value of the interpolation
     * @param end the target value of the interpolation
     */
    protected override function init(start:Object, end:Object):void {
        var e:Matrix = Matrix(end), s:Matrix = Matrix(start);
        _cur = _prop.getValue(_target) as Matrix;
        if (_cur == null || _cur == s || _cur == e)
            _cur = e.clone();

        _startA = s.a;
        _startB = s.b;
        _startC = s.c;
        _startD = s.d;
        _startX = s.tx;
        _startY = s.ty;
        _rangeA = e.a - _startA;
        _rangeB = e.b - _startB;
        _rangeC = e.c - _startC;
        _rangeD = e.d - _startD;
        _rangeX = e.tx - _startX;
        _rangeY = e.ty - _startY;
    }

    /**
     * Calculate and set an interpolated property value.
     * @param f the interpolation fraction (typically between 0 and 1)
     */
    public override function interpolate(f:Number):void {
        _cur.a = _startA + f * _rangeA;
        _cur.b = _startB + f * _rangeB;
        _cur.c = _startC + f * _rangeC;
        _cur.d = _startD + f * _rangeD;
        _cur.tx = _startX + f * _rangeX;
        _cur.ty = _startY + f * _rangeY;
        _prop.setValue(_target, _cur);
    }

} // end of class MatrixInterpolator
}