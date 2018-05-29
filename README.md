# finder-folder-icons
Converts Finder color labels to icons so that they can be "persisted" and restored from bucket storage archives.

## Architecture

OS X comes bundled with a rather sophisticated Robotic Process Automation (RPA) utility called Automator. Custom scripts can be invoked and chained as follows:

* An Automator service that can be triggered from any application
* A Bash script that processes a single folder, the heart of operation. Copies a `png` file inside and sets the folder icon
* An AppleScript that sets Finder color labels

Note all the support files are manually bundled inside the workflow package inside a folder called `Resources`. The name resembles normal Mac applications, but Automator does not actually create this folder for workflows—which means it won't get overwritten either when the script is modified!

## How to Install

Copy the workflow into `~/Library/Services/`

## How to Prepare Folders for Cloud Storage

- Tag folders with Finder colors (green, orange, etc.)
- Invoke the service
  - Right click the top level folder in Finder
  - Select `Services` from the drop down
  - Choose `Convert Finder Labels to Icons` 
- A little gear will spin the menu bar as the workflow executes
- The script writes a file `green.icon.png`, `orange.icon.png` etc. into all folders with labels, and sets the icon of the folder to that new icon (to indicate it did work)

All these folders can then be archived in bucket storage.

## How to Restore Finder Labels from Cloud Storage

- Download the files and folders from cloud storage. The original icon and label are lost, but the `png` file remains!
- Invoke the service again on the parent folder from Finder's context menu.
- The script recursively sets the icon of each folder based on the `png` file inside and also sets the Finder label again!

## Special Thanks

* https://stackoverflow.com/questions/1464641/how-to-see-what-label-color-is-on-a-file-folder-from-within-termnal-mac-os-x
* https://www.thegeekstuff.com/2010/06/bash-array-tutorial/
* https://stackoverflow.com/questions/33318499/should-i-use-quotes-in-environment-path-names
* https://stackoverflow.com/questions/32265339/applescript-notifications-with-buttons?rq=1
* https://stackoverflow.com/questions/6363441/check-if-a-file-exists-with-wildcard-in-shell-script
* https://stackoverflow.com/questions/688849/associative-arrays-in-shell-scripts
* https://www.linuxjournal.com/content/return-values-bash-functions