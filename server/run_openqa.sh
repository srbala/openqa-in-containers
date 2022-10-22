#!/bin/bash

/usr/share/openqa/script/upgradedb --user geekotest --upgrade_database

# run services
dbus-daemon --system --fork --nopidfile
su -s /bin/bash -c '/usr/share/openqa/script/openqa-scheduler' geekotest &
su -s /bin/bash -c '/usr/share/openqa/script/openqa-websockets' geekotest &
su -s /bin/bash -c '/usr/share/openqa/script/openqa prefork -m production --proxy' geekotest &

rm -rf /run/httpd/* /tmp/httpd*
exec /usr/sbin/httpd -D FOREGROUND
