#!/usr/bin/env bash

# Check if fzf is installed.
if ! command -v fzf &>/dev/null; then
  echo "fzf is not installed. Please install fzf to use this script."
  exit 1
fi

# List commits showing the hash, commit date (with hour and minute) in parentheses, and the commit message.
# The following command uses a custom pretty format with %h (short hash) and %ad (author date),
# formatting the date as "YYYY-MM-DD (HH:MM)".
echo "Select a commit to amend from the list below (using fzf):"
commit_line=$(git log --pretty=format:"%h (%ad) %s" --date=format:"%Y-%m-%d %H:%M" | fzf --height 40% --reverse)
if [ -z "$commit_line" ]; then
  echo "No commit selected. Exiting."
  exit 1
fi

# Extract the commit hash from the selected line (assumes the hash is the first token).
commit_hash=$(echo "$commit_line" | awk '{print $1}')
commit_date=$(echo $commit_line | awk '{print $2 " " $3}')
echo "Selected commit: $commit_hash ($commit_date)"

# Prompt for the new date/time components.
read -p "Enter year (YYYY): " year
read -p "Enter month (MM): " month
read -p "Enter day (DD): " day
read -p "Enter hour (0-23): " hour
read -p "Enter minute (0-59): " minute

# Generate a random seconds value between 0 and 59.
second=$((RANDOM % 60))

# Format the date as "YYYY-MM-DD HH:MM:SS".
commit_date=$(printf "%04d-%02d-%02d %02d:%02d:%02d" "$year" "$month" "$day" "$hour" "$minute" "$second")
echo -e "\nAmending commit $commit_hash with the new date: $commit_date\n"

# Determine the parent of the selected commit.
if ! parent=$(git rev-parse "${commit_hash}^" 2>/dev/null); then
  echo "The selected commit appears to be the root commit. Amending root commits is not supported by this script."
  exit 1
fi

# Start an interactive rebase from the parent of the selected commit.
# We use GIT_SEQUENCE_EDITOR to automatically mark the selected commit for editing.
GIT_SEQUENCE_EDITOR="sed -i '/^pick $commit_hash/ s/^pick/edit/'" git rebase -i "${commit_hash}^"

# At this point, the rebase should stop at the selected commit.
# Amend the commit with the new date.
GIT_COMMITTER_DATE="$commit_date" GIT_AUTHOR_DATE="$commit_date" \
  git commit --amend --no-edit --date="$commit_date"

# Continue the rebase (this will replay any commits after the amended commit).
git rebase --continue

echo -e "\nThe commit $commit_hash has been amended with the new date."
echo "Please review your commit history (e.g., with 'git log') and push your changes manually if desired."
