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
import flash.events.Event;

/**
 * Event fired when a <code>Transition</code>
 * starts, steps, ends, or is canceled.
 */
public class TransitionEvent extends Event {
    /** A transition start event. */
    public static const START:String = "start";
    /** A transition step event. */
    public static const STEP:String = "step";
    /** A transition end event. */
    public static const END:String = "end";
    /** A transition cancel event. */
    public static const CANCEL:String = "cancel";

    private var _t:Transition;

    /** The transition this event corresponds to. */
    public function get transition():Transition {
        return _t;
    }

    /**
     * Creates a new TransitionEvent.
     * @param type the event type (START, STEP, or END)
     * @param t the transition this event corresponds to
     */
    public function TransitionEvent(type:String, t:Transition) {
        super(type);
        _t = t;
    }

    /** @inheritDoc */
    public override function clone():Event {
        return new TransitionEvent(type, _t);
    }

} // end of class TransitionEvent
}