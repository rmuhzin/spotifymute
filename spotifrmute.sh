#!/bin/bash

# Mute spotify advertisements, because it's annoying :)

echo "----------------------------------------------------------"
echo ""
echo "   Mute spotify Ads"
echo ""
echo "----------------------------------------------------------"


WMTITLE="Spotify Free - Linux Preview"


xprop -spy -name "$WMTITLE" WM_ICON_NAME |
while read -r XPROPOUTPUT; do
        XPROP_TRACKDATA="$(echo "$XPROPOUTPUT" | cut -d \" -f 2 )"
        DBUS_TRACKDATA="$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify / \
        org.freedesktop.MediaPlayer2.GetMetadata | grep xesam:title -A 1 | grep variant | cut -d \" -f 2)"

        # show something
        echo "XPROP:   $XPROP_TRACKDATA"
        echo "DBUS:    $DBUS_TRACKDATA"

        # first song should not be commerical
        if [ "$OLD_XPROP" != "" ]
        then
            # check if old DBUS is the same as the new, if true then we have a commercial, so mute
           if [ "$OLD_DBUS" = "$DBUS_TRACKDATA" ] && [ "$OLD_XPROP" != "Spotify" ] && [ "$XPROP_TRACKDATA" != "Spotify" ]
            then
                echo "Ad:      yes"
                amixer -D pulse set Master mute >> /dev/null
            else
                echo "Ad:      no"
                amixer -D pulse set Master unmute >> /dev/null
            fi
        else
            echo "Ad:      we don't know yet"
        fi
        echo "----------------------------------------------------------"
        OLD_XPROP=$XPROP_TRACKDATA
        OLD_DBUS=$DBUS_TRACKDATA

done

exit 0
