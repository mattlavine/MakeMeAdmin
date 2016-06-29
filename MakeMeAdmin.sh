#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
# Copyright (c) 2016, JAMF Software, LLC.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met:
#               * Redistributions of source code must retain the above copyright
#                 notice, this list of conditions and the following disclaimer.
#               * Redistributions in binary form must reproduce the above copyright
#                 notice, this list of conditions and the following disclaimer in the
#                 documentation and/or other materials provided with the distribution.
#               * Neither the name of the JAMF Software, LLC nor the
#                 names of its contributors may be used to endorse or promote products
#                 derived from this software without specific prior written permission.
#
#       THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
#       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 
# This script will accomplish the following:
# 			- Check to See if Self Service User is the same as the one assigned to this 
#			  computer in the JSS
#			- If so, will grant the local user currently login in admin rights
#			- If not, will get a prompt that this computer is not assigned to them
#
# In order for this script to work effectively you will need to have Login enabled for
# Self Service and will need to add the JSS API User account & Password to script
# variables $4 & $5 in the JSS, as well as enter the jssURL below.
#
# Exit Code Descriptions:
# 			exit 1 - User Running Policy Doesn't Match User Assigned in JSS
# 			exit 2 - No JSS User Assigned in JSS
# 			exit 3 - JSS is not Accessible
#			exit 5 - Unknown Error
#
# Written by: Joshua Roskos | Professional Services Engineer | JAMF Software
#
# Created On: May 26th, 2016
# Updated On: May 27th, 2016
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# VARIABLES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

jssUser="$4"
jssPass="$5"
jssURL="https://jss.acme.com:8443"

loggedInUser=$( stat -f%Su /dev/console )
compSerial=$( system_profiler SPHardwareDataType | grep Serial |  awk '{print $NF}' )
jssCompUser=$( /usr/bin/curl -s -u ${jssUser}:${jssPass} ${jssURL}/JSSResource/computers/serialnumber/${compSerial}/subset/location | /usr/bin/xpath "//computer/location/username/text()" )
selfServiceUser=$( defaults read /Users/${loggedInUser}/Library/Preferences/com.jamfsoftware.selfservice.plist LastLoggedInUser "" )

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# APPLICATION
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

echo "Current Self Service User: ${selfServiceUser}"
echo "Current user assigned in JSS: ${jssCompUser}"

## check is JSS is accessible
/usr/bin/sudo /usr/local/bin/jamf checkJSSConnection

if [[ "$?" == "0" ]]; then
    echo "JSS is Accessible."
else
    echo "Error Code: 3 - JSS is currently Unavailble."
    exit 3
fi

## check if variable jssCompUser is blank, if so exit 2
if [[ "${jssCompUser}" == "" ]]; then
    echo "Error Code: 2 - No user associated with device in the JSS."
    exit 2
fi

## check if self service user matches user assigned to computer in jss
if [[ "${jssCompUser}" == "${selfServiceUser}" ]]; then
	echo "User is authorized to become an administrator on this computer."
	echo "Granting local admin rights to user: ${jssCompUser} as ${loggedInUser}..."
	# give current logged user admin rights
	/usr/sbin/dseditgroup -o edit -a ${loggedInUser} -t user admin
	exit 0
else
	echo "Error Code: 1 - User is not authorized to become an administrator on this computer!"
	/usr/bin/osascript -e 'Tell application "System Events" to display dialog "You are not authorized to become a local admin on this computer! \n\nQuestions, please contact the Help Desk." with text buttons {"OK"} default button "OK" with icon 0'
	exit 1
fi

echo "Error Code: 5 - We shouldn't have gotten this far, unknown error."
exit 5