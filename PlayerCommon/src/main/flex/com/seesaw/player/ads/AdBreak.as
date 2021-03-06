/*
 * Copyright 2010 ioko365 Ltd.  All Rights Reserved.
 *
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the
 * License athttp://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * The Initial Developer of the Original Code is ioko365 Ltd.
 * Portions created by ioko365 Ltd are Copyright (C) 2010 ioko365 Ltd
 * Incorporated. All Rights Reserved.
 *
 * The Initial Developer of the Original Code is ioko365 Ltd.
 * Portions created by ioko365 Ltd are Copyright (C) 2010 ioko365 Ltd
 * Incorporated. All Rights Reserved.
 */

package com.seesaw.player.ads {
public class AdBreak {

    //total number of ads in this ad-break
    private var _queueAdsTotal:uint;

    //total duration of ad-break in seconds
    private var _queueDuration:Number;

    //start time value converted to Number: 0, 768.52, 100
    private var _startTime:Number;

    //specifies whether the startTimeValue is Percent (true) or  seconds (false)
    private var _startTimeIsPercent:Boolean;

    public function AdBreak() {
    }

    public function get queueAdsTotal():uint {
        return _queueAdsTotal;
    }

    public function set queueAdsTotal(value:uint):void {
        _queueAdsTotal = value;
    }

    public function get queueDuration():Number {
        return _queueDuration;
    }

    public function set queueDuration(value:Number):void {
        _queueDuration = value;
    }

    public function get startTime():Number {
        return _startTime;
    }

    public function set startTime(value:Number):void {
        _startTime = value;
    }

    public function get startTimeIsPercent():Boolean {
        return _startTimeIsPercent;
    }

    public function set startTimeIsPercent(value:Boolean):void {
        _startTimeIsPercent = value;
    }

    public function get hasAds():Boolean {
        return queueAdsTotal > 0;
    }
}
}