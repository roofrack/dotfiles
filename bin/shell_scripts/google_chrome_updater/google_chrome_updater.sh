# google-chrome... is a pain to update because it wont seem to update with
# all these chrome files left in the system. This script will delete all these files

# Running yay -S google-chrome 2> delete_these_chrome_files.txt
# will put all the file names in a file named delete_these_chrome_files.txt

# Will need to edit this list of files so only the file name is showing.
# Need to write a script for this using awk or something.
# or use vim macros... thats easy.

# Then run yay google-chrome and it should update google-chrome just fine.

for f in $(cat ./delete_these_chrome_files.txt); do
  if [[ -e "$f" ]]; then
    printf "%s deleted\n" "$f"
    sudo rm -rf "$f" >/dev/null 2>&1
  fi
done
# yay google-chrome
