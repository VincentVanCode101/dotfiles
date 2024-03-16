NOTE_PATH=$1

mkdir -p "$NOTE_PATH" 

YEAR=$(date +%Y)
CALENDAR_WEEK=$(date +%V)

FILENAME="note_${YEAR}_W${CALENDAR_WEEK}.md"

FILE_PATH="$NOTE_PATH/$FILENAME"

# Check if file already exists to avoid overwriting
if [ ! -f "$FILE_PATH" ]; then
    cat <<EOF > "$FILE_PATH"
---
id: note_${YEAR}_W${CALENDAR_WEEK}
aliases: 
tags:
  - weekly-notes
links: "[[weekly-notes]]"
---

EOF
fi

GEOMETRY="180x44+0+0"

gnome-terminal --geometry=$GEOMETRY -- bash -c "echo -ne '\033]0;nvim $FILE_PATH\007'; cd $NOTE_PATH && nvim $FILENAME; exec zsh"

