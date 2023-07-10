# /bin/bash
rootuser () {
  if [[ "$EUID" = 0 ]]; then
    continue
  else
    echo "Please Run As Root"
    sleep 2
    exit
  fi
}

rootuser

# Install packages

echo "Debian MATE on VNC server"
echo "Setting up packages..."
apt update && sudo apt upgrade -y
apt install -y mate-desktop-environment mate-desktop-environment-extras tightvncserver flatpak htop sudo xrdp

# Setup the user

echo "Setting up users..."
echo -n "Insert your accounts username: " 
read user
useradd -g users -G sudo -s /usr/bin/bash "$user"
passwd "$user"
mkdir /home/"$user"
chown "$user" /home/"$user"
usermod -aG sudo "$user"
usermod -aG users "$user"
sudo -u "$user" xdg-user-dirs-update

# Setup the VNC Server

echo "Setting up VNC Server..."
echo "Please set up the VNC server password"
sudo -u "$user" vncpasswd
sudo -u "$user" echo "#!/bin/bash
xrdb $HOME/.Xresources
mate-session &" > /home/"$user"/.vnc/xstartup
chown "$user":users --no-preserve-root /home/"$user"/.vnc/xstartup
chmod +777 /home/"$user"/.vnc/xstartup

# Setup X Server
echo "Generating xauthority files..."
touch /root/.Xauthority
sudo -u "$user" touch /home/"$user"/.Xauthority

# Setup Flatpak Support
echo "Setting up Flatpak"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
su "$user" -c "flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo"
flatpak install -y flathub org.mozilla.firefox

# Final touches
touch /home/"$user"/Desktop/README.md
echo "Debian VNC server installer
Installs a Desktop & VNC server for Debian Linux

Tested with latest Debian 12

To start the VNC server, run vncserver as the user you setup during installation.
To stop the VNC server, run vncserver -kill :1 as the user you started the VNC server with.

Setup
There's 2 variants of this script. If you installed Debian through a container, we recommend using the "User dosen't exist" script. If you've setup a user account during the installation of Debian, We highly recommend using the User exists script since it skips user creation." > /home/"$user"/Desktop/README.md
chown "$user":users --no-preserve-root /home/"$user"/Desktop/README.md
sudo -u "$user" vncserver

# We're done!
echo "Installation finished!"
echo "Access your new VNC server and desktop by connecting to 'localip:5901' & use the VNC server password you just setup! (not user or root password)"
echo ""
ecbo "To stop the VNC server, simply run vncserver -kill :1"
ecbo "To start the VNC server back up, run vncserver"
echo "See the README.md on the Desktop for more details."
echo "A reboot is required for some changes to take effect."