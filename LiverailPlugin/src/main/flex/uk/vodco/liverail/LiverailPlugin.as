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
package uk.vodco.liverail {
import org.as3commons.logging.ILogger;
import org.as3commons.logging.LoggerFactory;
import org.osmf.media.MediaElement;
import org.osmf.media.MediaFactoryItem;
import org.osmf.media.MediaFactoryItemType;
import org.osmf.media.MediaResourceBase;
import org.osmf.media.PluginInfo;
import org.osmf.metadata.Metadata;

public class LiverailPlugin extends PluginInfo {
    private var logger:ILogger = LoggerFactory.getClassLogger(LiverailPlugin);

    /**
     * Constructor
     */
    public function LiverailPlugin() {
        // Allow any SWF that loads this SWF to access objects and
        // variables in this SWF.


        var items:Vector.<MediaFactoryItem> = new Vector.<MediaFactoryItem>();
        items.push(mediaFactoryItem);

        super(items, mediaElementCreationNotificationCallback);

    }

    /**
     * Gives the player the PluginInfo.
     */

    private var _mediaFactoryItem:MediaFactoryItem
            = new MediaFactoryItem
            (ID
                    , canHandleResourceCallback
                    , mediaElementCreationCallback
                    , MediaFactoryItemType.STANDARD
                    );

    public function get mediaFactoryItem():MediaFactoryItem {
        return _mediaFactoryItem;
    }

    // Internals
    //

    public static const ID:String = "uk.vodco.liverail.LiverailPluginInfo";
    public static const NS_SETTINGS:String = "http://www.seesaw.com/liverail/settings";
    public static const NS_TARGET:String = "http://www.seesaw.com/liverail/target";

    private var _pluginInfo:PluginInfo;
    private var _liverailElement:LiverailElement;
    private var targetElement:MediaElement;


    private function canHandleResourceCallback(resource:MediaResourceBase):Boolean {
        var result:Boolean;

        if (resource != null) {
            var settings:Metadata
                    = resource.getMetadataValue(NS_SETTINGS) as Metadata;

            result = settings != null;
        }

        return result;
    }

    private function mediaElementCreationCallback():MediaElement {
        logger.debug("mediaElementCreationCallback");
        if (liverailElement == null) {
            liverailElement = new LiverailElement();
        }
        return liverailElement;

    }

    private function mediaElementCreationNotificationCallback(target:MediaElement):void {


        logger.debug("mediaElementCreationNotificationCallback: " + target);

        var targetMetadata:Metadata = target.getMetadata(LiverailPlugin.NS_TARGET);
        if (targetMetadata) {
            logger.debug("TARGET ELEMENT : " + target);

            this.targetElement = target;
            if (liverailElement == null) {
                liverailElement = new LiverailElement();
            }
            updateLiverail();
        }
    }

    private function updateLiverail():void {
        if (liverailElement != null && targetElement != null && liverailElement != targetElement) {
            logger.debug("THE TARGET " + targetElement);

            liverailElement.addReference(targetElement);
        }
    }

    public function get liverailElement():LiverailElement {
        return _liverailElement;
    }

    public function set liverailElement(value:LiverailElement):void {
        _liverailElement = value;
    }
}
}