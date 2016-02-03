#!/bin/sh
#
#  new-post.sh - Start a new Jekyll post.
#  Copyright (C) 2016  Marco van Zwetselaar <io@zwets.it>
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#  Created on 2016-02-03

# Function to exit this script with an error message on stderr
err_exit() {
	echo "$(basename "$0"): $*" >&2
	exit 1
}

# Function to show usage information and exit
usage_exit() {
	echo
	echo "Usage: $(basename $0) TITLE"
	echo
	echo "  Create a new Jekyll post with title TITLE."
	echo
	exit ${1:-1}
}

# Parse options

while [ $# -ne 0 -a "$(expr "$1" : '\(.\).*')" = "-" ]; do
	case $1 in
	--help)
		usage_exit 0
		;;
	*) usage_exit
		;;
	esac
	shift
done

# Parse arguments

[ $# -eq 1 ] || usage_exit
TITLE="$1"

POSTS_DIR="_posts"
[ -d "$POSTS_DIR" ] || err_exit "no such directory: $POSTS_DIR"

FILENAME="$POSTS_DIR/$(date -I)-$(echo "$TITLE" | tr -d "',.;:" | tr '[A-Z] ' '[a-z]-').md"

# Check that file does not exist

if [ ! -f "$FILENAME" ]; then
	cat >"$FILENAME" <<-EOF
	---
	title: $TITLE
	layout: post
	excerpt: "@@@ EDIT @@@"
	published: false
	---
	EOF
fi

# Spawn vi on it

vi "$FILENAME"

