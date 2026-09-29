#!/usr/bin/env bash
# SongSnatch installer
# https://github.com/xvoidsx/songsnatch
#
# Installs:
#   - yt-dlp via pipx (stays current — YouTube breaks stale versions fast)
#   - deno (yt-dlp's preferred JS runtime)
#   - songsnatch itself to /usr/local/bin
#
# Run: curl -fsSL https://raw.githubusercontent.com/xvoidsx/songsnatch/main/install.sh | bash
##########################################
set -euo pipefail

say() { printf '  -> %s\n' "$*"; }

install_pipx() {
	if command -v pipx >/dev/null 2>&1; then
		say "pipx already installed"
		return 0
	fi
	say "installing pipx..."
	if command -v apt-get >/dev/null 2>&1; then
		sudo apt-get update && sudo apt-get install -y pipx
	elif command -v dnf >/dev/null 2>&1; then
		sudo dnf install -y pipx
	elif command -v pacman >/dev/null 2>&1; then
		sudo pacman -Sy --noconfirm python-pipx
	else
		python3 -m pip install --user pipx
		python3 -m pipx ensurepath
	fi
}

install_ytdlp() {
	export PATH="$HOME/.local/bin:$PATH"
	if command -v yt-dlp >/dev/null 2>&1; then
		say "yt-dlp found — upgrading via pipx..."
		pipx upgrade yt-dlp 2>/dev/null || pipx install yt-dlp
	else
		say "installing yt-dlp via pipx..."
		pipx install yt-dlp
	fi
	pipx ensurepath 2>/dev/null || true
}

install_deno() {
	export PATH="$HOME/.deno/bin:$PATH"
	if command -v deno >/dev/null 2>&1; then
		say "deno already installed"
		return 0
	fi
	say "installing deno..."
	curl -fsSL https://deno.land/install.sh | sh
	if ! grep -q '.deno/bin' "$HOME/.bashrc" 2>/dev/null; then
		echo 'export PATH="$HOME/.deno/bin:$PATH"' >> "$HOME/.bashrc"
		say "added ~/.deno/bin to PATH in .bashrc"
	fi
}

install_songsnatch() {
	local url="https://raw.githubusercontent.com/xvoidsx/songsnatch/main/songsnatch.sh"
	local dest="/usr/local/bin/songsnatch"
	say "installing songsnatch to $dest..."
	sudo curl -fsSL "$url" -o "$dest"
	sudo chmod 0755 "$dest"
	say "done — run: songsnatch <youtube-url>"
}

main() {
	echo "= = = = = SongSnatch installer = = = = ="
	install_pipx
	install_ytdlp
	install_deno
	install_songsnatch
}

main
