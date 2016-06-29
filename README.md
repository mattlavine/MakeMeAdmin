# MakeMeAdmin

###### This script will promote the local user account to admin, but only if assigned to that mac.

___

**Copyright (c) 2016, JAMF Software, LLC.  All rights reserved.**

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the JAMF Software, LLC nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
___
MakeMeAdmin.sh was created inorder to esure that a user that has the rights to be a local admin on their mac doesn't try to become an admin on other systems.

This script will accomplish the following:
* Check to See if Self Service User is the same as the one assigned to this computer in the JSS
* If so, will grant the local user currently login in admin rights
* If not, will get a prompt that this computer is not assigned to them

In order for this script to work effectively you will need to have Login enabled for Self Service and will need to add the JSS API User account & Password to script variables $4 & $5 in the JSS, as well as enter the jssURL below.

Exit Code Descriptions:
* exit 1 - User Running Policy Doesn't Match User Assigned in JSS
* exit 2 - No JSS User Assigned in JSS
* exit 3 - JSS is not Accessible
* exit 5 - Unknown Error

Requirements:
* Must specify the JSS URL
* JSS Username and Password must be specified in Policy
* The Username stored in *User & Location* within the computer object must match the username of the user logging into Self Service


Written by: Joshua Roskos | Professional Services Engineer | JAMF Software

Created On: May 26th, 2016 | Updated On: May 27th, 2016

___

**Version History**

> v1.0 - uploaded MakeMeAdmin.sh

