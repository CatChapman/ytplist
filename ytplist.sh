#!/bin/bash

# TODO:
# prompt for desired directory? OR...
# create a config file that keeps desired directory
# make this executable from aywhere?
# regex for YT playlist URLS
# (?:(?:PL|LL|EC|UU|FL|RD|UL|TL|PU|OLAK5uy_)[0-9A-Za-z-_]{10,}|RDMM)
# validate proper playlist URLs?
# I cannot get the above regex to play nicely and idk why lol


playlist_url=$1

#testing for input; if no input, ask for input

while [ -z "$playlist_url" ]
  do
    echo "Please enter the playlist URL or playlist ID, or type \"quit\" to quit."
    read playlist_url
    if [ "$playlist_url" == "quit" ] || [ "$playlist_url" == "q" ]
      then
      echo "Bye!"
      exit 1
    fi
  done


echo "Okay, working..."

# TIL about tee, so now I don't have to run it in simulation mode to get tempID.txt. stonks!! much faster.

yt-dlp -f "ba" -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' $playlist_url | tee tempID.txt


getpldir () {
  pldir=$(cat tempID.txt | grep "\[download\] Downloading playlist")
  #extracts a relevant line from tempID.txt

  pldir="${pldir/\[download\]\ Downloading\ playlist\:\ /}"
  #this removes all the unnecessary stuff to extract the playlist title so fancy_ytplist.sh knows where to dump the update.sh script
  echo $pldir
}


dir=$(getpldir)

script="update.sh"

plname=$dir #duplicating this var before I add the slash so I can use it to name the m3u file
# have to put the trailing / in the var itself otherwise it complains
dir="$dir/"
# have to put quotes around the variables when called otherwise it complains

# testing for bad URLs
if [ -z "$plname" ] #if the getpldir script returns nothing, we will quit
  then
  echo "Unable to extract playlist name from URL. Please check that your URL is valid."
  rm tempID.txt
  exit 1
fi

rm tempID.txt #removing tempID file for cleanliness



# staging for m3u playlist generation
now=$(date "+%Y-%m-%d-%M") #timestamps are cool and good
cd "$dir" #changing to newly created directory because it's simpler this way

ls | grep -v \\.sh | grep -v \\.m3u >> "$now"_"$plname".m3u #ls piped thru inverse grep works better than plain ls I guess? macOS ships with BSD ls, not GNU ls; no inverse filter with BSD ls.

# functionizing the script-o-magic
# this makes the update.sh script

scriptomagic () {
  echo "#!/bin/bash" >> "$script"
  echo "yt-dlp -f "ba" -o '%(playlist_index)s - %(title)s.%(ext)s' $playlist_url" >> "$script"
  echo "now=\$(date \"+%Y-%m-%d-%M\")" >> "$script"
  echo "ls | grep -v \\\.sh | grep -v \\\.m3u >> \$now\_\""$plname"\".m3u" >> "$script"
  #so now the update script will also build a new playlist with each run
  chmod +x "$script"
  echo "$script has been written in $(pwd). Run $script within $(pwd) to update the files."
}

# testing for presence of update.sh, asking how to proceed

if test -f "$script"; then
  echo "$script already exists in the target directory."
  echo "Do you wish to create a new $script script?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) rm $script;
      scriptomagic
      break;;
      No )
      echo "Okay, we are leaving $script alone for this run.";
      break;;
    esac
  done

else
  scriptomagic
fi

convert2mp3 () { #this function is to be called if ffmpegPresence variable is not null
  echo "It looks like you have ffmpeg installed."
  echo "Would you like to convert .webm files to .mp3? Type \"yes\" or \"y\" to proceed with batch conversion."
  read convert
  if [ "$convert" == "yes" ] || [ "$convert" == "y" ]
    then
      mkdir mp3
      for i in *.webm ; do
        ffmpeg -i "$i" -acodec libmp3lame "mp3/$(basename "${i/.webm}")".mp3 #loops thru all webm files and converts to mp3
      done
      echo "Okay, webm files have been converted to mp3. You can see them in $(pwd)/mp3/."
    else
      echo "Bye!"
      exit 1
    fi
}

ffmpegPresence=$(which ffmpeg) #takes result of which ffmpeg and stores in variable

if [ ! -z "$ffmpegPresence" ] #if variable is NOT null, it proceeds. otherwise, nothing happens.
  then
  convert2mp3
fi


# this is probably sloppy but I didn't go to computer college, sorry :)

#shoutouts:
# https://stackoverflow.com/questions/226703/how-do-i-prompt-for-yes-no-cancel-input-in-a-linux-shell-script
# https://linuxize.com/post/bash-check-if-file-exists/
# https://www.shell-tips.com/bash/if-statement/
