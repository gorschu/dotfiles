#!/bin/bash
# rename all German umlauts in filenames to their proper
# non-German equivalents.

find . -depth -iname "*[äÄöÖüÜß]*" -print | \
awk '
{
        match ($0,/.*\//)
        name = substr ($0,RLENGTH+1)
        pfad = substr ($0,1,RLENGTH)
        gsub (/ä/,"ae",name)
        gsub (/ö/,"oe",name)
        gsub (/ü/,"ue",name)
        gsub (/ß/,"ss",name)
        gsub (/Ä/,"Ae",name)
        gsub (/Ö/,"Oe",name)
        gsub (/Ü/,"Ue",name)
        print "mv '\''" $0 "'\'' '\''" pfad name "'\''"
}' | sh -ev
