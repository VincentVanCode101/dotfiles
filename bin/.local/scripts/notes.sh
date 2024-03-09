NOTE_PATH=$1

mkdir -p "$NOTE_PATH" 

YEAR=$(date +%Y)
CALENDAR_WEEK=$(date +%V)

FILENAME="note_${YEAR}_W${CALENDAR_WEEK}.md"

FILE_PATH="$NOTE_PATH/$FILENAME"

touch "$FILE_PATH"



GEOMETRY="180x44+0+0"

# Open a new gnome-terminal window with specified geometry and change directory to NOTE_PATH
gnome-terminal --geometry=$GEOMETRY -- bash -c "echo -ne '\033]0;nvim $FILE_PATH\007'; nvim $FILE_PATH; exec zsh"

