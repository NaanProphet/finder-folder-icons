#!/bin/bash

### Converts Finder color labels to icons so that they can be "persisted"
### and restored from bucket storage archives.


# all resources are relative to this current directory
ICON_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILEICON="$ICON_FOLDER"/fileicon
COLOR_SCRIPT="$ICON_FOLDER"/color.scpt


### finder label color map

# 0 = no colour
LABEL_COLOR[1]='orange'
LABEL_COLOR[2]='red'
LABEL_COLOR[3]='yellow'
LABEL_COLOR[4]='blue'
LABEL_COLOR[5]='purple'
LABEL_COLOR[6]='green'
# 7 = grey

# Array pretending to be a Pythonic dictionary
ICON_LABELS=( 
  "orange.icon.png:1"
  "red.icon.png:2"
  "yellow.icon.png:3"
  "blue.icon.png:4"
  "purple.icon.png:5"
  "green.icon.png:6"
)

getlabel() {
    osascript - "$@" << EOF
    on run argv
        tell application "Finder"
            set theArg to POSIX file (argv) as alias
                set labelIndex to (get label index of theArg)
                do shell script("echo " & labelIndex)
            end tell
        end run
EOF
}

getLabelNumber() {
	for label in "${ICON_LABELS[@]}" ; do
	    KEY="${label%%:*}"
	    VALUE="${label##*:}"
	
		if [ "$1" == "$KEY" ]; then
			# match found
			echo "$VALUE"
			return
		fi
	done
}

### end of setup ###

LABEL_CODE=`getlabel "$1"`
EXISTING_ICON_FILEPATH=`ls "$1"/*.icon.png 2>/dev/null`
EXISTING_ICON_NAME=`basename "$EXISTING_ICON_FILEPATH"`

# restore icons
if [ "$LABEL_CODE" -eq "0" ]; then
	if [ -f "$EXISTING_ICON_FILEPATH" ]; then
		"$FILEICON" set "$1" "$EXISTING_ICON_FILEPATH"
		osascript "$COLOR_SCRIPT" "$1" `getLabelNumber "$EXISTING_ICON_NAME"`
	fi
	exit 0
fi

ICON_FILE="$ICON_FOLDER"/${LABEL_COLOR[$LABEL_CODE]}.icon.png
ICON_FILENAME=`basename "$ICON_FILE"`
DEST_ICON_FILE="$1"/"$ICON_FILENAME"

if [ -f "$DEST_ICON_FILE" ]; then
	# same color, no change
	exit 0
fi

# remove old icon, if present
if [ -f "$EXISTING_ICON_FILEPATH" ]; then
	rm "$EXISTING_ICON_FILEPATH"
fi
cp "$ICON_FILE" "$DEST_ICON_FILE"

"$FILEICON" set "$1" "$DEST_ICON_FILE"

# special thanks to:
# https://stackoverflow.com/questions/1464641/how-to-see-what-label-color-is-on-a-file-folder-from-within-termnal-mac-os-x
# https://www.thegeekstuff.com/2010/06/bash-array-tutorial/
# https://stackoverflow.com/questions/33318499/should-i-use-quotes-in-environment-path-names
# https://stackoverflow.com/questions/32265339/applescript-notifications-with-buttons?rq=1
# https://stackoverflow.com/questions/6363441/check-if-a-file-exists-with-wildcard-in-shell-script
# https://stackoverflow.com/questions/688849/associative-arrays-in-shell-scripts
# https://www.linuxjournal.com/content/return-values-bash-functions