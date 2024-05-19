gitFilesToAdd=$(git status -s | grep -E '^\?\? |^ [A-Z] ')

selectedFile=$(echo "$gitFilesToAdd" | fzf --preview '
  file={2}; 
  # Check if the file exists in the HEAD revision
  if git ls-files --error-unmatch "$file" > /dev/null 2>&1; then
    # If file exists in HEAD, check if it is a directory or a file
    if [ -d "$file" ]; then 
      # If it is a directory, list files and show git diff for each
      for f in $(find "$file" -type f); do 
        echo "----- $f -----"; 
        git diff --color=always HEAD "$f"; 
      done
    else 
      # If it is a single file, show git diff
      git diff --color=always HEAD "$file"
    fi
  else
    # If the file is not in HEAD (new file), display its contents using cat
    if [ -f "$file" ]; then
      cat "$file"
    else
      echo "File does not exist or is not tracked: $file"
    fi
  fi
')

fileToAdd=$(echo $selectedFile | awk '{print $2}')
git add $fileToAdd
