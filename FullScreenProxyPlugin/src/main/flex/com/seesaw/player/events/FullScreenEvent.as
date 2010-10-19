/*****************************************************
 *
 *  Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
 *
 *****************************************************
 *  The contents of this file are subject to the Mozilla Public License
 *  Version 1.1 (the "License"); you may not use this file except in
 *  compliance with the License. You may obtain a copy of the License at
 *  http://www.mozilla.org/MPL/
 *
 *  Software distributed under the License is distributed on an "AS IS"
 *  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 *  License for the specific language governing rights and limitations
 *  under the License.
 *
 *
 *  The Initial Developer of the Original Code is Adobe Systems Incorporated.
 *  Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems
 *  Incorporated. All Rights Reserved.
 *
 *****************************************************/
package com.seesaw.player.events {
import flash.events.Event;

public class FullScreenEvent extends Event {

    public static const FULL_SCREEN:String = "fullscreenChange";

    private var _value:Boolean;

    public function FullScreenEvent(value:Boolean) {
        super(FULL_SCREEN, false, false);
        _value = value;
    }

    public function get value():Boolean {
        return _value;
    }
}
}