## Services Configuration

Following are the instructions to configure various services on Ubuntu 20.04+.

- [Samba](#samba)
- [OpenSSH](#openssh)
- [Deluge](#deluge-torrent--20)
- [Plex](#plex)
- [Nextcloud](#nextcloud)
- [Nginx Reverse Proxy](#nginx-reverse-proxy)

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

### Nextcloud

#### Installation

There are several ways to install Nextcloud on Ubuntu, like [manual installation](https://docs.nextcloud.com/server/18/admin_manual/installation/source_installation.html),
[Docker](https://hub.docker.com/_/nextcloud/) or using [Snap package](https://snapcraft.io/nextcloud). Given that both
manual and docker installation methods involved additional dependencies. We are going to use Snap package method as
is self-contained and doesn't include any external dependencies.

If you're running Ubuntu 18.04 or above, `snap` support is already included in your OS, to install Nextcloud,
you need to run;

```bash
sudo snap install nextcloud
```

#### Configure Ports and Trusted Domains

Once installation is complete, we need to perform additional steps to define
default port and add trusted domains from which Nextcloud is accessible on the network.

To define default port, run;

```bash
sudo snap set nextcloud ports.http=10000 ports.https=10001
```

Notice that we have set port `10000` as default for HTTP while `10001` for HTTPS, You can change it to any
other port as well.

At this point, Nextcloud Web UI can be accessed in the browser using `http://localhost:10000`, be sure
to visit that URL first and go through the setup (like setting up default user and password).

Now,we want our Nextcloud instance to be accessible from other devices on our network as well. So now we
need to add our server's IP to Nextcloud trusted domain by running;

```bash
sudo snap run nextcloud.occ config:system:set trusted_domains 1 --value=192.168.0.100
```

You can add additional domains by running above command with modified number and value as;

```bash
sudo snap run nextcloud.occ config:system:set trusted_domains 2 --value=127.0.0.1
```

Once done, restart Nextcloud server by running;

```
sudo snap restart nextcloud
```

#### Mounting External Storage

By default, Nextcloud maintains files and folders in its own directory but in case you have different partitions
in your server containing media files and any other data and if you wish to access those using Nextcloud, you can
enable it by using _External Storage_ feature of Nextcloud.

Start by first enabling _External Storage support_ app, this can be located in`/index.php/settings/apps/featured/files_external` page.
Once that is done, connect Nextcloud to external storage by running;

```bash
sudo snap connect nextcloud:removable-media
```

Now assuming that you have mounted your external partitions in directories within `/media` (eg; `/media/Store` in my case),
you need to first create a dedicated `Nextcloud` directory within `/media/Store`. So let's create one;

```bash
mkdir /media/Store/Nextcloud
```

Once done, we need to move Nextcloud default data directory over to our newly created directory;

```bash
sudo mv /var/snap/nextcloud/common/nextcloud/data /media/Store/Nextcloud
```

Once this is done, next step is to edit `config.php` of Nextcloud;

```bash
sudo nano /var/snap/nextcloud/current/nextcloud/config/config.php
```

Here, change following config as;

```php
'datadirectory' => '/media/Store/Nextcloud/data/',
```

Save and exit the file, now, depending on how your data directory partition is mounted,
we need to disable Nextcloud for a bit to update data directory permissions;

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

Now finally enable Nextcloud again

```bash
sudo snap enable nextcloud
```

Once this is complete, you can navigate to `http://127.0.0.1:10000/index.php/settings/admin/externalstorages` and start
adding folders from `/media/Store` into your Nextcloud.

### Nginx Reverse Proxy

After we configure Plex and Nextcloud, both of them are available inside your home network to be accessible
on any device. However, if you want both those services to be accessible over the internet, you can do so by
using Nginx as a plain HTTP proxy server that listens for any incoming requests and serves Plex or Nextcloud
based on the URL used to access specific service.

This is a multi-step process and here's a gist of how everything is wired up;

1. Assign static local IP address to your computer which has Ubuntu installed and is running Plex/Nextcloud
   using your network router settings.
2. Enable Dynamic DNS support in your network router (in case your ISP doesn't provide you static IP).
3. Enable port forwarding for port `80` (HTTP) and `443` (HTTPS) for your computer's local IP to same
   external ports (`80` & `443`) in your router settings.
4. Setup a domain and add a `CNAME` records for both Plex & Nextcloud which point to URL/IP provided by your
   Dynamic DNS provider. This can also be the static IP in case your ISP has provided you with one.
5. Add Nginx config for listening to incoming requests on port `80`/`443` and serve Plex & Nextcloud
   based on URL used for the request.

**Warning:** ⚠️ This process exposes your home network as well as your computer to the internet which is a recipe for
disaster so only proceed if you know what you're doing and are willing to accept all the risks that it carries.

Before we proceed further, we'll make some assumptions to make our config guide easier. For instance, the
static IP that we'll assign to our computer will be `192.168.0.100`, while the domain that we own is
`example.com`, of course replace both of them with your own IP and domain across the steps below.

#### Step 1 &ndash; Assigning static IP to the computer

This is a fairly straight-forward process and is something that you should ideally do for a computer that
runs Plex or Nextcloud regardless of whether you want to setup reverse proxy. There are plenty of articles
on the web which instruct on how to do that so I'm not going to repeat it here, just pointing to some of
the links; [here][static_ip_1], [here][static_ip_2] and [here][static_ip_3].

[static_ip_1]: https://in.pcmag.com/news/134526/how-to-set-up-a-static-ip-address
[static_ip_2]: https://askubuntu.com/a/1171194/12242
[static_ip_3]: https://itsfoss.com/static-ip-ubuntu/

#### Step 2 &ndash; Enable Dynamic DNS

Most internet service providers (ISP) have their customers assigned with a dynamic IP address, i.e. your IP address
over the internet is not fixed and keeps changing every time you are connected. Which means anything that wants to
connect to your computer using IP address can't work without a fixed IP. This is where we need a way to mask our
dynamically changing IP as provided by ISP to a fixed IP or URL that is guaranteed to never change, thus making it
easier to connect to our computer over the internet using the same.

Most network routers support this ability to setup a third-party Dynamic DNS provider which ensures that a static IP
or URL is kept up-to-date against ever-changing dynamic IP from our ISP. You can read more about it [here](https://en.wikipedia.org/wiki/Dynamic_DNS).

There are several services allow you to use sign up for Dynamic DNS for free (or a very small fees), so sign up for
one and configure it with your network router. Again, here are some links to figure out the same; [here][dyn_dns_1],
[here][dyn_dns_2] and [here][dyn_dns_3].

Once you're done configuring this, you should have a URL/IP provided by the Dynamic DNS service, make a note of this
as we're going to need it in [Step 4](#step-4--setup-cname-records) of this guide.

[dyn_dns_1]: https://www.howtogeek.com/66438/how-to-easily-access-your-home-network-from-anywhere-with-ddns/
[dyn_dns_2]: https://www.noip.com/support/knowledgebase/how-to-configure-ddns-in-router/
[dyn_dns_3]: https://help.dyn.com/remote-access/getting-started-with-remote-access/

#### Step 3 &ndash; Enable Port Forwarding

Once you're done with above steps, you can enable port-forwarding for TCP ports `80` and `443` in your network router
for the IP address `192.168.0.100` (as assigned to our computer). There are guides available for the same so refer to
[those](https://www.noip.com/support/knowledgebase/general-port-forwarding-guide/). Here's a summary of how it would
look like in your router settings;

| **Protocol** | **External Ports** | **Internal IP Address** | **Internal Port** |
| ------------ | ------------------ | ----------------------- | ----------------- |
| TCP/UDP      | 80                 | 192.168.0.100           | 80                |
| TCP/UDP      | 443                | 192.168.0.100           | 443               |

Notice how both external and internal port values are the same.

#### Step 4 &ndash; Setup CNAME Records

Going through all the trouble as mentioned above only makes sense if you can conveniently access your home server
from anywhere on the internet using an easy to remember URL. So let's assume that we want our Nextcloud installation
to be accessible using the url `mycloud.example.com`, while for Plex, we want it to be `movies.example.com`. Noticed
how only `mycloud` and `movies` are different while rest of the domain is same, those terms we defined are called
subdomains, and those are configured by adding a `CNAME` record in your Domain settings (using your domain provider's
portal). Here, we'll use the IP/URL as provided by Dynamic DNS provider from [Step 2](#step-2--enable-dynamic-dns). In
case you're using GoDaddy as your domain host, you can follow [their guide](https://in.godaddy.com/help/add-a-cname-record-19236)
to add `CNAME` record. In case you're not using GoDaddy, steps largely remain the same, just follow your provider's
instructions to do so.

We need to make sure that we add 2 `CNAME` records with names `mycloud` and `movies` respectively, while both of them
having the same Dynamic-DNS-provided URL as value. Here's a screenshot of how it'll look like once you are done adding
the records;

![DNS Records](https://i.imgur.com/yQ6L2cC.png)

#### Step 5 &ndash; Configure Nginx

Finally this is the step where everything is tied together. Start by making sure you have Nginx installed;

```bash
sudo apt install nginx
```

Once you have it installed, verify if nginx server is running by doing `sudo service nginx status`. If it is
running, you should see it log something like;

```bash
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2020-08-11 10:10:31 IST; 7h ago
       Docs: man:nginx(8)
    Process: 1149 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 1266 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 1279 (nginx)
      Tasks: 17 (limit: 19004)
     Memory: 19.7M
     CGroup: /system.slice/nginx.service
             ├─1279 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             ├─1280 nginx: worker process
             ...
             ...
```

Notice the line `Active: active (running)`, that means it is running.

Now we first need to remove default site config that nginx comes with, we can do so by running;

```bash
sudo unlink /etc/nginx/sites-enabled/default
```

Once done, let's start configuring both Nextcloud and Plex configs for nginx one by one;

##### Nextcloud on Nginx

Create a config file and open it for editing by running;

```bash
sudo nano /etc/nginx/sites-available/mycloud.example.com.conf
```

Now add following contents to the file;

```bash
server {
    listen 80;
    server_name mycloud.example.com;
    location / {
        proxy_pass http://127.0.0.1:10000;
    }
}
```

Assuming you have Nextcloud running on port `10000`, above config will listen for incoming HTTP requests on port `80`
and serve your Nextcloud instance if the URL used was `mycloud.example.com`. Save the file and exit.

Now verify if your config is correct by running `sudo nginx -t`, as long as you followed above setup (and just replaced
value for `server_name`, it should work just fine). Once the command reports that there isn't any problem with your nginx
config, you can enable this site config by symlinking it to `/etc/nginx/sites-enabled` directory by running;

```bash
sudo ln -s /etc/nginx/sites-available/mycloud.example.com.conf /etc/nginx/sites-enabled/mycloud.example.com.conf
```

Once the symlinking is done, restart nginx service using `sudo service nginx restart`. At this point, you should be
able to access your Nextcloud instance using `mycloud.example.com` URL in your web browser.

###### HTTPS for Nextcloud

At this point, you can optionally enable HTTPS for Nextcloud as it supports LetsEncrypt based SSL. Start by first
enabling SSL in your Nextcloud instance using following command;

```bash
sudo nextcloud.enable-https lets-encrypt
```

This step will ask a couple of questions like ensuring you have relevant ports being forwarded, default email address
for recovery and the domain name to issue SSL certificate against. You can confirm first question, provide your
email addres in response to second question and for the domain, provide `mycloud.example.com` as it is the domain
we're going to use to access Nextcloud over the internet. Once done, this will issue the SSL cert for the Nextcloud
installation.

Once above command completes, we need to re-configure our nginx config for Nextcloud to make sure it serves the instance
over HTTPS (and does redirect for HTTP requests). Start by first removing the existing nginx config for Nextcloud by
running;

```bash
sudo unlink /etc/nginx/sites-enabled/mycloud.example.com.conf
```

Now open the config that we created earlier for editing;

```bash
sudo nano /etc/nginx/sites-available/mycloud.example.com.conf
```

You'll see the contents that we had added earlier, so let's remove it all and replace it with following config;

```bash
# HTTP Redirection Config
server {
    listen 80;
    listen [::]:80;
    server_name mycloud.example.com;
    return 301 https://$server_name$request_uri;
}

# HTTPS Config
server {
    # Listen for HTTPS
    listen 443 ssl;

    # Domain to map against
    server_name mycloud.example.com;

    # Enable client to upload files up to 16GB
    client_max_body_size 16G;

    # SSL Certs
    ssl_certificate /var/snap/nextcloud/current/certs/live/fullchain.pem;
    ssl_certificate_key /var/snap/nextcloud/current/certs/live/privkey.pem;

    location / {
        proxy_pass https://127.0.0.1:10001;
    }
}
```

Now let's go through what we added above;

- First block of the config sets a `301` redirect by forwarding all HTTP
  requests to HTTPS.
- Second block enables HTTPS instance of Nextcloud by listening to incoming
  requests on port `443` and serves Nextcloud's SSL enabled version running
  on port `10001`.
- We specify SSL cert and key file's path manually based on where Snap package
  stores it.

Now save the file and exit and run `sudo nginx -t` to ensure that config doesn't have any errors.

If it passed, finally enable this config by running;

```bash
sudo ln -s /etc/nginx/sites-available/mycloud.example.com.conf /etc/nginx/sites-enabled/mycloud.example.com.conf
```

Once done, restart nginx by running `sudo service nginx restart`. At this point, you should be able to access
Nextcloud using the URL `https://mycloud.example.com`.

##### Plex on Nginx

Steps to enable Plex in Nginx are largely the same as Nextcloud so I'll just share a sample config that we can use for
Plex;

```bash
server {
    listen 80;
    server_name movies.example.com;
    location / {
        proxy_pass http://127.0.0.1:32400;
    }
}
```

Follow the same commands use to create config file and enabling the config, just name the file different (eg; `movies.example.com.conf`).
This also assumes that your Plex server is running on port `32400`, in case you're using different port, be sure to mention the same here.

Additionally, you'll need to enable [Remote Access](https://support.plex.tv/articles/200289506-remote-access/) from your Plex Media Server
settings interface. Once it is done, restart nginx service and you should be able to access Plex using `http://movies.example.com` from
your web browser.

###### HTTPS for Plex

TBA
