#!/bin/bash

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    Enforces uninstalls of a specific application on a linux device
#% 
#% DESCRIPTION
#%
#%    This remediation script will check which linux flavor is on the machine and then if it exists it will continue to uninstall the software.
#%
#% USAGE
#%    ./remediation.sh
#%    You will need to set the APP_NAME variable to the application name of your choosing. 
#================================================================
#- IMPLEMENTATION

# First identify what OS/Distro we're on

DISTRO=$(grep 'Ubuntu 22.04.1 LTS' /etc/os-release |cut -d "=" -f2|head -1|tr -d '"')
DISTRO_UNINSTALL=""
APP_NAME="FortiClient" # Any application name ex- Forticlient

if [ "${DISTRO}" = "alpine" ]; then
    CHECK="apk -e info|grep -i $forticlient"
    DISTRO_UNINSTALL="apk del $forticlient"
elif [ "${DISTRO}" = "Ubuntu" ]; then
    CHECK="dpkg -l |grep -i $"
    DISTRO_UNINSTALL="dpkg –-remove $forticlient"
elif [ "${DISTRO}" = "gentoo" ]; then
    CHECK="equery list|grep -i $f"
    DISTRO_UNINSTALL="emerge --deselect $forticlient"
elif [ "${DISTRO}" = "fedora" ]; then
    CHECK="dnf list installed|grep -i $forticlient"
    DISTRO_UNINSTALL="dnf remove $forticlient"
else
    die "Unsupported OS/Distro. DISTRO=${DISTRO}"
fi

if [ -n "${CHECK}" ]; then
  echo "Uninstalling $fortiClient" 
  $DISTRO_UNINSTALL
  echo "Uninstall of $fortiClient Complete"
  exit 0
fi