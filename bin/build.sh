#!/bin/bash

#
# Build all RIC gems
#

# Number of arguments
if [ "$#" != "0" ]; then
	echo "Usage: $0"
	exit 1
fi

# Basic setting
script_dir="`cd \"\`dirname \\\"$0\\\"\`\"; pwd`"
root_dir="$script_dir/.."
output_dir="$root_dir/build"

# Make output directory
mkdir -p "$output_dir"

# All engines
for engine in ric_account ric_admin ric_advert ric_assortment ric_contact ric_customer ric_devise ric_eshop ric_gallery ric_journal ric_league ric_magazine ric_newsletter ric_notification ric_partnership ric_payment ric_portal ric_reservation ric_user ric_website; do
	cd "$root_dir/$engine"
	gem build $engine.gemspec
	mv *.gem "$output_dir"
done

