#!/usr/bin/env bash
#	SongSnatch
#		- by rav3ndust.xyz
#		- MIT License
# Grabs songs from Youtube and extracts the audio, converts to specified format.
# Uses yt-dlp, saves songs to $HOME/Music
#
# To use it, save it to /usr/bin/songsnatch and run:
#	`songsnatch $url`
# ...where "$url" is the link to your youtube audio track.
##########################################################
set -euo pipefail
title="SongSnatch" 
version="1.5"
url="$1"
ytdlp_bin="yt-dlp"
# default format: mp3
# change this var if you want something else
audio_format="mp3"
# func
hook () {
	# grabs song by URL 
	# URL passed to script as param
	local music_dir="$HOME/Music"
	cd "$music_dir"
       	# we can use either the yt-dlp package from debian repos or the github releases page.
	# if the debpack is failing, switch to the version from github releases page: https://github.com/yt-dlp/yt-dlp	
	"$ytdlp_bin" -x --audio-format mp3 "$url"
	cd "$HOME"
}
notifier () {
	# sends notification to user
	# relies on notify-send
	notify-send "$1" "$2"
}
main () {
	# main function
	local n1="$title"; local n2="Your track has been downloaded."
	echo "$title - version $version" && sleep 1
	echo "URL provided: $url" && echo "Starting download..."
	hook
	echo "Finished. Audio downloaded and converted." && sleep 1
	notifier "$n1" "$n2" 
	exit
}
# -XXX- 
main
# XXX recommend using 'deno' as javascript runtime. 
# will write this into the SongSnatch project at some point
