#! /usr/bin/env python
# File: vimmpc.py
# About: Wrapper around basic MPD functionality
# Author: Gavin Gilmour (gavin (at) brokentrain dot net)
# Last Modified: April 10, 2007
# Version: 20070410
# Note: Please see the accompanying README.

import difflib
import os
import re
import sys
import time
from time import gmtime, strftime

import vim
import mpdclient2
from SOAPpy import WSDL
from optparse import OptionParser

DEBUG = False
BUFFERS = {}

def debug(message):
    if DEBUG:
        output("MPC DEBUG: %s" % message)

def output(msg):
    print "[%s] %s" % (strftime("%m/%d/%y %H:%M:%S", gmtime()), msg)

class MPC:

    class Lyrics:

        def __init__(self):
            self.proxy = WSDL.Proxy('http://lyricwiki.org/server.php?wsdl')

        def getLyrics(self):
            track = mpdclient2.connect().currentsong()
            artist = track['artist']
            title = track['title']

            if artist and title:
                if self.proxy.checkSongExists(artist, title):
                    info = self.proxy.getSong(artist, title)
                    return info['lyrics']

            return

    def __init__(self, filename):
        self.filename = filename
        self.buffer = vim.current.buffer
        self.originalbuffer = []
        self.window = vim.current.window
        self.track = {}
        self.status = {}
        self.regex = re.compile(r'#(\d+).*')
        self.lyrics = self.Lyrics()

    def readPlaylist(self):
        self.playlist = mpdclient2.connect().playlistinfo()

    def checkForChange(self):

        # Autofocus playlist?
        if vim.eval(auto_focus) == '1':
            if self.getCurrentTrack() != self.track:
                self.highlightCurrent()

        self.getTrackInfo()
        self.drawStatusbar()

        vim.command('call feedkeys("\x80\xFD\x35")')

    def clearPlaylist(self):
        self.buffer[:] = None
        self.drawBanner()

    def displayPlaylist(self):
        self.clearPlaylist()
        debug("Populating playlist..")

        if playlist_mode == "folded":
            album = None
            artist = None
            palbum = None
            in_fold = False

            for track in self.playlist:
                if track.has_key("album"):
                    album = track["album"]
                if track.has_key("artist"):
                    artist = track["artist"]
                if palbum != None and palbum != album or not album:
                    if in_fold:
                        self.buffer.append("}}}")
                        in_fold = False
                    if album and artist:
                        self.buffer.append("{{{ %s - %s" % (artist, album))
                        in_fold = True
                    palbum = album

                if track.has_key("album"):
                    palbum = track["album"]
                else:
                    if palbum and in_fold:
                        self.buffer.append("}}}")
                        in_fold = False

                if track.has_key("artist") and track.has_key("title"):
                    self.buffer.append("#%s) %s - %s" 
                            % (track["id"], track["artist"], track["title"]))
                else:
                    self.buffer.append("#%s) %s" % (track["id"], track["file"]))
        else:
            for track in self.playlist:
                if track.has_key("artist") and track.has_key("title"):
                    self.buffer.append("#%s) %s - %s" 
                            % (track["id"], track["artist"], track["title"]))
                else:
                    self.buffer.append("#%s) %s" % (track["id"], track["file"]))

        self.originalbuffer = self.buffer[:]

    def drawBanner(self):
        conn = mpdclient2.connect()
        self.buffer[-1] = "Playlist length: %s" % conn.status()['playlist']
        if conn.status().has_key('time'):
            self.buffer.append("Total time: %s" % conn.status()['time'])
        self.buffer.append('-'*25)
        self.buffer.append('')

    def drawStatusbar(self):
        statusText = "%artist - %title (%elapsed/%total)\
                %=Random: [%random] Repeat: [%repeat]"

        totalTime = self.status['time'].split(':')
        currentElapsed = int(totalTime[0])
        trackLength = int(totalTime[1])

        statusText = statusText.replace(" ", "\ ")

        if self.track.has_key('artist') and self.track.has_key('title'):
            artist = self.track['artist'].replace(" ", "\ ")
            title = self.track['title'].replace(" ", "\ ")
            statusText = statusText.replace("%artist", artist)
            statusText = statusText.replace("%title", title)
        else:
            file = self.track['file'].replace(" ", "\ ")
            statusText = statusText.replace("%artist", file)
            statusText = statusText.replace("%title", '')

        statusText = statusText.replace("%random", self.status['random'] and
        'x' or '_')
        statusText = statusText.replace("%repeat", self.status['repeat'] and
        'x' or '_')

        statusText = statusText.replace("%elapsed",
                time.strftime("%M:%S", time.gmtime(currentElapsed)))

        statusText = statusText.replace("%total",
                time.strftime("%M:%S", time.gmtime(trackLength)))

        vim.command("silent! setlocal statusline=%s" % statusText)

    def getFocusId(self):
        cursor_row, cursor_col = self.window.cursor
        self.current_line = self.buffer[cursor_row-1]
        current_char = self.current_line[cursor_col-1]

        # It'd be nice if we could use some sort of model instead of this junk
        if self.current_line.startswith("#"):
            return self.regex.findall(self.current_line)[0]

        return None

    def playSelection(self):
        id = self.getFocusId()
        if id:
            mpdclient2.connect().playid(int(id))
            self.highlightCurrent()

    def highlightCurrent(self):
        id = mpdclient2.connect().currentsong()['id']
        vim.command("match none")
        vim.command("call search('^#%s)', 'w')" % id)
        vim.command("exe 'match Visual /^#%s.*/'" % id)

        # Open a fold if we're in folded mode
        if playlist_mode == "folded":

            # Don't open a fold if the current track isn't IN one!
            if vim.eval("foldlevel('.')") != '0':
                vim.command("normal zo")

        vim.command("normal z.")

    def diffPlaylist(self):
        output('\n'.join(difflib.context_diff(self.originalbuffer,
            self.buffer)))

    def destroyPlaylist(self):
        debug('Cleaning up buffer')
        vim.command('au! BufDelete ' + self.filename)
        vim.command('silent! bdelete! ' + self.filename)
        MPC_removeBuffer(self.filename)

    def playPause(self):
        self.getTrackInfo()
        if self.status['state'] == 'stop' or self.status['state'] == 'pause':
            mpdclient2.connect().play()
        elif self.status['state'] == 'play':
            mpdclient2.connect().pause(1)

    def stop(self):
        mpdclient2.connect().stop()

    def next(self):
        mpdclient2.connect().next()
        self.highlightCurrent()

    def prev(self):
        mpdclient2.connect().previous()
        self.highlightCurrent()

    def update(self):
        mpdclient2.connect().update()
        output("Updating database..")

    def showLyrics(self):
        filename = "Lyrics"
        exists = MPC_createBuffer(filename, lyrics_type, 
                lyrics_direction, lyrics_size, "lyrics")

        if not exists:
            lyrics = self.lyrics.getLyrics()

            if lyrics:
                debug("Opening lyrics buffer for '%s'" % filename)
                buffer = vim.current.buffer
                for line in lyrics.split('\n'):
                    buffer.append(line)
                vim.command("silent! wincmd w")
            else:
                vim.command('au! BufDelete ' + filename)
                vim.command('silent! bdelete! ' + filename)
                MPC_removeBuffer(filename)
                output("No lyrics found!")
        else:
            debug("Closing '%s'" % filename)
            mpc = MPC_lookupBuffer(filename)
            vim.command('au! BufDelete ' + filename)
            vim.command('silent! bdelete! ' + filename)
            MPC_removeBuffer(filename)

    def toggleShuffle(self):
        self.getTrackInfo()
        if self.status['random']:
            mpdclient2.connect().random(0)
            output("Random off")
        else:
            mpdclient2.connect().random(1)
            output("Random on")

    def toggleRepeat(self):
        self.getTrackInfo()
        if self.status['repeat']:
            mpdclient2.connect().repeat(0)
            output("Repeat off")
        else:
            mpdclient2.connect().repeat(1)
            output("Repeat on")

    def showInfo(self):
        id = self.getFocusId()
        if id:
            output(mpdclient2.connect().playlistid(int(id)))

    def updatePlaylist(self):
        self.clearPlaylist()
        self.readPlaylist()
        self.displayPlaylist()

    def getTrackInfo(self):
        conn = mpdclient2.connect()
        conn_status = conn.status()
        self.status = {
                'time' : conn_status['time'],
                'state' : conn_status['state'],
                'random' : int(conn_status['random']),
                'repeat' : int(conn_status['repeat']),
                'updating' : int(conn_status.has_key('updating_db'))
        }
        self.track = conn.currentsong()

    def getCurrentTrack(self):
        conn = mpdclient2.connect()
        return conn.currentsong()


