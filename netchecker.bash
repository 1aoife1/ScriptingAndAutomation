#!/bin/bash

myIP=$(bash IPADDRESS.bash)

function helpmenu() {
  echo ""
  echo " HELP MENU "
  echo ""
  echo "-n: Add -n as an argument for this script to use nmap"
  echo "   external: External NMAP scan"
  echo "   internal: Internal NMAP scan"
  echo ""
  echo "-s: Add -s as an argument for this script to use ss"
  echo "   external: External ss(Netstat) scan"
  echo "   internal: Internal ss(Netstat) scan"
  echo ""
  echo "Usage: bash networkchecker.bash -n/-s external/internal"
  echo ""
}

# Return ports that are serving to the network
function ExternalNmap(){
  rex=$(nmap "${myIP}" | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
}

# Return ports that are serving to localhost
function InternalNmap(){
  rin=$(nmap localhost | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
}

# Only IPv4 ports listening from network
function ExternalListeningPorts(){
  elpo=$(ss -ltpn | awk -F"[[:space:]:(),]+" '/LISTEN/ && !/127\.0\.0\./ {print $5,$9}' | tr -d "\"")
}

# Only IPv4 ports listening from localhost
function InternalListeningPorts(){
  ilpo=$(ss -ltpn | awk  -F"[[:space:]:(),]+" '/127.0.0./ {print $5,$9}' | tr -d "\"")
}

if [[ $# -ne 2 ]]; then
  helpmenu
  exit 1
fi

mode=""
scope=""

while getopts ":n:s:" opt; do
  case "$opt" in
    n)
      mode="n"
      scope="$OPTARG"
      ;;
    s)
      mode="s"
      scope="$OPTARG"
      ;;
    \?)
      helpmenu
      exit 1
      ;;
  esac
done

if [[ "$scope" != "internal" && "$scope" != "external" ]]; then
  helpmenu
  exit 1
fi

if [[ "$mode" == "n" ]]; then
  if [[ "$scope" == "external" ]]; then
    ExternalNmap
    echo "$rex"
  else
    InternalNmap
    echo "$rin"
  fi
elif [[ "$mode" == "s" ]]; then
  if [[ "$scope" == "external" ]]; then
    ExternalListeningPorts
    echo "$elpo"
  else
    InternalListeningPorts
    echo "$ilpo"
  fi
else
  helpmenu
  exit 1
fi