/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import uk.co.piggz.ConsumerIRDevice 1.0
import uk.co.piggz.FileIO 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.Portrait

    property string displayName: ""
    property int columns: 3

    ConsumerIRDevice {
        id: irDevice
    }

    FileIO {
        id: templateFile

        onError: {
            console.log("Error:", msg)
        }
    }

    Label {
        text: "No IR Device Detected"
        anchors.fill: parent
        visible: !irDevice.hasIR
    }

    function loadTemplate(path) {
        pageStack.pop();
        console.log("Loading...", path);
        templateFile.setSource(path);
        processTemplate(templateFile.read());
    }

    function processTemplate(content) {
        //Delete curernt buttons
        for(var i = remoteGrid.children.length; i > 0 ; i--) {
            remoteGrid.children[i-1].destroy()
        }

        var lines = content.split("\n");
        for (var i = 0; i < lines.length; ++i) {
            var line = lines[i];
            //Skip comments and blank lines.
            if (line.indexOf("#") === 0 || line.trim() === "") {
                continue;
            }
            if (line.indexOf("Name:") === 0) {
                displayName = line.substring(5).trim();
                continue;
            }
            if (line.indexOf("Columns:") === 0) {
                columns = line.substring(8).trim();
                continue;
            }
            if (line.indexOf("Button:") === 0) {
                var btn = line.substring(7).trim().split(":");
                remoteButton.createObject(remoteGrid, {"text":btn[0].trim(), "rawcode": btn[1].trim()})
                continue;
            }
            if (line.indexOf("IconButton:") === 0) {
                var btn = line.substring(11).trim().split(":");
                remoteIconButton.createObject(remoteGrid, {"icn":btn[0].trim(), "rawcode": btn[1].trim()})
                continue;
            }
            if (line.indexOf("Blank") === 0) {
                blankItem.createObject(remoteGrid);
                continue;
            }
            if (line.indexOf("Label:") === 0) {
                labelItem.createObject(remoteGrid, {"text":line.substring(6).trim()});
                continue;
            }
        }
    }

    Component {
        id: remoteIconButton

        IconButton {
            property string rawcode: ""
            property string icn: ""
            property int frequency: 0
            property var countcode
            property var durationcode

            icon.source: "image://theme/" + icn
            width: parent.childWidth
            height: Theme.itemSizeExtraSmall

            onClicked: {
                console.log("Transmitting:", frequency, durationcode);
                irDevice.transmit(frequency, durationcode);
            }

            Component.onCompleted:  {
                //WHen the button is ready, calculate the transmit codes
                hex2dec(rawcode);
                count2duration();

                console.log("Creating IconButton:", icn);
                console.log("Frequency:",frequency);
                console.log("Count Pattern:", countcode);
                console.log("Duration Pattern:" + durationcode);
            }

            function hex2dec(rawcode) {
                var list = rawcode.split(" ");

                list.splice(0, 1); // dummy

                //Calculate the transmit frequency
                var frequencylist = list.splice(0, 1);
                frequency = parseInt(frequencylist[0], 16);
                frequency = Math.floor(1000000 / (frequency * 0.241246));

                //Remove unneeded items
                list.splice(0,1); // seq1
                list.splice(0,1); // seq2

                //Create an array of decimal values
                var newlist = new Array();
                for (var i = 0; i < list.length; i++) {
                    newlist.push(parseInt(list[i], 16).toString());
                }
                countcode = newlist;
            }

            function count2duration() {
                var pulses = Math.floor(1000000/frequency);
                var count;
                var duration;

                var newlist = new Array();

                //Transform each caount value to a duration value
                for (var i = 0; i < countcode.length; i++) {
                    count = countcode[i]
                    duration = Math.round(count * pulses);
                    newlist.push(duration)
                }

                durationcode = newlist
            }

        }
    }

    Component {
        id: remoteButton

        Button {
            property string rawcode: ""
            property int frequency: 0
            property var countcode
            property var durationcode

            preferredWidth: parent.childWidth
            height: Theme.itemSizeExtraSmall
            onClicked: {
                console.log("Transmitting:", frequency, durationcode);
                irDevice.transmit(frequency, durationcode);
            }

            Component.onCompleted:  {
                //WHen the button is ready, calculate the transmit codes
                hex2dec(rawcode);
                count2duration();

                console.log("Creating Button:", text);
                console.log("Frequency:",frequency);
                console.log("Count Pattern:", countcode);
                console.log("Duration Pattern:" + durationcode);
            }

            function hex2dec(rawcode) {
                var list = rawcode.split(" ");

                list.splice(0, 1); // dummy

                //Calculate the transmit frequency
                var frequencylist = list.splice(0, 1);
                frequency = parseInt(frequencylist[0], 16);
                frequency = Math.floor(1000000 / (frequency * 0.241246));

                //Remove unneeded items
                list.splice(0,1); // seq1
                list.splice(0,1); // seq2

                //Create an array of decimal values
                var newlist = new Array();
                for (var i = 0; i < list.length; i++) {
                    newlist.push(parseInt(list[i], 16).toString());
                }
                countcode = newlist;
            }

            function count2duration() {
                var pulses = Math.floor(1000000/frequency);
                var count;
                var duration;

                var newlist = new Array();

                //Transform each caount value to a duration value
                for (var i = 0; i < countcode.length; i++) {
                    count = countcode[i]
                    duration = Math.round(count * pulses);
                    newlist.push(duration)
                }

                durationcode = newlist
            }
        }
    }

    Component {
        id: labelItem
        Item {
            property string text: ""
            width: parent.childWidth
            height: Theme.itemSizeExtraSmall
            Label {
                anchors.centerIn: parent
                text: parent.text
            }
        }
    }

    Component {
        id: blankItem

        Item {
            width: parent.childWidth
            height: Theme.itemSizeExtraSmall
            visible: true
        }

    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        visible: irDevice.hasIR

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Load Template")
                onClicked: {
                    var p = pageStack.push(Qt.resolvedUrl("TemplatesPage.qml"))
                    p.loadTemplate.connect(loadTemplate)
                }
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: displayName
            }
            Grid {
                id: remoteGrid
                columns: page.columns
                width: parent.width
                spacing: Theme.paddingMedium
                property real childWidth: (width - ((columns - 1) * spacing)) / columns
            }
        }
    }
}