def MPC_createBuffer(filename, type, direction, size, name):

    try:
        vim.command("let dummy = buflisted(\"%s\")" % filename)

        if vim.eval("dummy") == '1':
            debug("File '%s' already exists!" % filename)
            return 1
        else:
            debug("Buffer '%s' doesn't exist!" % filename)

            vim.command("silent! %s %s %s %s" % 
                    (type, size, direction, filename))

            vim.command("silent! setlocal buftype=nofile")
            vim.command("silent! setlocal nonumber")
            vim.command("silent! setlocal nospell")
            vim.command("silent! setlocal cul")
            vim.command("silent! setlocal noswapfile")
            vim.command("silent! setlocal nowrap")
            vim.command("silent! setlocal winfixheight")

            # Special considerations for lyrics window
            if name == "lyrics":
                vim.command("silent! setlocal bufhidden=delete")
                vim.command("silent! setlocal titlestring=Lyrics")
                vim.command("silent! setlocal tw=50")
            else:

                vim.command("silent! setlocal titlestring=Playlist")
                vim.command('silent! setlocal updatetime=1000')

                vim.command('autocmd BufDelete %s :python \
                        MPC_lookupBuffer("%s").destroyPlaylist()' %
                        (filename, filename))

                vim.command('autocmd CursorHold * :python \
                        MPC_lookupBuffer("%s").checkForChange()' %
                        filename)

                # Remote
                vim.command('nnoremap <buffer> <silent> %s :python \
                        MPC_lookupBuffer("%s").playPause()<CR>' %
                        (remote_play_pause_key, filename))

                vim.command('nnoremap <buffer> <silent> %s :python \
                        MPC_lookupBuffer("%s").stop()<CR>' %
                        (remote_stop_key, filename))

                vim.command('nnoremap <buffer> <silent> %s :python \
                        MPC_lookupBuffer("%s").next()<CR>' %
                        (remote_next_key, filename))

                vim.command('nnoremap <buffer> <silent> %s :python \
                        MPC_lookupBuffer("%s").prev()<CR>' %
                        (remote_prev_key, filename))

                vim.command('nnoremap <buffer> <silent> %s :python \
                        MPC_lookupBuffer("%s").toggleShuffle()<CR>' %
                        (remote_toggle_random_key, filename))

                vim.command('nnoremap <buffer> <silent> %s :python \
                        MPC_lookupBuffer("%s").toggleRepeat()<CR>' %
                        (remote_toggle_repeat_key, filename))

                vim.command('nnoremap <buffer> <silent> %s :python \
                        MPC_lookupBuffer("%s").update()<CR>' %
                        (remote_update_key, filename))

                # Playlist specific
                vim.command('nnoremap <buffer> <silent> %s :python \
                        MPC_lookupBuffer("%s").playSelection()<CR>' %
                        (play_selection_key, filename))

                vim.command('nnoremap <buffer> <silent> %s :python \
                        MPC_lookupBuffer("%s").highlightCurrent()<CR>' % 
                        (focus_current_track_key, filename))

                vim.command('nnoremap <buffer> <silent> %s :python \
                        MPC_lookupBuffer("%s").updatePlaylist()<CR>' % 
                         (refresh_playlist_key, filename))

                vim.command('nnoremap <buffer> <silent> %s :python \
                        MPC_lookupBuffer("%s").showInfo()<CR>' % 
                         (show_info_key, filename))

                vim.command('nnoremap <buffer> <silent> %s :python \
                        MPC_lookupBuffer("%s").diffPlaylist()<CR>' % 
                         (diff_key, filename))

                vim.command('nnoremap <buffer> <silent> %s :python \
                        MPC_lookupBuffer("%s").showLyrics()<CR>' % 
                         (show_lyrics_key, filename))

            return 0
    except:
        debug("Error: '%s'" % sys.exc_info()[0])

