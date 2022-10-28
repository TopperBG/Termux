#!/bin/bash
#pkg update
#pkg upgrade -y
#pkg install proot-distro wget 
#apt autoremove -y
ver=$( curl -s -H 'Pragma: no-cache' "https://api.github.com/repos/Jackett/Jackett/releases/latest" | awk -F '"' '/tag_name/{print $4}' | tr -d '[:cntrl:]' )
echo "Latest Jackett version $ver"
echo "https://github.com/Jackett/Jackett/releases/download/${ver}/Jackett.Binaries.LinuxAMDx64.tar.gz"

ARCH=$( uname -m )
echo "$ARCH"
case "$ARCH" in
  ( "x86_64" ) 
	wget https://github.com/Jackett/Jackett/releases/download/${ver}/Jackett.Binaries.LinuxAMDx64.tar.gz -O /sdcard/Download/Jackett.Binaries.tar.gz
	;;
  ( "aarch64" ) 
	wget https://github.com/Jackett/Jackett/releases/download/${ver}/Jackett.Binaries.LinuxARM64.tar.gz -O /sdcard/Download/Jackett.Binaries.tar.gz
	;;
  ( "aarch32"|"armv7*" ) 
	wget https://github.com/Jackett/Jackett/releases/download/${ver}/Jackett.Binaries.LinuxARM32.tar.gz -O /sdcard/Download/Jackett.Binaries.tar.gz
	;;
  *) 
	echo "Unknow architecture, exiting..."
	exit 1
esac
#rm -rf /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/root/Jackett
proot-distro install debian
proot-distro login debian -- tar -xvzf /sdcard/Download/Jackett.Binaries.tar.gz
echo "~/Jackett/jackett_launcher.sh" >> /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/debian/root/.bashrc
echo "proot-distro login debian" > ~/.bashrc
sync
exit 0
