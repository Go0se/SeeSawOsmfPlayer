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
package com.seesaw.player.smil {
import org.osmf.elements.proxyClasses.LoadFromDocumentLoadTrait;
import org.osmf.events.MediaError;
import org.osmf.events.MediaErrorEvent;
import org.osmf.events.MediaFactoryEvent;
import org.osmf.media.MediaElement;
import org.osmf.media.MediaFactory;
import org.osmf.media.MediaResourceBase;
import org.osmf.metadata.Metadata;
import org.osmf.metadata.MetadataNamespaces;
import org.osmf.smil.SMILConstants;
import org.osmf.smil.loader.SMILLoaderBase;
import org.osmf.smil.media.SMILMediaGenerator;
import org.osmf.smil.model.SMILDocument;
import org.osmf.smil.parser.SMILParser;
import org.osmf.traits.LoadState;
import org.osmf.traits.LoadTrait;

/**
 * The SMILLoader class will load a SMIL (Synchronized
 * Multimedia Integration Language) file and generate
 * a loaded context.
 */
public class SeeSawSMILLoader extends SMILLoaderBase {

    /**
     * Constructor.
     *
     * @param factory The factory that is used to create MediaElements based on the
     * media specified in the SMIL file.  A default factory is created for the base
     * OSMF media types: Video, Audio, Image, and SWF.
     */
    public function SeeSawSMILLoader(mediaFactory:MediaFactory = null) {
        super(mediaFactory);
    }

    /**
     * @private
     */
    override public function canHandleResource(resource:MediaResourceBase):Boolean {
        var canHandle:Boolean = false;

        // We should bypass the rest of this method if a MIME type
        // is explicitly specified (whether it matches or not).
        //        if (resource && resource.mimeType != null) {
        //            canHandle = resource.mimeType == SMIL_MIME_TYPE;
        //        }

        if (resource) {
            // This loader expects the actual smil document to be contained in the resource metadata
            var metadata:Metadata = resource.getMetadataValue(SMILConstants.SMIL_METADATA_NS) as Metadata;
            canHandle = metadata != null && metadata.getValue(SMILConstants.SMIL_DOCUMENT) != null;
        }

        return canHandle;
    }

    /**
     * @private
     */
    override protected function executeLoad(loadTrait:LoadTrait):void {
        updateLoadTrait(loadTrait, LoadState.LOADING);

        var metadata:Metadata = loadTrait.resource.getMetadataValue(SMILConstants.SMIL_METADATA_NS) as Metadata;
        var smil:XMLList = metadata.getValue(SMILConstants.SMIL_DOCUMENT) as XMLList;

        try {
            var parser:SMILParser = createParser();
            var smilDocument:SMILDocument = parser.parse(smil);
            finishLoad(loadTrait, smilDocument);
        }
        catch (parseError:Error) {
            updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
            loadTrait.dispatchEvent(new MediaErrorEvent(MediaErrorEvent.MEDIA_ERROR, false, false,
                    new MediaError(parseError.errorID, parseError.message)));

        }
    }

    /**
     * @private
     */
    override protected function executeUnload(loadTrait:LoadTrait):void {
        updateLoadTrait(loadTrait, LoadState.UNLOADING);
        updateLoadTrait(loadTrait, LoadState.UNINITIALIZED);
    }

    /**
     * Override to provide a custom media generator.
     */
    protected function createMediaGenerator():SMILMediaGenerator {
        return new SMILMediaGenerator();
    }

    /**
     * Override to provide a custom SMIL parser.
     */
    protected function createParser():SMILParser {
        return new SMILParser();
    }

    private function finishLoad(loadTrait:LoadTrait, smilDocument:SMILDocument):void {
        var mediaGenerator:SMILMediaGenerator = createMediaGenerator();

        // Listen for created elements so that we can add the "derived" resource metadata
        // to them.  Use a high priority so that we can add the metadata before clients
        // get the event.
        factory.addEventListener(MediaFactoryEvent.MEDIA_ELEMENT_CREATE, onMediaElementCreate, false, int.MAX_VALUE);
        var loadedElement:MediaElement = mediaGenerator.createMediaElement(loadTrait.resource, smilDocument, factory);
        factory.removeEventListener(MediaFactoryEvent.MEDIA_ELEMENT_CREATE, onMediaElementCreate);

        if (loadedElement == null) {
            updateLoadTrait(loadTrait, LoadState.LOAD_ERROR);
        }
        else {
            var elementLoadTrait:LoadFromDocumentLoadTrait = loadTrait as LoadFromDocumentLoadTrait;
            if (elementLoadTrait) {
                elementLoadTrait.mediaElement = loadedElement;
            }

            updateLoadTrait(loadTrait, LoadState.READY);
        }

        function onMediaElementCreate(event:MediaFactoryEvent):void {
            var derivedResource:MediaResourceBase = event.mediaElement.resource;
            if (derivedResource != null) {
                derivedResource.addMetadataValue(MetadataNamespaces.DERIVED_RESOURCE_METADATA, loadTrait.resource);
            }
        }
    }
}
}
