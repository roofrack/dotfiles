# NOTE: google-chrome... is a pain to update because it won't seem to update with
# all these chrome files left in the system. This script will delete all these files.
# May not be needed on my other computers.

# 1) Run the update command and send the errors to a file...
# yay -S google-chrome 2> delete_these_chrome_files.txt

# 2) Edit this file and remoove lines which don't have file names.
#    Now use vim macros to edit each line (remove unwanted text)
#    Should really make a command that does this automatically (maybe use awk?)

# 3) run this script to remove all these unwanted files...
for f in $(cat ./delete_these_chrome_files.txt); do
  if [[ -e "$f" ]]; then
    printf "%s deleted\n" "$f"
    sudo rm -rf "$f" >/dev/null 2>&1
  fi
done

# 4) Now the update command should work...
# yay google-chrome
