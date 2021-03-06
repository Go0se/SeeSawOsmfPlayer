/*
 * Copyright 2010 ioko365 Ltd.  All Rights Reserved.
 *
 *    The contents of this file are subject to the Mozilla Public License
 *    Version 1.1 (the "License"); you may not use this file except in
 *    compliance with the License. You may obtain a copy of the
 *    License athttp://www.mozilla.org/MPL/
 *
 *    Software distributed under the License is distributed on an "AS IS"
 *    basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 *    License for the specific language governing rights and limitations
 *    under the License.
 *
 *    The Initial Developer of the Original Code is ioko365 Ltd.
 *    Portions created by ioko365 Ltd are Copyright (C) 2010 ioko365 Ltd
 *    Incorporated. All Rights Reserved.
 *
 *    The Initial Developer of the Original Code is ioko365 Ltd.
 *    Portions created by ioko365 Ltd are Copyright (C) 2010 ioko365 Ltd
 *    Incorporated. All Rights Reserved.
 */

package com.seesaw.player.liverail {
import com.seesaw.player.ads.LiverailConfiguration;
import com.seesaw.player.namespaces.contentinfo;

public class LiverailConfig extends LiverailConfiguration {

    private var contentInfo:XML;
    private var liveRailAdMap:String = "";
    private var liveRailTags:String = "";
    private var genres:Array;
    private var ageRating:int;
    private var adSlots:int = 0;

    use namespace contentinfo;

    public function LiverailConfig(contentInfoXml:XML) {
        contentInfo = contentInfoXml as XML;
        generateMap();
        createConfig();
    }

    public override function generateMap():void {
        var autoResumePoint:Number = 0;

        liveRailAdMap = "";
        liveRailTags = "";

        if (contentInfo != null) {
            liveRailTags += "sourceId_" + stripSpecialChars(contentInfo.sourceId);
            liveRailTags += ",firstPresentationBrand_" + stripSpecialChars(contentInfo.firstPresentationBrand);
            liveRailTags += ",minimumAge_" + ageRating.toString();
            liveRailTags += ",catchup_" + stripSpecialChars(contentInfo.catchup);

            for each(var genre:String in genres) {
                liveRailTags += "," + stripSpecialChars(genre);
            }

            var duration:Number = Number(contentInfo.duration);
            if (duration < 900) {
                liveRailTags += ",duration_less_than_15_min";
            } else if (duration < 3600) {
                liveRailTags += ",duration_less_than_1_hour";
            } else {
                liveRailTags += ",duration_greater_than_1_hour";
            }

            for each(var item:XML in contentInfo.loggingSheet.children()) {
                var name:String = item.name().localName;
                switch (name) {
                    case "break":
                        if (item.breakOffset != null) {
                            var pos:Number = convertDuration(item.breakOffset);
                            if (!(pos < autoResumePoint)) {

                                liveRailAdMap += "in::" + pos.toString();

                                if (Math.abs(pos) > 0) {
                                    adPositions.push(convertPercenage(pos));
                                }
                            }
                            totalAdPositions.push(pos);
                        }
                        liveRailAdMap += ";";
                        adSlots++;
                        break;
                }
            }

            //hardcode the preroll if not exist in string already
            if (!liveRailAdMap.match("in::0")) {
                liveRailAdMap = "in::0;" + liveRailAdMap + "in::100%;";
                totalAdPositions.push(0);
            }

            //remove the last semi-colon in the string, apparently there is a reason for this as LR asked us to do it
            liveRailAdMap = liveRailAdMap.substring(0, liveRailAdMap.lastIndexOf(";"));
        }
    }

    private static function convertDuration(str:String):Number {
        var arrDuration:Array = str.split(":");
        var iHours:Number = Number(arrDuration[0]);
        var iMinutes:Number = Number(arrDuration[1]);
        var iSeconds:Number = Number(arrDuration[2]);
        var finalSeconds:Number = ((iHours * (60 * 60)) + (iMinutes * 60) + iSeconds);
        return finalSeconds;
    }

    private function convertPercenage(num:Number):Number {
        var duration:Number = contentInfo.duration;
        return (num / duration);
    }

    private function stripSpecialChars(original:String):String {
        original = original.replace(/_|:/ig, "");
        return original;
    }

    private function extractMidLevelGenresAndAddToGenresArray(genre:*, index:int, original:Array):void {
        var startPositionToFindSecondColon:int;

        if (genre.indexOf("TV:") == 0) {
            startPositionToFindSecondColon = 3;
        } else {
            startPositionToFindSecondColon = 5;
        }

        var positionOfSecondColon:int = genre.indexOf(":", startPositionToFindSecondColon);
        if (positionOfSecondColon > 0) {
            var midLevelGenre:String = genre.substring(0, positionOfSecondColon);
            if (genres.indexOf(midLevelGenre) <= 0) {
                genres[genres.length] = midLevelGenre;
            }
        }
    }

    private function createConfig():void {
        config = {
            "LR_ADMAP" : liveRailAdMap,
            "LR_TAGS" : liveRailTags,
            "LR_BITRATE" :    "low",
            "LR_BUMPER_MIDROLL_ADONLY"    :"default",
            "LR_BUMPER_MIDROLL_POST_HIGH"    :"default",
            "LR_BUMPER_MIDROLL_POST_LOW" :    "default",
            "LR_BUMPER_MIDROLL_POST_MED"    : "default",
            "LR_BUMPER_MIDROLL_PRE_HIGH" :    "default",
            "LR_BUMPER_MIDROLL_PRE_LOW" :    "default",
            "LR_BUMPER_MIDROLL_PRE_MED" :    "default",
            "LR_BUMPER_POSTROLL_ADONLY" :    "default",
            "LR_BUMPER_POSTROLL_POST_HIGH" :    "default"  ,
            "LR_BUMPER_POSTROLL_POST_LOW" :    "default"  ,
            "LR_BUMPER_POSTROLL_POST_MED" :    "default" ,
            "LR_BUMPER_POSTROLL_PRE_HIGH" :    "default" ,
            "LR_BUMPER_POSTROLL_PRE_LOW" :    "default"  ,
            "LR_BUMPER_POSTROLL_PRE_MED" :    "default"  ,
            "LR_BUMPER_PREROLL_ADONLY" :    "default" ,
            "LR_BUMPER_PREROLL_POST_HIGH" :    "default"  ,
            "LR_BUMPER_PREROLL_POST_LOW" :    "default"   ,
            "LR_BUMPER_PREROLL_POST_MED" :    "default"   ,
            "LR_BUMPER_PREROLL_PRE_HIGH" :    "default"   ,
            "LR_BUMPER_PREROLL_PRE_LOW" :    "default"    ,
            "LR_BUMPER_PREROLL_PRE_MED" :    "default"   ,
            "LR_LAYOUT_LINEAR_PAUSEONCLICKTHRU" :    false  ,
            "LR_LAYOUT_SKIN_ID" :    1 ,
            "LR_PARTNERS" :    "SHERBET" ,
            "LR_PUBLISHER_ID" :    String(contentInfo.liverail.publisherId),
            "LR_USE_JUNCTION" :    false,
            "LR_VERSION" :    String(contentInfo.liverail.version),
            "LR_VIDEO_ID"    : String(contentInfo.programme)
        }
    }
}
}