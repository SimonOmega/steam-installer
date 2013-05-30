#! /bin/bash

# Version 1.2
# SimonOmega

###
# Pre-Requierments
#   dpkg --add-architecture i386
#   apt-get update
#   apt-get upgrade
###
# Developed with Input from the Following Sources
# http://steamcommunity.com/profiles/76561197999386145 - Kano
#   http://kanotix.com/
#   http://kanotix.com/files/fix/install-steam-wheezy.sh
# http://www.sarplot.org/howto/45/Steam_on_64bit_Debian_Wheezy_70/ - fragglarna's blog
# http://aspensmonster.com/2012/12/07/steam-for-linux-beta-on-64-bit-debian-testing-wheezy/ - Aggroskater's blog
# http://steamcommunity.com/app/221410/discussions/0/882965118613928324/ - Debian Group

clear
read -p "All input in the script is CASE SENSITIVE. Enter Y to continue:" -n 1 _ANSWER
if ! [ "$_ANSWER" == "Y" ]; then
  echo "\n\n"
  exit
fi

clear
echo -e "This Script needs to be run as root first.\nThen run it as any user that will use Steam.\n"
if [ "$(id -u)" = "0" ]; then
    echo "You are root so this script will: Generate the Install Package (deb)."
else
    echo "You are not root so this script will: Install Requiered Steam Libraries."
fi
read -p "If this is the proper step enter Y to continue:" -n 1 _ANSWER
if ! [ "$_ANSWER" == "Y" ]; then
  echo "\n\n"
  exit
fi
echo -e "\n\n"
if [ "$(id -u)" = "0" ]; then
	echo "##  REMOVE OLD STEAM CLIENT"
	dpkg --purge steam steam64 steam-launcher 2>/dev/null
	echo "##  Creating Temp Directory"
	TEMPSTEAMDIR=$(mktemp -d /tmp/steam.XXXXX) 
	echo "##  Downloading Steam to ${TEMPSTEAMDIR}"
	wget -NP $TEMPSTEAMDIR http://repo.steampowered.com/steam/archive/precise/steam_latest.deb
	echo "##  Extracting Files to ${TEMPSTEAMDIR}/steam"
	dpkg -x $TEMPSTEAMDIR/steam_latest.deb $TEMPSTEAMDIR/steam
	echo "##  Extracting Control File to ${TEMPSTEAMDIR}/steam/DEBIAN"
	dpkg -e $TEMPSTEAMDIR/steam_latest.deb $TEMPSTEAMDIR/steam/DEBIAN
	echo "##  Replace Contol File Ubuntu Dependancies with Debian Wheezy Equivalent"
	sed -i 's/multiarch-support ([^()]*)/multiarch-support/g' $TEMPSTEAMDIR/steam/DEBIAN/control
	sed -i 's/libc6 ([^()]*)/libc6/g' $TEMPSTEAMDIR/steam/DEBIAN/control
	sed -i 's/libpulse0 ([^()]*)/libpulse0/g' $TEMPSTEAMDIR/steam/DEBIAN/control
	echo "##  Repackage for Debian Wheezy"
	dpkg -b $TEMPSTEAMDIR/steam/
	echo "##  Verify and Install Dependancies"
	apt-get install multiarch-support xterm zenity libgtk2.0-0:i386 libcurl3-gnutls:i386 libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libogg0:i386 libpixman-1-0:i386 libsdl1.2debian:i386 libtheora0:i386 libudev0:i386 libvorbis0a:i386 libvorbisenc2:i386 libvorbisfile3:i386 libasound2:i386 libcairo2:i386 libcups2:i386 libdbus-1-3:i386 libfontconfig1:i386 libfreetype6:i386 libgcc1:i386 libgcrypt11:i386 libgdk-pixbuf2.0-0:i386 libglib2.0-0:i386 libnspr4:i386 libnss3:i386 libopenal1:i386 libpango1.0-0:i386 libpng12-0:i386 libpulse0:i386 libstdc++6:i386 libx11-6:i386 libxext6:i386 libxfixes3:i386 libxi6:i386 libxinerama1:i386 libxrandr2:i386 libxrender1:i386
	echo "##  Download and Install Requiered Ubuntu Packages"
	echo "##  -- Process python-xkit_0.4.2.3"
	wget -NP $TEMPSTEAMDIR http://archive.ubuntu.com/ubuntu/pool/main/x/x-kit/python-xkit_0.4.2.3build1_all.deb 
	dpkg -i $TEMPSTEAMDIR/python-xkit_0.4.2.3build1_all.deb 
	echo "##  --  Process jockey-common_0.9.7"
	wget -NP $TEMPSTEAMDIR http://archive.ubuntu.com/ubuntu/pool/main/j/jockey/jockey-common_0.9.7-0ubuntu7_all.deb 
	dpkg -i $TEMPSTEAMDIR/jockey-common_0.9.7-0ubuntu7_all.deb
	echo "##  Move Steam Package to Home Directory"
	mv $TEMPSTEAMDIR/steam.deb ~/steam.deb
	echo "##  Remove Steam apt sources"
	rm -f /etc/apt/sources.list.d/steam.list*
	echo "##  Remove Steam Dependancy Checker"
	rm -f /usr/bin/steamdeps
    read -p "Would you like to install the package now.  (Y): " -n 1 _ANSWER
    if ! [ "$_ANSWER" == "Y" ]; then
        echo -e "\n\n##  Install Steam Package to Home Directory"
        dpkg -i ~/steam.deb
    fi
    echo "##  Remove ${TEMPSTEAMDIR}"
    rm -rf $TEMPSTEAMDIR
	echo "##  Complete: Package available at ~/steam.deb"
else
	echo "##  Creating Lib Directories"
	mkdir -p ~/.local/share/Steam/ubuntu12_32/
	echo "##  Create Temporary Directory"
	TEMPSTEAMDIR=$(mktemp -d /tmp/steam.XXXXX)
	echo "##  Downloading Ubuntu libc6 Packages"
	wget -NP $TEMPSTEAMDIR http://security.ubuntu.com/ubuntu/pool/main/e/eglibc/libc6_2.15-0ubuntu10.2_i386.deb
	echo "##  Unpacking Ubuntu libc6 Packages"
	dpkg -x $TEMPSTEAMDIR/libc6_2.15-0ubuntu10.2_i386.deb $TEMPSTEAMDIR/libc6_2.15-0ubuntu10.2_i386/
	echo "##  Copy Ubuntu libc6 libs to Steam Specific lib Directories"
	cp -pr $TEMPSTEAMDIR/libc6_2.15-0ubuntu10.2_i386/lib/i386-linux-gnu/* ~/.local/share/Steam/ubuntu12_32/
	echo "##  Creating Steam Specific Flash Plugin Directory"
	mkdir -p ~/.local/share/Steam/ubuntu12_32/plugins
	echo "##  Installing Flash Plugin inside Steam"
	wget -qO- https://get.adobe.com/de/flashplayer/completion/?installer=Flash_Player_11.2_for_other_Linux_%28.tar.gz%29_32-bit|awk -F\' '/location.href/{print $2}'|sed s/http:/https:/|wget -i- -qO-|tar zxvC ~/.local/share/Steam/ubuntu12_32/plugins libflashplayer.so
	echo "##  Remove ${TEMPSTEAMDIR}"
	rm -rf $TEMPSTEAMDIR
	echo "##  Complete: Package available at ~/steam.deb"
fi