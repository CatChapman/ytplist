# ytplist.sh

shell script for OS X (and Linux too? untested, YMMV) that uses yt-dlp https://github.com/yt-dlp/yt-dlp to download a playlist as audio in its own folder (named after the playlist title) and automagically producing an update script to use within the playlist's folder so you can update the content at your leisure. it'll also make an m3u playlist file so you can plop it into your media player of choice and enjoy - update script creates updated playlists too. handy if a playlist updates regularly and you want to save the content for offline listening. public domain music, podcasts, lectures, stuff like that.

if you have ffmpeg installed, will provide the option to convert all downloaded .webm files to .mp3 files, as I had some complaints about the .webm format. (VLC plays .webm fine, for your information! but - adding this functionality was easy enough. I might expand it as right now it exists in a vacuum; this functionality is not reflected in update.sh, and is only present in the main script execution)

# to use

**you need yt-dlp https://github.com/yt-dlp/yt-dlp**

**you need yt-dlp https://github.com/yt-dlp/yt-dlp**

**you need yt-dlp https://github.com/yt-dlp/yt-dlp**

you also need bash (zsh might work too? i'm a crumudgeon and haven't updated yet).

I have only tested this on OS X and some of the GNU utils work slightly differently on mac (whyyyyy) so no guarantees there, but probably won't require too much tinkering if any.

# HOW to use ytplist.sh

you run this from your terminal application. on OS X it's typically Terminal.app.

save the scripts in the directory you are happy with having subdirectories of playlists' content. e.g. "~/Youtube\ Playlists/"

make sure the script is executable (chmod +x ytplist.sh)

run as: ./ytplist.sh [optional playlist URL OR ID here; it will prompt you otherwise]

you can use the full URL or the playlist ID, it doesn't matter.

IN THE FOLDER where all the audio gets downloaded, you will have an update.sh script produced automagically. if an update.sh already exists in that folder, you will be prompted as to whether or not you want to overwrite it with a new update.sh (e.g. if you are going from 2020/2021 fancy_ytplist.sh to 2024 ytplist.sh, you may want to overwrite the original update.sh!). ideally to update your playlists you'd use the update.sh within the playlist folder, but I wanted to have this presence-checking functionality because it was tedious to continuously remove update.sh during testing as to avoid redundancy in the file itself.

***¡FANCY TIME!*** you will ALSO have an m3u playlist file generated using the contents of the playlist folder, so you can pop it into your player of choice, and enjoy your content right away! it will be timestamped with YYYY-MM-DD-minutes followed by the name of your playlist folder, e.g. 2024-10-21-34_YourPlaylistHere.m3u. It will be generated in your playlist folder.

the update.sh script will also (hoepfully) automagically be executable. if you want to update (i.e. your playlist of choice gets new content), just run that script as-is (./update.sh) from within the playlist's folder, and it'll download any new content, skipping already-downloaded content. the playlist ID/URL is hard-coded into the script so it will ideally be good to go out-of-the-box. ***¡FANCY TIME!*** the NEW and IMPROVED update.sh script will ALSO update the playlist, timestamped by the day and minute. it will append info the the same file if you update it more than once in a minute; I want to fix this later with prompting or something, but timestamping by the minute seems to be a decent enough fix.

e.g.

let's say you run this script within "~/Youtube\ Playlists/" for a playlist titled "This is a Playlist"

a folder titled "This\ is\ a\ Playlist/" will be created within "~/Youtube\ Playlists/" and populated with the contents of said playlist, indexed by position in the playlist. so #1 on the list would be 01 - [insert title here], #1 would be 02 - [insert title here] and so on. the file format depends on the video and its container, but it's usually webm and sometimes mp4. VLC is always able to play whatever this downloads.

an update.sh script will also populate that folder

a $timestamp_$playlistname.m3u playlist file will also populate that folder

if This is a Playlist updates, simply run update.sh within "This\ is\ a\ Playlist/" to update the content of your "This\ is\ a\ Playlist/" folder. a new playlist will also be generated, with the current date's timestamp. if you know the date command within bash, it's easy enough to change the specificity of the timestamp within the script, or remove it altogether, customize it, whatever.

if you run update.sh outside of that folder, it will still download the playlist, but it will be redundant and download everything all over again. which, hey, you do you.

# disclaimers

I did not go to Computer College. I'm more of a tinkerer than a coder. That said, this works for me on yt-dlp version 2024-04-09.

this isn't intended for copyright infringement or other nefarious purposes. please don't ruin a good thing. we should use this for public domain audios you want to listen to e.g. on a plane when you don't have data. be a good citizen.

# why?

because I'm really lazy and I wanted this *specific* functionality

# todo

validate youtube URLs. I have the regex pattern from the old youtube-dl python code but it doesn't seem to play nicely with bash. or I'm just doing it wrong - very possible. considering this "todo" is still present three years later, odds aren't great that it'll actually get done, but hey

# anyway please don't do anything illegal with this. thanks babes.
