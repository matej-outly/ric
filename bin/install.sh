#!/bin/bash

#
# Install all jic gems
#

# Number of arguments
if [ "$#" != "0" ]; then
	echo "Usage: $0"
	exit 1
fi

# Basic setting
script_dir="`cd \"\`dirname \\\"$0\\\"\`\"; pwd`"
root_dir="$script_dir/.."
build_dir="$root_dir/build"

# Install all engines
for engine in ric_account ric_admin ric_advert ric_customer ric_eshop ric_magazine ric_newsletter ric_rolling ric_website; do
	gem install "$build_dir"/"$engine"-*
done
