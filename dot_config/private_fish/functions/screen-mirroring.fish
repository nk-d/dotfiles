#!/usr/bin/env fish

function screen-mirroring
    wayvnc -p -r 127.0.0.1 -o DP-3 &>/dev/null &
    sleep 1
    vncviewer 127.0.0.1 &>/dev/null &
end
