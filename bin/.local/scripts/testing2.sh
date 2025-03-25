#!/usr/bin/expect -f

# Check if a passphrase was provided as a command-line argument
if {$argc != 1} {
    puts "Usage: script_name passphrase"
    exit 1
}

# Set the passphrase to the first command-line argument
set passphrase [lindex $argv 0]

# Add your SSH key
spawn ssh-add
expect "Enter passphrase for"
send "$passphrase\r"
expect "Identity added:"
expect eof

