License
-------------------------------

This program is distributed under the [GPL](http://www.gnu.org/licenses/gpl.html),
version 3 or later. Please see the COPYING file for details.


Introduction
------------
This script will create a Steam Linux Client package that will install on Debian and CrunchBang.

When run as root it will:
*    Download Dependancies
*    Grab Dependancies from Ubuntu Repositories
*    Edit the cotents of the Steam Package for Debian Support
*    Repackage the Steam Linux Client as "steam.deb"
*    Optionally it will install the Package.

When run as a user (some account that will play steam) it will:
*    Download Requiered Libraries to the ~/.local/Steam/ directory
*    Download the latest Flash Library ro the ~/.local/Steam/ directory

This script is compiled from many sources of information.  
All will be listed here and in the script.
[Kano](http://steamcommunity.com/profiles/76561197999386145)
  [Web Site](http://kanotix.com/)
  [Kano's Script](http://kanotix.com/files/fix/install-steam-wheezy.sh)
[Fragglarna's Blog](http://www.sarplot.org/howto/45/Steam_on_64bit_Debian_Wheezy_70/)
[Aggroskater's Blog](http://aspensmonster.com/2012/12/07/steam-for-linux-beta-on-64-bit-debian-testing-wheezy/)
[Steam Debian Group](http://steamcommunity.com/app/221410/discussions/0/882965118613928324/)


Quickstart guide
----------------

Execute the script as root.
Execute the script as you user account.
