# irremote add new Remote

irremote allows users to add new remotes via templates which are saved on the device in `/home/nemo/.local/share/irremote/irremote/`


## Remote Template.

To add new remotes you need the following tempalte. There are plenty of websites where you could find the IR codes for your remote. For example: [RemoteCentral](http://www.remotecentral.com/cgi-bin/codes/).

* Name for the remote

	`Name: <REMOTE NAME>`

* Buttons are definded with

	`Button: <NAME>: <HEX IR CODE>`

	`IconButton: <ICON-NAME>: <HEX IR CODE>`

	Icons are the default [SailfishOS IconButton](https://sailfishos.org/develop/docs/jolla-ambient/) type 

	Maybe your Remote or the IR codes are not availibe for all the buttons in the template. Simply comment this buttons out like this `#Button: Tools:`

* Blank space (empty placeholder )

	`Blank`  

* Name label for mulit-button areas like Volume up and down
	
	`Label: <LABLENAME>`

~~~~
#Name of the Remote
Name: <MYTV> Remote

#Number of colums per line
Colums: 3

#Power Button
Button: PWR:

Blank

#TV source
Button: TV:

Button: 1:

Button: 2:

Button: 3:

Button: 4:

Button: 5:

Button: 6:

Button: 7:

Button: 8:

Button: 9:

Blank

Button: 0:

Blank

#Vol Up
IconButton: icon-m-up:

Blank

#Channel Up
IconButton: icon-m-up:

Label: Vol

IconButton: icon-m-speaker-mute:

Label: Ch

#Vol Down
IconButton: icon-m-down:

Blank

#Channel Down
IconButton: icon-m-down:

Blank

#Menu
IconButton: icon-m-menu:

Blank

IconButton: icon-m-up:

Blank

#Left
IconButton: icon-m-left:

#Enter
IconButton: icon-m-enter:

#Right
IconButton: icon-m-right:

#Info
Button: Info:

#Down
IconButton: icon-m-down:

#Exit
Button: Exit:

#Source
Button: Source:

#Guide
Button: Guide:

#Tools
Button: Tools:
~~~~
