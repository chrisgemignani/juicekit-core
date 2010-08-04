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
 * Interpolator for color (<code>uint</code>) values.
 */
public class ColorInterpolator extends Interpolator {
    private var _start:uint;
    private var _end:uint;

    /**
     * Creates a new ColorInterpolator.
     * @param target the object whose property is being interpolated
     * @param property the property to interpolate
     * @param start the starting color value to interpolate from
     * @param end the target color value to interpolate to
     */
    public function ColorInterpolator(target:Object, property:String,
                                      start:Object, end:Object) {
        super(target, property, start, end);
    }

    /**
     * Initializes this interpolator.
     * @param start the starting value of the interpolation
     * @param end the target value of the interpolation
     */
    protected override function init(start:Object, end:Object):void {
        _start = uint(start);
        _end = uint(end);
    }

    /**
     * Calculate and set an interpolated property value.
     * @param f the interpolation fraction (typically between 0 and 1)
     */
    public override function interpolate(f:Number):void {
        // we'll do all the work here to avoid the overhead of
        //  extra method calls (rather than call Colors.interpolate)
        var a1:uint, a2:uint, r1:uint, r2:uint,
                g1:uint, g2:uint, b1:uint, b2:uint;

        // get color components
        a1 = (_start >> 24) & 0xFF;
        a2 = (_end >> 24) & 0xFF;
        r1 = (_start >> 16) & 0xFF;
        r2 = (_end >> 16) & 0xFF;
        g1 = (_start >> 8) & 0xFF;
        g2 = (_end >> 8) & 0xFF;
        b1 = _start & 0xff;
        b2 = _end & 0xFF;

        // interpolate the color components
        a1 += f * (a2 - a1);
        r1 += f * (r2 - r1);
        g1 += f * (g2 - g1);
        b1 += f * (b2 - b1);

        // recombine into final color
        a1 = ((a1 & 0xFF) << 24) | ((r1 & 0xFF) << 16) |
                ((g1 & 0xFF) << 8) | (b1 & 0xFF);

        // update the property value
        _prop.setValue(_target, a1);
    }

} // end of class ColorInterpolator
}