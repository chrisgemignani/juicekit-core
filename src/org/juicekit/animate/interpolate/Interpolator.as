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
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import org.juicekit.util.Property;

/**
 * Base class for value interpolators. This class also provides factory
 * methods for creating concrete interpolator instances -- see the
 * <code>create</code> method for details about interpolator creation.
 */
public class Interpolator {
    /** The target object whose property is being interpolated. */
    protected var _target:Object;
    /** The property to interpolate. */
    protected var _prop:Property;
    /** Is the property a CSS style */
    protected var _isStyle:Boolean = false;

    /**
     * Base constructor for Interpolator instances.
     * @param target the object whose property is being interpolated
     * @param property the property to interpolate
     * @param value the target value of the interpolation
     */
    public function Interpolator(target:Object, property:String,
                                 start:Object, end:Object) {
        reset(target, property, start, end);
    }

    /**
     * Re-initializes an exising interpolator instance.
     * @param target the object whose property is being interpolated
     * @param property the property to interpolate
     * @param value the target value of the interpolation
     */
    public function reset(target:Object, property:String,
                          start:Object, end:Object):void {
        _target = target;
        _prop = Property.$(property);
        init(start, end);
    }

    /**
     * Performs initialization of an interpolator, typically by
     * initializing the start and ending values. Subclasses should
     * override this method for custom initialization.
     * @param value the target value of the interpolation
     */
    protected function init(start:Object, end:Object):void {
        // for subclasses to override
    }

    /**
     * Calculate and set an interpolated property value. Subclasses should
     * override this method to implement custom interpolation routines.
     * @param f the interpolation fraction (typically between 0 and 1)
     */
    public function interpolate(f:Number):void {
        throw new Error("This is an abstract method");
    }

    // -- Interpolator Factory --------------------------------------------

    private static var _maxPoolSize:int = 10000;
    private static var _pools:Object = [];
    private static var _lookup:Object = buildLookupTable();
    private static var _rules:Array = buildRules();

    private static function buildLookupTable():Object {
        // add variables to ensure classes are included by compiler
        var ni:NumberInterpolator;
        var di:DateInterpolator;
        var pi:PointInterpolator;
        var ri:RectangleInterpolator;
        var mi:MatrixInterpolator;
        var ai:ArrayInterpolator;
        var ci:ColorInterpolator;
        var oi:ObjectInterpolator;

        // build the value->interpolator lookup table
        var lut:Object = new Object();
        lut["Number"] = "org.juicekit.animate.interpolate::NumberInterpolator";
        lut["int"] = "org.juicekit.animate.interpolate::NumberInterpolator";
        lut["Date"] = "org.juicekit.animate.interpolate::DateInterpolator";
        lut["Array"] = "org.juicekit.animate.interpolate::ArrayInterpolator";
        lut["flash.geom::Point"] = "org.juicekit.animate.interpolate::PointInterpolator";
        lut["flash.geom::Rectangle"] = "org.juicekit.animate.interpolate::RectangleInterpolator";
        lut["flash.geom::Matrix"] = "org.juicekit.animate.interpolate::MatrixInterpolator";
        return lut;
    }

    private static function buildRules():Array {
        var rules:Array = new Array();
        rules.push(isColor);
        return rules;
    }

    private static function isColor(target:Object, property:String, s:Object, e:Object)
            :String {
        return property.indexOf("Color") >= 0 || property.indexOf("color") >= 0
                ? "org.juicekit.animate.interpolate::ColorInterpolator"
                : null;
    }

    /**
     * Extends the interpolator factory with a new interpolator type.
     * @param valueType the fully qualified class name for the object type
     *  to interpolate
     * @param interpType the fully qualified class name for the
     *  interpolator class type
     */
    public static function addInterpolatorType(valueType:String, interpType:String):void {
        _lookup[valueType] = interpType;
    }

