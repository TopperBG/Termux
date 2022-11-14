#!/bin/sh
pkg update
pkg upgrade -y
pkg install proot-distro wget 
pkg clean
pkg autoclean
ver=$( curl -s -H 'Pragma: no-cache' "https://api.github.com/repos/Jackett/Jackett/releases/latest" | awk -F '"' '/tag_name/{print $4}' | tr -d '[:cntrl:]' )
echo ">>> Latest Jackett version $ver"

case $( uname -m | tr '[:upper:]' '[:lower:]') in
	x86_64 ) 
		targetos=LinuxAMD
		;;
	aarch64 )
		targetos=LinuxARM64
		;;
    aarch32 | armv7* ) 
		targetos=LinuxARM32
		;;
	* )
		echo "Unsupported OS, exiting..."
		exit 1
	;;
esac
URL=$( curl -s -H 'Pragma: no-cache' "https://api.github.com/repos/Jackett/Jackett/releases/latest" | grep browser_download_url | cut -d '"' -f 4 | grep ${targetos} )
wget "$URL" -O /sdcard/Download/Jackett.Binaries.tar.gz
#rm -rf /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/root/Jackett
proot-distro install debian
proot-distro login debian -- tar -xvzf /sdcard/Download/Jackett.Binaries.tar.gz
echo "~/Jackett/jackett_launcher.sh" >> /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/root/.bashrc
echo "proot-distro login debian" > ~/.bashrc
sync
exit 0
