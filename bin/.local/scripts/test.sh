#!/bin/bash

# Check for passphrase argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <ssh_key_passphrase>"
    exit 1
fi

# Variables
PASSPHRASE="$1" # SSH key passphrase passed as the first script argument
REPO="git@gitlab.com:christoph.tech101/dotfiles.git"
DEST="$HOME/dotfiles"
KEY_FILE="$HOME/.ssh/id_rsa" # Update this path to your actual key file
BRANCH="main"

# Function to clone the repo using expect to handle the passphrase
clone_repo_with_passphrase() {
    /usr/bin/expect <<EOF
    set timeout -1
    spawn git clone --recursive -b $BRANCH $REPO $DEST
    expect {
        "*passphrase*" {
            send "$PASSPHRASE\r"
            exp_continue
        }
        eof {
            catch wait result
            exit [lindex \$result 3]
        }
    }
EOF
}

# Ensure the SSH key is used for the operation
export GIT_SSH_COMMAND="ssh -i ${KEY_FILE} -o IdentitiesOnly=yes -o StrictHostKeyChecking=yes"

# Clone the repository if it doesn't exist
if [ ! -d "${DEST}/.git" ]; then
    echo "Cloning repository into ${DEST}"
    clone_repo_with_passphrase
else
    echo "Repository already exists at ${DEST}. Please manually handle updates or ensure it's the correct repository."
fi