    /**
     * Clears the lookup table of interpolator types, removing all
     * type to interpolator mappings.
     */
    public static function clearInterpolatorTypes():void {
        _lookup = new Object();
    }

    /**
     * Adds a rule to the interpolator factory. The input function should
     * take 4 arguments -- a target object, property name string, a
     * starting value, and a target value -- and either return a fully
     * qualified class name for the type of interpolator to use, or null if
     * this rule does not apply.
     * @param f the rule function for supplying custom interpolator types
     *  based on contextual conditions
     */
    public static function addInterpolatorRule(f:Function):void {
        _rules.push(f);
    }

    /**
     * Clears all interpolator rule functions from the interpolator
     * factory.
     */
    public static function clearInterpolatorRules():void {
        _rules = new Array();
    }

    /**
     * Returns a new interpolator instance for the given target object,
     * property name, and interpolation target value. This factory method
     * follows these steps to provide an interpolator instance:
     * <ol>
     *  <li>The list of installed interpolator rules is consulted, and if a
     *      rule returns a non-null class name string, an interpolator of
     *      that type will be returned.</li>
     *  <li>If all rules return null values, then the class type of the
     *      interpolation value is used to look up the appropriate
     *      interpolator type for that value. If a matching interpolator
     *      type is found, an interpolator is initialized and returned.
     *      </li>
     *  <li>If no matching type is found, a default ObjectInterpolator
     *      instance is initialized and returned.</li>
     * </ol>
     *
     * <p>By default, the interpolator factory contains two rules. The
     * first rule returns the class name of ColorInterpolator for any
     * property names containing the string "color" or "Color". The second
     * rule returns the class name of ObjectInterpolator for the property
     * name "shape".</p>
     *
     * <p>The default value type to interpolator type mappings are:
     * <ul>
     *  <li><code>Number -> NumberInterpolator</code></li>
     *  <li><code>int -> NumberInterpolator</code></li>
     *  <li><code>Date -> DateInterpolator</code></li>
     *  <li><code>Array -> ArrayInterpolator</code></li>
     *  <li><code>flash.geom.Point -> PointInterpolator</code></li>
     *  <li><code>flash.geom.Rectangle -> RectangleInterpolator</code></li>
     * </ul>
     * </p>
     *
     * <p>The interpolator factory can be extended either by adding new
     * interpolation rule functions or by adding new mappings from
     * interpolation value types to custom interpolator classes.</p>
     */
    public static function create(target:Object, property:String,
                                  start:Object, end:Object):Interpolator {
        // first, check the rules list for an interpolator
        var name:String = null;
        for (var i:uint = 0; name == null && i < _rules.length; ++i) {
            name = _rules[i](target, property, start, end);
        }
        // if no matching rule, use the type lookup table
        if (name == null) {
            name = _lookup[getQualifiedClassName(end)];
        }
        // if that fails, use ObjectInterpolator as default
        if (name == null) {
            name = "org.juicekit.animate.interpolate::ObjectInterpolator";
        }

        // now create the interpolator, recycling from the pool if possible
        var pool:Array = _pools[name] as Array;
        if (pool == null || pool.length == 0) {
            // nothing in the pool, create a new instance
            var Ref:Class = getDefinitionByName(name) as Class;
            return new Ref(target, property, start, end) as Interpolator;
        } else {
            // reuse an interpolator from the object pool
            var interp:Interpolator = pool.pop() as Interpolator;
            interp.reset(target, property, start, end);
            return interp;
        }
    }

    /**
     * Reclaims an interpolator for later recycling. The reclaimed
     * interpolator should not be in active use by any other classes.
     * @param interp the Interpolator to reclaim
     */
    public static function reclaim(interp:Interpolator):void {
        var type:String = getQualifiedClassName(interp);
        var pool:Array = _pools[type] as Array;
        if (pool == null) {
            _pools[type] = [interp];
        } else if (pool.length < _maxPoolSize) {
            pool.push(interp);
        }
    }

} // end of class Interpolator
}