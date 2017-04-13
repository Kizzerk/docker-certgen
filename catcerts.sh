#!/bin/bash

##
## Script to use with znc as it needs its whole certificate in one file
## Waits for .pem certificate files to change, then concatinates them
## Note: This script exits if something fails, so it might be a good idea to stop the container it's running when that happens, or deal with it some other good way.
## Note 2: Maybe some way to tell znc about the new certificate is needed?
##

# Directory to read certificates/pem files from
inDir='/znc-cert'
# File to write the final certificate to
outFile='/znc-data/cert.pem'

while true; do
	# If we fail to cat the cert files, just break the loop and exit
	if ! data=$(cat "$inDir"/{key,cert,chain}.pem); then
		echo "Failed to read certificates from '$inDir'." >&2
		break
	fi

	echo "$data" > "$outFile"
	echo "Wrote '$outFile'." >&2

	# Inotifywait waits for inode events (basically file events) such as when a file was modified.
	# Note: the event names aren't necessarily all needed ones. See EVENTS in manual for inotifywait.
	inotifywait -r -e close_write,moved_to "$inDir" || break
	# As inotifywait returns non-zero when something goes wrong (the watched directory doesn't exist for example) we break the loop if that happens

	# Inotifywait will only catch the first modification, so we wait a moment so any possible following ones can finish
	sleep 2
done

# Since inotifywait returns non-zero if the file/directory it's trying to watch doesn't exist, it'd be appropriate to print an error message here:
echo "Exiting $(basename "$0").." >&2
# Note: $(basename "$0") outputs the name of this script
# Note 2: >&2 causes echo to write to STDERR, which is rather appropriate for an error message
