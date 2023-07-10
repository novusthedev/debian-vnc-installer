<h1>Debian VNC server installer</h1>
<h3>Installs a Desktop &amp; VNC server for Debian Linux</h3>
<p>Tested with latest Debian 12</p>
<p>&nbsp;</p>
<p>To start the VNC server, run <code>vncserver</code> as the user you setup during installation.</p>
<p>To stop the VNC server, run vncserver -kill :1 as the user you started the VNC server with.</p>
<p>&nbsp;</p>
<h2>Setup</h2>
<p>There's 2 variants of this script. If you installed Debian through a container, we recommend using the "User dosen't exist" script. If you've setup a user account during the installation of Debian, We highly recommend using the User exists script since it skips user creation.</p>