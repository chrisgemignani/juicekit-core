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
 * Interface for "schedulable" objects that can be run by
 * the Scheduler class.
 */
public interface ISchedulable {
    /**
     * Evaluate a scheduled call.
     * @param time the current time in milliseconds
     * @return true if this item should be removed from the scheduler,
     * false if it should continue to be run.
     */
    function evaluate(time:Number):Boolean;

    /** A unique name identifying this schedulable object. The default
     *  is <code>null</code>. If non-null, any other scheduled items with
     *  the same id will be canceled upon scheduling.
     *
     *  <p>Once an item has been scheduled, it's id should not be changed.
     *  However, it is left to subclasses to respect this convention.
     *  If it is not followed, erratic cancels may occur.</p> */
    function get id():String;

    function set id(n:String):void;

    /** Invoked if a scheduled item is cancelled by the scheduler. */
    function cancelled():void;

} // end of interface ISchedulable
}