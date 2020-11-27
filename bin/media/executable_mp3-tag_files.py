#!/usr/bin/python2

import sys
import re
import glob
import eyed3

mp3filematch = re.compile(r'^(\d)(\d{2})')
mp3filematch_nodisc = re.compile(r'^(\d{2})')
discmax = None
trackmax = dict()

try:
    if sys.argv[1] == 'va':
        albumartist = u'Various Artists'
except IndexError:
    albumartist = None

for mp3file in glob.glob('*.mp3'):
    match = re.search(mp3filematch, mp3file)
    if match:
        disc = match.group(1)
        tracknumber = match.group(2)

        if discmax < disc:
            discmax = disc
    else:
        match = re.search(mp3filematch_nodisc, mp3file)
        if match:
            tracknumber = match.group(1)
            disc = 1
            discmax = 1
        else:
            raise BaseException("Invalid filename '%s'" % mp3file)

    if trackmax.get(disc, 0) < tracknumber:
        trackmax[disc] = tracknumber

for disc in trackmax:
    print("Disc %s has %s tracks." % (disc, trackmax[disc]))

for mp3file in glob.glob('*.mp3'):
    match = re.search(mp3filematch, mp3file)
    if match:
        disc = match.group(1)
        tracknumber = match.group(2)
    else:
        match = re.search(mp3filematch_nodisc, mp3file)
        if match:
            disc = 1
            tracknumber = match.group(1)

    audiofile = eyed3.load(mp3file)

    if not albumartist:
        albumartist = audiofile.tag.artist

    audiofile.tag.track_num = (tracknumber, trackmax[disc])
    audiofile.tag.disc_num = (disc, discmax)
    audiofile.tag.comment = ''
    audiofile.tag.album_artist = unicode(albumartist)
    audiofile.tag.save()

    print("Tagged %s" % mp3file)
