#!/bin/sh

programname=$0

display_help() {
    echo
    echo "usage: $programname -dn <device name> -ak <api key> -u <apiurl> "
    echo "         [-tmp <temp dir>] [-dest <dest dir>]"
    echo
    echo "  -dn --devicename <device name>"
    echo "      the name of the device to be installed"
    echo "      as it will appear on iottly cloud"
    echo
    echo "  -ak --apikey <API key>"
    echo "      the API key to interact with iottly cloud apis"
    echo "      how to obtain the API key from iottly cloud:"
    echo "      - navigate to your project"
    echo "      - click on 'open' on the top right corner"
    echo "      - click twice on the right arrow to navigate to the API panel"
    echo "      - create an API key with 'Create new API key'"
    echo
    echo "  -u --apiurl <apihost>"
    echo "      how to obtain the apiurl from iottly cloud:"
    echo "      - navigate to your project"
    echo "      - click on 'open' on the top right corner"
    echo "      - the apiurl is located at the top of the panel"
    echo
	  echo "  [-tmp <temp dir>]"
    echo "      temp dir to download the tar.gz into"
    echo "      - defaults to '/tmp'"
    echo
    echo "  [-dest <dest dir>]"
    echo "      dest dir to install iottly agent into"
    echo "      - defaults to '/opt'"
    echo
    echo "  -h --help"
    echo "      display help"
    echo
    echo "Returns: 0 if successful, 1 otherwise."
}

# constants
LOGFILE="/tmp/iottlyinstaller.log"
ERRORRETURNCODE=1
OKRETURNCODE=0
NEWLINE=$'\n'

# defaults:
tempdir="/tmp"
destdir="/opt"

log(){
  msg="$(date) - iottly installer script - "${1+"$@"}
  echo $msg
  echo $msg >> $LOGFILE
}

abort() {
  msg="ERROR - "${1+"$@"}
  log $msg
  exit $ERRORRETURNCODE
}

deviceargs()
{
cat <<EOF
{
    "name": "$1"
}
EOF
}

# check we can write the logs
touch $LOGFILE &> /dev/null || { echo "ERROR: can't write to the log file."; exit 1; }

if [ "$#" -eq 0 ]; then
  display_help
  exit $ERRORRETURNCODE
fi


log "#########################################"
log "installer started"

while :
do
    case "$1" in
      -h | --help)
		  display_help
		  exit 0
		  ;;
      -dn | --devicename)
      [ ! -z "$2" ] || abort "missing device name"
		  devicename="$2"
		  shift 2
		  ;;
      -ak | --apikey)
      [ ! -z "$2" ] || abort "missing api key"
		  apikey="$2"
		  shift 2
		  ;;
      -u | --apiurl)
      [ ! -z "$2" ] || abort "missing api url"
		  apiurl="$2"
		  shift 2
		  ;;
      -tmp)
      [ ! -z "$2" ] || abort "missing tmp dir"
		  tempdir="$2"
		  shift 2
		  ;;
      -dest)
      [ ! -z "$2" ] || abort "missing dest dir"
      [ -d $2 ] || abort "$1: dir $2 doesn't exist"
		  destdir="$2"
		  shift 2
		  ;;
      --) # End of all options
		  shift
		  break
		  ;;
      -*)
      display_help
		  abort "Unknown option: $1"
		  ;;
      *)  # No more options
      break
		  ;;
    esac
done

# assert variables
[ ! -z "$devicename" ] || abort "missing device name"

[ ! -z "$apikey" ] || abort "missing api key"
authheader="Authentication: bearer $apikey"

[ ! -z "$apiurl" ] || abort "missing api url"
inspectprojecturl="$apiurl/inspect"
createdeviceurl="$apiurl/device/"

# check work dirs and permissions
[ -d $tempdir ] || abort "dir $tempdir doesn't exist"
touch "$tempdir/test" || abort "need write permissions on $tempdir"
rm "$tempdir/test"
[ -d $destdir ] || abort "dir $destdir doesn't exist"
touch "$destdir/test" || abort "need write permissions on $destdir"
rm "$destdir/test"

# inspect the project api to get the agent download url
log "get agent download url from: ${inspectprojecturl}"
projectdata=$(wget -q -a $LOGFILE -O- \
              --server-response \
              --no-check-certificate \
              --header="$authheader" \
              "$inspectprojecturl" || \
              abort "Can't connect with apis $createdeviceurl")

projectgetagenturl=$(echo $projectdata | \
                     sed -n 's/.*"projectgetagenturl": "\([^"]*\)".*/\1/p')

agentfile=$(echo $projectdata | \
                    sed -n 's/.*"agentfile": "\([^"]*\)".*/\1/p')


agentapihost=$(echo $projectdata | \
                    sed -n 's/.*"agentapihost": "\([^"]*\)".*/\1/p')

[ ! -z "$projectgetagenturl" ] || \
    abort "inspecting the project with $inspectprojecturl"
[ ! -z "$agentfile" ] || \
    abort "inspecting the project with $inspectprojecturl"
[ ! -z "$agentapihost" ] || \
    abort "inspecting the project with $inspectprojecturl"

# post to the device api to create the device and obtain a pair_code

log "create the device posting to: $createdeviceurl"
devicedata="$(deviceargs $devicename)"

deviceregdata=$(wget -q -a $LOGFILE -O- \
                  --server-response \
                  --no-check-certificate \
                  --header="$authheader" \
                  --post-data="$devicedata" \
                  "$createdeviceurl"  \
                  || abort "Can't connect with apis $createdeviceurl")


paircode=$(echo $deviceregdata | \
                     sed -n 's/.*"pair_code": "\([^"]*\)".*/\1/p')

[ ! -z "$paircode" ] || abort "creating the device with $createdeviceurl"

# download the agent tarball

log "download the agent tarball from: $projectgetagenturl"
wget -q -a $LOGFILE -O "$tempdir/$agentfile" \
  --server-response \
  --no-check-certificate \
  "$projectgetagenturl"

downloadresponse=$?
[ "$downloadresponse" -eq "0" ] || abort "downloading the agent tarball"
[ -f "$tempdir/$agentfile" ] || abort "downloading the agent tarball"


# extract the agent tarball
log "extract the agent tarball $tempdir/$agentfile to $destdir"

tar -xzf "$tempdir/$agentfile" -C "$destdir" || abort "can't extract tarball"


# configure the agent and register it to iottly

log "run the agent 'configure.sh' script"

"$destdir/iottly.com-agent/configure.sh" \
  -c $paircode \
  -rh $agentapihost \
  --skip-human-check \
  || abort "in $destdir/iottly.com-agent/configure.sh. see $LOGFILE"


log "installation successful."
