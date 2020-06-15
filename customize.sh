#!/system/bin/sh
SKIPUNZIP=1

### mod specific variables ###
MOMINSDK=24
MOPRINT1=" Selecting one frame point... "
MOPRINT2=" Setting another one... "
MOPRINT3=" Putting it in motion "
MOPRINT4=" Rendering...aaand done n dusted "

### actual script ###
MOAPKNAME="`unzip -l $ZIPFILE | grep 'apk' | awk '{print $NF}' | grep 'apk$'`"
MOOVERLAYPATH="`cmd overlay dump | grep -o '\/.*apk$' | head -n 1 | sed -n 's/overlay\/.*apk$/overlay\//gip'`"
MOWCHPARTITION=`echo $MOOVERLAYPATH | grep -o -i -e 'product' -e 'vendor'`

if [ $API -ge $MOMINSDK ]; then
    if [ $MOOVERLAYPATH ]; then
      if [ $MOAPKNAME ]; then
          ui_print "- Extracting module files"
          unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH >&2

          MOREALOVERLAYPATH=`readlink -f $MOOVERLAYPATH`
          MOTARGETPATH="$MODPATH/system/$MOWCHPARTITION/overlay"
          ui_print " Overlays detected in $MOWCHPARTITION partition "
          ui_print " Placing $MOAPKNAME into $MOREALOVERLAYPATH "
          [ -f $MODPATH/$MOAPKNAME ] && mkdir -p $MOTARGETPATH && mv $MODPATH/$MOAPKNAME $MOTARGETPATH/$MOAPKNAME

          # Default permissions
          set_perm_recursive $MODPATH 0 0 0755 0644
          ui_print "";sleep 2;ui_print "$MOPRINT1"; sleep 2;ui_print "$MOPRINT2"; sleep 2;ui_print "$MOPRINT3"; sleep 2;ui_print "$MOPRINT4";sleep 1;ui_print "";ui_print '<><><><><><><><><><><><><><><><><><><><><>';ui_print ' Module by plethorahil (t.me/plethorahil) ';ui_print '<><><><><><><><><><><><><><><><><><><><><>';ui_print "";sleep 3
        else
          ui_print " Couldn't find apk in the zip file :( "
        fi
    else
      ui_print " Couldn't find overlay path "
      ui_print " Are you sure your device supports overlays? "
      ui_print " Contact me t.me/plethorahil to figure out "
    fi
else
    ui_print "Sorry !!! Your device doesn't support this module"
fi
