#!/usr/bin/env bash
# Lock with the wallpaper set by azote (read from ~/.fehbg).
# i3lock only takes a PNG at screen size, so render one and cache it.
# Extra args are passed through to i3lock (xss-lock passes --nofork).

fehbg=~/.fehbg
src=$(grep -o "'[^']*'" "$fehbg" 2>/dev/null | head -1 | tr -d "'")
res=$(xrandr | awk '/^Screen 0/ {print $8 "x" $10; exit}' | tr -d ,)
cache=~/.cache/i3lock/wallpaper-$res.png

if [[ -f $src ]]; then
    if [[ ! -f $cache || $src -nt $cache || $fehbg -nt $cache ]]; then
        mkdir -p "${cache%/*}"
        magick "$src" -resize "$res^" -gravity center -extent "$res" "$cache"
    fi
    exec i3lock -i "$cache" "$@"
fi

exec i3lock -c 1a1b26 "$@"
