#!/bin/sh
# wrapper script for gas
# Shows one screen of gas prices, highlighting words of interest.
# You will likely want to customize grep's search terms.
#
gas |
grep --color=always 'Marathon\|Shell\|Sunoco\|Broad\|High\|$' |
head -`expr $LINES - 1`
