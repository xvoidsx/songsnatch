#!/usr/bin/env bash
#
#	SongSnatch
#
#		- by rav3ndust.xyz
#		- MIT License
# Grabs songs from Youtube and extracts the audio, converts to specified format.
# Uses yt-dlp (via pipx — stays current, YouTube breaks stale versions fast),
# saves songs to $HOME/Music. deno is the preferred JS runtime for yt-dlp.
#
# Install: curl -fsSL https://raw.githubusercontent.com/xvoidsx/songsnatch/main/install.sh | bash
# Then run: `songsnatch $url`
# ...where "$url" is the link to your youtube audio track.
##########################################################
set -euo pipefail
title="SongSnatch"
version="1.6"
url="${1:-}"
ytdlp_bin="yt-dlp"
# default format: mp3
# change this var if you want something else
audio_format="mp3"

# func
check_deps() {
	# yt-dlp via pipx lands in ~/.local/bin, deno in ~/.deno/bin —
	# make sure both are findable
	export PATH="$HOME/.local/bin:$HOME/.deno/bin:$PATH"
	if ! command -v "$ytdlp_bin" >/dev/null 2>&1; then
		echo "$title: $ytdlp_bin not found." >&2
		echo "install it with: pipx install yt-dlp" >&2
		echo "or run the SongSnatch installer:" >&2
		echo "  curl -fsSL https://raw.githubusercontent.com/xvoidsx/songsnatch/main/install.sh | bash" >&2
		exit 1
	fi
}

hook () {
	# grabs song by URL
	# URL passed to script as param
	local music_dir="$HOME/Music"
	mkdir -p "$music_dir"
	cd "$music_dir"
	"$ytdlp_bin" -x --audio-format "$audio_format" "$url"
	cd "$HOME"
}
notifier () {
	# sends notification to user
	# relies on notify-send
	notify-send "$1" "$2" 2>/dev/null || true
}
usage() {
	echo "usage: songsnatch <youtube-url>"
	echo "  grabs the audio, converts to $audio_format, saves to \$HOME/Music"
}
main () {
	# main function
	if [ -z "$url" ]; then usage; exit 2; fi
	check_deps
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
