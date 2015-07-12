gas
===

This script shows prices for gasoline in plain text, sorted by price.
I often find it convenient to pipe it to less, ala:

    gas | less

then to search for favored vendors and locations, to highlight them.
For example:

    /Marathon|Shell|Sunoco|Maize|Karl|Morse

The URL is hard coded in gas for parts of Columbus, Ohio.
Other users will likely want to change the URL for another area of interest.

Some vendors have images appear instead of text for their stations. So there is
some special case code in parsegaspriceshtml.awk to replace links for the
images with text names. Users will likely need to customize that for vendors in
their area. Search for BP in parsegaspriceshtml.awk to find that section
of code.

From time to time, changes to the web site break this script. So far, most of
the changes have been to parsegaspriceshtml.awk, and mostly for changing image
URLs to plain text names.

g
=

A convenience script, g, shows one screen of gas prices, highlighting words of
interest. Other users will likely want to edit it to choose other words to
highlight.

    g

## Setup

Put gas and g in a $PATH directory.
Put parsegaspriceshtml.awk in same directory as gas.

## Prerequisites

Common unix command line utilities, such as sh, grep, sed, awk, tr, wget,
printf, and column. I do not know which versions of utilities are needed.