def MPC_removeBuffer(filename):
    if BUFFERS.has_key(filename):
        debug ("Deleting '%s' from buffer list" % filename)
        del BUFFERS[filename]
    else:
        debug("Lookup: unable to find match for '%s'" % filename)

def MPC_lookupBuffer(filename):
    if BUFFERS.has_key(filename):
        instance = BUFFERS[filename]
        debug("Found existing instance: '%s'" % instance)
        return instance
    else:
        debug("Lookup: unable to find match for '%s'" % filename)
    return None

def MPC_init(filename):
    exists = MPC_createBuffer(filename, window_type, window_direction,
            window_size, "playlist")

    if not exists:
        debug("Opening new buffer for '%s'" % filename)

        mpc = MPC(filename)
        mpc.readPlaylist()
        mpc.displayPlaylist()
        mpc.highlightCurrent()

        BUFFERS[filename] = mpc
    else:
        debug("Closing '%s'" % filename)
        mpc = MPC_lookupBuffer(filename)
        mpc.destroyPlaylist()

def MPC_setVariable(option, value):
    vim.command("let dummy = exists(\"%s\")" % option)

    if vim.eval("dummy") == '1':
        value = vim.eval(option)
        debug("Option '%s' exists, using the value '%s'" % (option, value))
    else:
        debug("Option '%s' doesn't exist, using default value '%s'" % (option, value))

    return value


