/*
 * Copyright 2010 ioko365 Ltd.  All Rights Reserved.
 *
 *   The contents of this file are subject to the Mozilla Public License
 *   Version 1.1 (the "License"); you may not use this file except in
 *   compliance with the License. You may obtain a copy of the License at
 *   http://www.mozilla.org/MPL/
 *
 *   Software distributed under the License is distributed on an "AS IS"
 *   basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 *   License for the specific language governing rights and limitations
 *   under the License.
 *
 *
 *   The Initial Developer of the Original Code is ioko365 Ltd.
 *   Portions created by ioko365 Ltd are Copyright (C) 2010 ioko365 Ltd
 *   Incorporated. All Rights Reserved.
 */

package uk.co.vodco.osmfPlayer {
import flash.display.Sprite;
import flash.external.ExternalInterface;

import org.as3commons.logging.ILogger;
import org.as3commons.logging.LoggerFactory;
import org.osmf.logging.Log;
import org.osmf.media.MediaResourceBase;
import org.osmf.media.URLResource;
import org.osmf.metadata.Metadata;

import uk.co.vodco.osmfPlayer.logger.CommonsOsmfLoggerFactory;
import uk.co.vodco.osmfPlayer.logger.TraceAndArthropodLoggerFactory;
import uk.co.vodco.osmfPlayer.ui.VersionedContextMenu;

import flash.text.TextField;
import flash.text.TextFieldType;

/**
 * Wrapper for player
 *
 * This class responsibilities are
 * - Getting details of what to play from context
 * - Showing the 'screens' of the application and transitioning between them (if this gets big it should be delegated)
 * - Global features (e.g. right click menu)
 * - Initialising logging
 *
 * All playback, logic etc should reside in other sprites
 *
 * Note this project deliberately does not us the mx. packages to improve performance
 *
 * We are using 'DEFINES' for width, height and version. These are set in the pom.xml
 *
 */
[SWF(width=PLAYER::Width, height=PLAYER::Height)]
public class Player extends Sprite {

    private static const PLAYER_WIDTH:int = PLAYER::Width;
    private static const PLAYER_HEIGHT:int = PLAYER::Height;
    private static const PARAM_URL:String = "url";
    private static const PARAM_PROGRAMME:String = "programme";
    //  private static const VIDEO_URL:String = "http://mediapm.edgesuite.net/osmf/content/test/logo_animated.flv";
    private static const VIDEO_URL:String = "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
    // private static const VIDEO_URL:String = "rtmpe://cdn-flash-red-dev.vodco.co.uk/a2703/e5/test/ccp/p/LOW_RES/test/mp4:test_asset.mp4";
    // private static const VIDEO_URL:String = "rtmp://almer.rtmphost.com/osmfplayer/mp4:sample5.mp4";
    private static const VIDEO_ARRAY:Array = [
        "http://mediapm.edgesuite.net/osmf/content/test/logo_animated.flv",
        "rtmp://almer.rtmphost.com/osmfplayer/mp4:sample5.mp4",
        "http://mediapm.edgesuite.net/osmf/content/test/logo_animated.flv"
    ];

    // Set up the default logging mechanisms
    private static var loggerSetup:* = (LoggerFactory.loggerFactory = new TraceAndArthropodLoggerFactory());
    private static var osmfLoggerSetup:* = (Log.loggerFactory = new CommonsOsmfLoggerFactory());

    private var logger:ILogger = LoggerFactory.getClassLogger(Player);

    private var versionedContextMenu:VersionedContextMenu;

    private static const PLAYER_NAMESPACE:String = "http://www.seesaw.com/player/";

    public function Player() {
        logger.info("Initialising Player at {0} x {1}", PLAYER_WIDTH, PLAYER_HEIGHT);
        versionedContextMenu = new VersionedContextMenu(this);

        var content:MediaResourceBase = configure();

        setupGlobalExternalInterface();

        loadVideo(content);

    }

    private function setupGlobalExternalInterface():void {
        if (ExternalInterface.available) {
            ExternalInterface.addCallback("url", onSetUrl);
        }

    }

    private function onSetUrl(url:String):void {
        logger.info("URL Set To:{0}", url);
    }

    private var _videoPlayer:VideoPlayer;

    private function loadVideo(content:MediaResourceBase):void {
        if (_videoPlayer) {
            // TODO verify is this is enough to let it all be GC'd (it may be as nothing will have a reference...)
            removeChild(_videoPlayer)
            _videoPlayer = null;
        }

        _videoPlayer = new VideoPlayer(content, PLAYER_WIDTH, PLAYER_HEIGHT);
        addChild(_videoPlayer);
    }

    private function configure():MediaResourceBase {
        var parameters:Object;
        if (this.root != null && this.root.loaderInfo != null){
             parameters = this.root.loaderInfo.parameters;
        } else {
            // This only happens in unit test mode as there are no parameters available to the root object
            logger.info("In unit test mode");
            parameters = new Object();
        }


        var key:String;
        for (key in parameters) {
            logger.info("Parameter: {0}, Value {1}", key, parameters[key]);
        }

        var urlResource:MediaResourceBase;

        if (parameters[PARAM_URL]) {
            urlResource = new URLResource(parameters[PARAM_URL]);

            /*      var Params:Object = {
             autoPlay:parameters[AUTOPLAY]
             }
             urlResource.addMetadataValue("Params", Params);       */


        } else {
            if (parameters[PARAM_PROGRAMME]) {
                // TODO this would be replaced with a ProgrammeResource so our own plugin can resolve what to do about it
                urlResource = new URLResource(VIDEO_URL);
                // Sample of how to add metadata
                var programmeId
                        :
                        Metadata = new Metadata();
                programmeId.addValue("ProgrammeID", 1);
                urlResource.addMetadataValue(PLAYER_NAMESPACE, programmeId);
            } else {
                urlResource = new URLResource(VIDEO_URL);
            }
        }
        return urlResource;
    }

}
}