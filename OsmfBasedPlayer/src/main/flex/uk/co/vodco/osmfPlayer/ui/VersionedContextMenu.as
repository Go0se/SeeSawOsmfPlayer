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

package uk.co.vodco.osmfPlayer.ui {
import flash.display.InteractiveObject;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

public class VersionedContextMenu {

    public static const VERSION:String = PLAYER::V;

    public function VersionedContextMenu(interactiveObject:InteractiveObject) {

        var versionedMenu:ContextMenu = new ContextMenu();
        versionedMenu.hideBuiltInItems();

        var item:ContextMenuItem = new ContextMenuItem("SeeSaw player version " + VERSION);
        versionedMenu.customItems.push(item);

        interactiveObject.contextMenu = versionedMenu;


    }
}
}