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

package org.juicekit.animate {
/**
 * Collection of easing functions to control animation rates.
 * The methods of this class are intended to be used either (a) directly as
 * values for the <tt>easing</tt> property of <tt>Transition</tt> instances,
 * or (b) to generate such easing functions.
 *
 * <p>Many of these easing functions are adapted from Robert Penner's
 * <a href="http://www.robertpenner.com/">collection of easing functions</a>.
 * </p>
 */
public class Easing {
    /**
     * Constructor, throws an error if called, as this is an abstract class.
     */
    public function Easing() {
        throw new Error("This is an abstract class.");
    }

    // -- Function Generators ---------------------------------------------

    /**
     * Composes any easeIn function with any easeOut function to create a
     * custom ease-in/ease-out transition.
     * @param fi an ease-in function
     * @param fo an ease-out function
     * @return the combined ease-in/ease-out function
     */
    public static function easeInOut(fi:Function, fo:Function):Function {
        return function(t:Number):Number {
            if (t < 0.5) return 0.5 * fi(2 * t);
            return 0.5 * (1 + fo(2 * t - 1));
        }
    }

    /**
     * A wrapper that specifies additional arguments to an easing function,
     * such that the resulting function can be called with only the time.
     * @param f The easing function to wrap
     * @param arg A list of arguments. There should only be 1 or 2 arguments.
     */
    public static function delegate(f:Function, ...args):Function {
        if (args.length == 0 || args.length > 2)
            throw new ArgumentError("There should only be 1 or 2 extra arguments");

        return function(t:Number):Number {
            if (args.length == 1) return f(t, args[0]);
            return f(t, args[0], args[1]);
        };
    }

    /**
     * Easing equation function generator for polynomial easing in: accelerating from zero velocity.
     *
     * @param exp   The exponent of the polynomial (2 for quadration, 3 for cubic, etc)
     * @return    An ease-in function using the polynomial x^exp
     */
    public static function easeInPoly(exp:Number):Function {
        return function(t:Number):Number {
            if (t < 0)  return 0;
            if (t > 1)  return 1;
            else return Math.pow(t, exp);
        }
    }

    /**
     * Easing equation function generator for polynomial easing out: decelerating from zero velocity.
     *
     * @param exp   The exponent of the polynomial (2 for quadration, 3 for cubic, etc)
     * @return    An ease-out function using the polynomial x^exp
     */
    public static function easeOutPoly(exp:Number):Function {
        return function(t:Number):Number {
            if (t < 0)  return 0;
            if (t > 1)  return 1;
            else return 1 - Math.pow(1 - t, exp);
        }
    }

    /**
     * Easing equation function generator for polynomial easing in/out: acceleration until halfway, then deceleration.
     *
     * @param exp   The exponent of the polynomial (2 for quadration, 3 for cubic, etc)
     * @return    An ease-in, ease-out function using the polynomial x^exp
     */
    public static function easeInOutPoly(exp:Number):Function {
        // Optimized with a static lookup
        // for the default transitioner animation
        // as this is the default easer
        const poly3Lookup:Array = [0.000,0.000,0.000,0.000,0.000,0.000,0.001,0.002,0.002,0.004,0.005,0.006,0.008,0.011,0.013,0.016,0.019,0.023,0.027,0.032,0.037,0.042,0.048,0.055,0.062,0.070,0.078,0.087,0.097,0.108,0.119,0.131,0.143,0.157,0.171,0.186,0.202,0.219,0.237,0.256,0.275,0.296,0.318,0.340,0.364,0.389,0.415,0.442,0.470,0.500,0.529,0.557,0.584,0.610,0.635,0.659,0.682,0.703,0.724,0.744,0.762,0.780,0.797,0.813,0.828,0.842,0.856,0.868,0.880,0.892,0.902,0.912,0.921,0.929,0.937,0.944,0.951,0.957,0.963,0.968,0.972,0.976,0.980,0.983,0.986,0.989,0.991,0.993,0.994,0.996,0.997,0.998,0.998,0.999,0.999,0.999,0.999,1.000,1.000,1.000];
        if (exp == 3) {
            return function(t:Number):Number {
                if (t < 0.05)  return 0;
                if (t > 0.95)  return 1;
                return poly3Lookup[int(t * 100)];
            }
        } else {
            return function(t:Number):Number {
                if (t < 0)  return 0;
                if (t > 1)  return 1;
                if (t < .5) return 0.5 * Math.pow(2 * t, exp);
                else        return 0.5 * (2 - Math.pow(2 * (1 - t), exp));
            }
        }
    }


    /**
     * Easing equation function generator for polynomial easing out/in: deceleration until halfway, then acceleration.
     *
     * @param exp   The exponent of the polynomial (2 for quadration, 3 for cubic, etc)
     * @return    An ease-out, ease-in function using the polynomial x^exp
     */
    public static function easeOutInPoly(exp:Number):Function {
        var fi:Function = easeInPoly(exp);
        var fo:Function = easeOutPoly(exp);
        return function(t:Number):Number {
            if (t < 0.5) return fo(2 * t) / 2;
            else return 0.5 * (1 + fi(2 * t - 1));
        }
    }


    // -- Static Functions ------------------------------------------------

    /**
     * Easing equation that does nothing, simply returns the input value.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function none(t:Number):Number {
        return t;
    }

    /**
     * Easing equation function for a sinusoidal (sin(t)) easing in: accelerating from zero velocity.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeInSine(t:Number):Number {
        return 1 - Math.cos(t * (Math.PI / 2));
    }

    /**
     * Easing equation function for a sinusoidal (sin(t)) easing out: decelerating from zero velocity.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeOutSine(t:Number):Number {
        return Math.sin(t * (Math.PI / 2));
    }

    /**
     * Easing equation function for a sinusoidal (sin(t)) easing in/out: acceleration until halfway, then deceleration.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeInOutSine(t:Number):Number {
        return -0.5 * (Math.cos(Math.PI * t) - 1);
    }

    /**
     * Easing equation function for a sinusoidal (sin(t)) easing out/in: deceleration until halfway, then acceleration.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeOutInSine(t:Number):Number {
        if (t < 0.5) return easeOutSine(t * 2);
        return easeInSine((t * 2) - 1);
    }

    /**
     * Easing equation function for an exponential (2^t) easing in: accelerating from zero velocity.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeInExpo(t:Number):Number {
        return t == 0 ? t : Math.pow(2, 10 * (t - 1)) - 0.001;
    }

    /**
     * Easing equation function for an exponential (2^t) easing out: decelerating from zero velocity.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeOutExpo(t:Number):Number {
        return (t == 1) ? t : 1.001 * (-Math.pow(2, -10 * t) + 1);
    }

    /**
     * Easing equation function for an exponential (2^t) easing in/out: acceleration until halfway, then deceleration.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeInOutExpo(t:Number):Number {
        if (t == 0 || t == 1) return t;
        if (t < 0.5) return 0.5 * Math.pow(2, 10 * (2 * t - 1)) - 0.0005;
        return 0.5 * 1.0005 * (-Math.pow(2, -10 * (2 * t - 1)) + 2);
    }

    /**
     * Easing equation function for an exponential (2^t) easing out/in: deceleration until halfway, then acceleration.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeOutInExpo(t:Number):Number {
        if (t < 0.5) return 0.5 * easeOutExpo(2 * t);
        return 0.5 * (1 + easeInExpo(2 * t - 1));
    }

    /**
     * Easing equation function for a circular (sqrt(1-t^2)) easing in: accelerating from zero velocity.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeInCirc(t:Number):Number {
        return -(Math.sqrt(1 - t * t) - 1);
    }

    /**
     * Easing equation function for a circular (sqrt(1-t^2)) easing out: decelerating from zero velocity.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeOutCirc(t:Number):Number {
        return Math.sqrt(1 - (t = t - 1) * t);
    }

    /**
     * Easing equation function for a circular (sqrt(1-t^2)) easing in/out: acceleration until halfway, then deceleration.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeInOutCirc(t:Number):Number {
        if (t < 0.5) return -0.5 * (Math.sqrt(1 - 4 * t * t) - 1);
        return 0.5 * (Math.sqrt(1 - (t = 2 * t - 2) * t) + 1);
    }

    /**
     * Easing equation function for a circular (sqrt(1-t^2)) easing out/in: deceleration until halfway, then acceleration.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeOutInCirc(t:Number):Number {
        if (t < 0.5) return easeOutCirc(2 * t);
        return 0.5 * (1 + easeInCirc(2 * t - 1));
    }

    /**
     * Easing equation function for an elastic (exponentially decaying sine wave) easing in: accelerating from zero velocity.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @param a    Amplitude.
     * @param p    Period.
     * @return    The correct value.
     */
    public static function easeInElastic(t:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
        if (t <= 0 || t >= 1) return t;
        if (!p) p = 0.45;
        var s:Number;
        if (!a || a < Math.abs(1)) {
            a = 1;
            s = p / 4;
        }
        else s = p / (2 * Math.PI) * Math.asin(1 / a);
        return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t - s) * (2 * Math.PI) / p));
    }

    /**
     * Easing equation function for an elastic (exponentially decaying sine wave) easing out: decelerating from zero velocity.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @param a    Amplitude.
     * @param p    Period.
     * @return    The correct value.
     */
    public static function easeOutElastic(t:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
        return 1 - easeInElastic(1 - t, a, p);
    }

    /**
     * Easing equation function for an elastic (exponentially decaying sine wave) easing in/out: acceleration until halfway, then deceleration.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @param a    Amplitude.
     * @param p    Period.
     * @return    The correct value.
     */
    public static function easeInOutElastic(t:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
        if (t < 0.5) return 0.5 * easeInElastic(2 * t, a, p);
        return 0.5 * (1 + easeOutElastic(2 * t - 1, a, p));
    }

    /**
     * Easing equation function for an elastic (exponentially decaying sine wave) easing out/in: deceleration until halfway, then acceleration.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @param a    Amplitude.
     * @param p    Period.
     * @return    The correct value.
     */
    public static function easeOutInElastic(t:Number, a:Number = Number.NaN, p:Number = Number.NaN):Number {
        if (t < 0.5) return 0.5 * easeOutElastic(2 * t, a, p);
        return 0.5 * (1 + easeInElastic(2 * t - 1, a, p));
    }

    /**
     * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in: accelerating from zero velocity.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @param s    Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
     * @return    The correct value.
     */
    public static function easeInBack(t:Number, s:Number = Number.NaN):Number {
        if (!s) s = 1.70158;
        return t * t * ((s + 1) * t - s);
    }

    /**
     * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing out: decelerating from zero velocity.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @param s    Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
     * @return    The correct value.
     */
    public static function easeOutBack(t:Number, s:Number = Number.NaN):Number {
        if (!s) s = 1.70158;
        return 1 - (t = 1 - t) * t * ((s + 1) * t - s);
    }

    /**
     * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in/out: acceleration until halfway, then deceleration.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @param s    Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
     * @return    The correct value.
     */
    public static function easeInOutBack(t:Number, s:Number = Number.NaN):Number {
        if (!s) s = 1.70158 * 1.525;
        if (t < 0.5) return 0.5 * easeInBack(2 * t, s);
        return 0.5 * (1 + easeOutBack(2 * t - 1, s));
    }

    /**
     * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing out/in: deceleration until halfway, then acceleration.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @param s    Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
     * @return    The correct value.
     */
    public static function easeOutInBack(t:Number, s:Number = Number.NaN):Number {
        if (!s) s = 1.70158 * 1.525;
        if (t < 0.5) return 0.5 * easeOutBack(2 * t, s);
        return 0.5 * (1 + easeInBack(2 * t - 1, s));
    }

    /**
     * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing in: accelerating from zero velocity.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeInBounce(t:Number):Number {
        return 1 - easeOutBounce(1 - t);
    }

    /**
     * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing out: decelerating from zero velocity.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeOutBounce(t:Number):Number {
        if (t < (1 / 2.75)) {
            return 7.5625 * t * t;
        } else if (t < (2 / 2.75)) {
            return (7.5625 * (t -= (1.5 / 2.75)) * t + .75);
        } else if (t < (2.5 / 2.75)) {
            return (7.5625 * (t -= (2.25 / 2.75)) * t + .9375);
        } else {
            return (7.5625 * (t -= (2.625 / 2.75)) * t + .984375);
        }
    }

    /**
     * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing in/out: acceleration until halfway, then deceleration.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeInOutBounce(t:Number):Number {
        if (t < 0.5) return 0.5 * easeInBounce(2 * t);
        return 0.5 * (1 + easeOutBounce(2 * t - 1));
    }

    /**
     * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing out/in: deceleration until halfway, then acceleration.
     *
     * @param t    Current time (an animation fraction between 0 and 1).
     * @return    The correct value.
     */
    public static function easeOutInBounce(t:Number):Number {
        if (t < 0.5) return 0.5 * easeOutBounce(2 * t);
        return 0.5 * (1 + easeInBounce(2 * t - 1));
    }

} // end of class Easing
}