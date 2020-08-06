## Services Configuration

Following are the instructions to configure various services on Ubuntu 20.04+.

- [Samba](#samba)
- [OpenSSH](#openssh)
- [Deluge](#deluge-torrent--20)
- [Plex](#plex)
- [NextCloud](#nextcloud)

### Samba

#### Installation

Install Samba by running following command;

```bash
sudo apt install samba
```

#### Configure Shares

Edit Samba config;

```bash
sudo nano /etc/samba/smb.conf
```

Add following line under `[global]` section (within `Network` sub-category), it is
responsible for faster IO over the network ([source](https://calomel.org/samba.html));

```
socket options = TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=65536 SO_SNDBUF=65536
```

Add shares with Guest access by adding following blocks at the end of config file (below
is an example of a directory, you can add as many as you want);

```
[Media]
comment = Media Contents
path = /media/Store/Media
veto files = /*.ini/
browseable = yes
writable = yes
guest ok = yes
read only = no
force user = nobody
```

Save the file and restart Samba service;

```bash
sudo service smbd restart
```

### OpenSSH

#### Server Side Instructions

Before we can connect any of our client to our server, we need to go through OpenSSH setup.
Start by installing OpenSSH server;

```bash
sudo apt install openssh-server
```

Allow OpenSSH through firewall;

```bash
sudo ufw allow ssh
```

Edit `ssh_config` file;

```bash
sudo nano /etc/ssh/ssh_config
```

Uncomment following config under `Host *`;

```
PasswordAuthentication yes
```

Edit `sshd_config` file;

```bash
sudo nano /etc/ssh/sshd_config
```

Uncomment following lines along with changing its value as (this will ensure that client is able
to connect when they have several key-pairs available and one of which is known to server);

```
MaxAuthTries 30
```

```
PasswordAuthentication yes
```

Now finally, restart OpenSSH service

```bash
sudo systemctl restart ssh
```

#### Client Side Instructions

On the client machine, there are two possibilities, either you already have an SSH key-pair that
you used to connect to this server, or you are creating a new key-pair, following are the instructions
for each of the two options.

##### Setup with new SSH key-pair

Generate an SSH key-pair, you can follow [these instructions](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent);

Once completed, attempt to connect to your server by using the username and IP address of the server;

```bash
ssh kushal@192.168.0.100
```

This should prompt you for provide username's password, once entered, you'll be dropped in shell. Exit it
by running `exit` command, and then add your generated key-pair's public key to server by running
(replace `id_rsa.pub` with a different file name if you created your key-pair within different name);

```bash
cat ~/.ssh/id_rsa.pub | ssh kushal@192.168.0.100 "cat > ~/.ssh/authorized_keys
```

This will prompt for user password once again, provide the password and that will add your public key
to server's `authorized_keys` file. Now you can connect to server over SSH without providing password
by running same command (you can even omit username and just use IP address if you want);

```bash
ssh kushal@192.168.0.100
```

##### Setup with existing SSH key-pair

In case you already have an existing SSH key instructions remain the same as above, except that you skip
the SSH generate part. But in case you connected to your server using this existing key-pair in the past
and now either server has changed or you reinstalled OpenSSH you need to perform additional steps on client
before you can connect to the server.

Start by first removing your old server's information from your client's `known_hosts` file, edit the file
by running;

```bash
nano ~/.ssh/known_hosts
```

Remove the line that points to your server's IP address, save the file and exit.

Now you can perform above steps of adding your existing public key to server and attempting to connect.

### Deluge Torrent (>= 2.0)

#### Installation

Install Deluged Daemon, Deluge and Deluge-Web;

```bash
sudo apt install deluged deluge deluge-web
```

#### Configure Deluge User and Group

Once installed, create `deluge` user and group;

```bash
sudo adduser --system --group deluge
```

Add current user to `deluge` group;

```bash
sudo gpasswd -a kushal deluge
```

#### Configure Services

Create Deluged Daemon Service config;

```bash
sudo nano /etc/systemd/system/deluged.service
```

Add following contents to the file;

```
[Unit]
Description=Deluged Client Daemon
Documentation=man:deluged
After=network-online.target

[Service]
Type=simple
User=deluge
Group=deluge
UMask=007
ExecStart=/usr/bin/deluged -d

Restart=on-failure

TimeoutStopSec=300

[Install]
WantedBy=multi-user.target
```

Save and exit, now enable the service;

```bash
sudo systemctl enable deluged
```

Start the service;

```bash
sudo systemctl start deluged
```

Check service status

```bash
sudo systemctl status deluged
```

If everything went well, you should see service status as `Active: active (running)` within printed log.

Now configure Deluged-Web service, start by creating service config file;

```bash
sudo nano /etc/systemd/system/deluged-web.service
```

Add following contents to the file;

```
[Unit]
Description=Deluge Bittorrent Client Web Interface
Documentation=man:deluge-web
After=network-online.target deluged.service
Wants=deluged.service

[Service]
Type=simple
User=deluge
Group=deluge
UMask=027
# This 5 second delay is necessary on some systems
# to ensure deluged has been fully started
ExecStartPre=/bin/sleep 5

# Runs Web UI on port 9000
ExecStart=/usr/bin/deluge-web -d -p 9000
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Save and exit, now enable the service;

```bash
sudo systemctl enable deluged-web
```

Start the service;

```bash
sudo systemctl start deluged-web
```

Check service status

```bash
sudo systemctl status deluged-web
```

If everything went well, you should see service status as `Active: active (running)` within printed log.
Now you can visit `http://127.0.0.1:9000` in the browser to view Deluge Web Interface, the Web UI is also
accessible on local network by using server's IP address.

### Plex

There are two possible ways to install Plex Media Server on a system, like installing natively by downloading
the server installer from [Plex Server Downloads](https://www.plex.tv/en-gb/media-server-downloads/) page,
by running it via
[Docker](https://hub.docker.com/r/plexinc/pms-docker/), or by running it as a [Snap package](https://snapcraft.io/plexmediaserver).
but for the sake of simplicity (and AMD APU compatibility) we shall follow the native installation method as it doesn't
involve installing any additional dependencies.

#### Installation

Start by downloading `.deb` installation file from Plex Server Downloads page and install it. Once done, there
could be two possible options in your case, you're configuring Plex Server for the first time, or you're trying
to restore from PMS backup taken on older server.

#### Configure Plex from Scratch

This is very simple, you start by opening `http://127.0.0.1:32400` and it should point you to your PMS web
interface and walk you through setup process.

#### Configure Plex from an existing backup

Here, we'll first go through steps on how to take PMS backup on source server. Start by opening bash navigate
to `/var/lib/plexmediaserver/` directory, and backup `Library` folder;

```bash
sudo tar cvzf Library.tar.gz ./Library
```

Now move the created file to a secure location where you can use it from when restoring to new server;

```bash
sudo mv Library.tar.gz /path/to/different/directory/
```

Now on target server, once PMS is installed, stop the PMS service;

```bash
sudo service plexmediaserver stop
```

Now copy the backup file to `/var/lib/plexmediaserver/` directory;

```bash
sudo cp /path/to/backup/Library.tar.gz /var/lib/plexmediaserver
```

Once done, rename existing `Library` directory first;

```bash
sudo mv /var/lib/plexmediaserver/Library /var/lib/plexmediaserver/Library.old
```

Now start uncompressing the copied back-up file while in `/var/lib/plexmediaserver`;

```bash
sudo tar -xvf Library.tar.gz
```

This may take a while to extract everything and create a new `Library` directory. Once done, restore permissions;

```bash
sudo chown -R plex:plex Library
```

Now finally, start PMS service again;

```bash
sudo service plexmediaserver start
```

Navigate to `http://127.0.0.1:32400` and login using your Plex account, and if everything went well, you should see
your server in its original state. Now delete back-up zip file and older Library directory;

```bash
sudo rm Library.tar.gz
```

```bash
sudo rm -rf Library.old
```

### NextCloud

#### Installation

There are several ways to install NextCloud on Ubuntu, like [manual installation](https://docs.nextcloud.com/server/18/admin_manual/installation/source_installation.html),
[Docker](https://hub.docker.com/_/nextcloud/) or using [Snap package](https://snapcraft.io/nextcloud). Given that both
manual and docker installation methods involved additional dependencies. We are going to use Snap package method as
is self-contained and doesn't include any external dependencies.

If you're running Ubuntu 18.04 or above, `snap` support is already included in your OS, to install NextCloud,
you need to run;

```bash
sudo snap install nextcloud
```

#### Configure Ports and Trusted Domains

Once installation is complete, we need to perform additional steps to define
default port and add trusted domains from which NextCloud is accessible on the network.

To define default port, run;

```bash
sudo snap set nextcloud ports.http=10000 ports.https=10001
```

Notice that we have set port `10000` as default for HTTP while `10001` for HTTPS, You can change it to any
other port as well.

At this point, NextCloud Web UI can be accessed in the browser using `http://localhost:10000`, be sure
to visit that URL first and go through the setup (like setting up default user and password).

Now,we want our NextCloud instance to be accessible from other devices on our network as well. So now we
need to add our server's IP to NextCloud trusted domain by running;

```bash
sudo snap run nextcloud.occ config:system:set trusted_domains 1 --value=192.168.0.100
```

You can add additional domains by running above command with modified number and value as;

```bash
sudo snap run nextcloud.occ config:system:set trusted_domains 2 --value=127.0.0.1
```

Once done, restart NextCloud server by running;

```
sudo snap restart nextcloud
```

#### Mounting External Storage

By default, NextCloud maintains files and folders in its own directory but in case you have different partitions
in your server containing media files and any other data and if you wish to access those using NextCloud, you can
enable it by using _External Storage_ feature of NextCloud.

Start by first enabling _External Storage support_ app, this can be located in`/index.php/settings/apps/featured/files_external` page.
Once that is done, connect NextCloud to external storage by running;

```bash
sudo snap connect nextcloud:removable-media
```

Now assuming that you have mounted your external partitions in directories within `/media` (eg; `/media/Store` in my case),
you need to first create a dedicated `Nextcloud` directory within `/media/Store`. So let's create one;

```bash
mkdir /media/Store/Nextcloud
```

Once done, we need to move NextCloud default data directory over to our newly created directory;

```bash
sudo mv /var/snap/nextcloud/common/nextcloud/data /media/Store/NextCloud
```

Once this is done, next step is to edit `config.php` of NextCloud;

```bash
sudo nano /var/snap/nextcloud/current/nextcloud/config/config.php
```

Here, change following config as;

```php
'datadirectory' => '/media/Store/Nextcloud/data/',
```

Save and exit the file, now, depending on how your data directory partition is mounted,
we need to disable NextCloud for a bit to update data directory permissions;

```bash
sudo snap disable nextcloud
```

Once done, we need to change data directory ownership as;

```bash
sudo chmod 0770 /media/Store/Nextcloud/data
```

```bash
sudo chown www-data:www-data /media/Store/Nextcloud/data
```

In case you mounted NTFS partition will full R/W permissions, above `chmod`/`chown` commands
won't work, so we need to make Nextcloud ignore the data directory permissions by adding
following line below `datadirectory` config within `/var/snap/nextcloud/current/nextcloud/config/config.php`;

```php
'check_data_directory_permissions' => false,
```

Now finally enable NextCloud again

```bash
sudo snap enable nextcloud
```

Once this is complete, you can navigate to `http://127.0.0.1:10000/index.php/settings/admin/externalstorages` and start
adding folders from `/media/Store` into your NextCloud.