# Set default variables unless they're otherwise configured elsewhere.
# NOTE: These are default values only, and should not be modified.

# Playlist
remote_play_pause_key = MPC_setVariable("g:mpc_remote_play_pause_key", "p")
remote_stop_key = MPC_setVariable("g:mpc_remote_stop_key", "s")
remote_next_key = MPC_setVariable("g:mpc_remote_next_key", "l")
remote_prev_key = MPC_setVariable("g:mpc_remote_prev_key", "h")
remote_toggle_random_key = MPC_setVariable("g:mpc_remote_toggle_random_key", "r")
remote_toggle_repeat_key = MPC_setVariable("g:mpc_remote_toggle_repeat_key", "e")
remote_update_key = MPC_setVariable("g:mpc_remote_update_key", "u")

# Playlist
play_selection_key = MPC_setVariable("g:mpc_play_selection_key", "<CR>")
focus_current_track_key = MPC_setVariable("g:mpc_focus_current_track_key", "<C-L>")
show_info_key = MPC_setVariable("g:mpc_show_info_key", "<C-I>")
show_lyrics_key = MPC_setVariable("g:mpc_show_lyrics_key", "<C-H>")
refresh_playlist_key = MPC_setVariable("g:mpc_refresh_playlist_key", "<C-R>")

# General
window_size = MPC_setVariable("g:mpc_window_size", "10")
window_direction = MPC_setVariable("g:mpc_window_direction", "split")
window_type = MPC_setVariable("g:mpc_window_type", "new") # :help opening-window

lyrics_size = MPC_setVariable("g:mpc_lyrics_size", "50")
lyrics_direction = MPC_setVariable("g:mpc_lyrics_direction", "vsplit")
lyrics_type = MPC_setVariable("g:mpc_lyrics_type", "botright") # :help opening-window

# Other
playlist_mode = MPC_setVariable("g:mpc_playlist_mode", "folded") # standard, folding
#folding_mode = MPC_setVariable("g:mpc_folding_mode", "hybrid") # hybrid, hierarchy
auto_focus = MPC_setVariable("g:mpc_auto_focus", "1")

# Experimental
diff_key = MPC_setVariable("g:mpc_diff", "<C-D>")

# vim: set et sw=4 st=4 tw=79:
