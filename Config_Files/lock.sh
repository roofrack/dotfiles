#!/bin/sh

BLANK='#00000000'
CLEAR='#ffffff22'
DEFAULT='#ff00ffcc'
# DEFAULT='#ff00ffe6'
TEXT='#ee00eeee'
# TEXT='#ee00eee6'
WRONG='#880000bb'
VERIFYING='#bb00bbbb'
# VERIFYING='#bb00bbe6'

/usr/bin/i3lock \
--insidever-color=$CLEAR     \
--ringver-color=$VERIFYING   \
\
--insidewrong-color=$CLEAR   \
--ringwrong-color=$WRONG     \
\
--inside-color=$BLANK        \
--ring-color=$DEFAULT        \
--line-color=$BLANK          \
--separator-color=$DEFAULT   \
\
--verif-color=$TEXT          \
--wrong-color=$TEXT          \
--time-color=$TEXT           \
--date-color=$TEXT           \
--layout-color=$TEXT         \
--keyhl-color=$WRONG         \
--bshl-color=$WRONG          \
\
--screen 1                   \
--blur 5                     \
--clock                      \
--indicator                  \
--time-str="%H:%M:%S"        \
--date-str="%A, %m %Y"       \
--keylayout 1                \
