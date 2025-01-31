#!/bin/bash

# Check root access
if [[ "${UID}" -ne 0 ]]
then 
	echo "Please run with sudo or root."
	exit 1
fi


# Check if atleast one arg else guide user
if [[ "${#}" -lt 1 ]]
then 
	echo "Run Script as --> ${0} USER_NAME [DESCRIPTION]..."
	echo "Create a user with name USER_NAME and description for field of DESCRIPTION"
	exit 1
fi


# Store 1st arg as username
USER_NAME="${1}"


# If more than one arg, treat as comments
shift
DESCRIPTION="${@}"


# Create Password
PASS=$(</dev/urandom tr -dc 'A-Za-z0-9' | head -c 10)


# Create user
useradd -c "${DESCRIPTION}" -m $USER_NAME


# Check if user created or not
if [[ $? -ne 0 ]]
then 
	echo "The Account could not be created"
	exit 1
fi


# Set password
echo $PASS | passwd --stdin $USER_NAME


# Check if pass set or not
if [[ $? -ne 0 ]]
then 
	echo "Password could not be set"
	exit 1
fi


# Force password change
passwd -e $USER_NAME


# Display username, pass, and host
echo
echo -e "Username: $USER_NAME\n"
echo -e "Password: $PASS\n"
echo "Hostname: $(hostname)"


