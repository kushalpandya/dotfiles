## Post-install Setup

Once Ubuntu installation is complete, there are several
post-installation settings which are required.

- [Auto-mount Partitions](#auto-mount-ntfs-partitions)
- [Enable Bash Password Feedback](#enable-bash-password-feedback)
- [Set GRUB Timeout Duration](#set-grub-timeout-duration)

### Auto-mount NTFS partitions

By default, Ubuntu won't mount NTFS paritions on start-up,
we need to configure it first. Start by first ensuring that
partition is not already mounted (you can unmount it using
Ubuntu's file manager).

Now identify the parition you want to auto-mount by running
following;

```bash
sudo blkid
```

This should log list of paritions as follows;

```
/dev/nvme0n1p5: LABEL="Ubuntu" UUID="419e7de2-cbba-4dc5-87fd-d1395aa155a8" TYPE="ext4" PARTUUID="9dda87a9-6db6-4eac-beae-83ee55ddff8a"
/dev/nvme0n1p1: UUID="386E-15BA" TYPE="vfat" PARTLABEL="EFI system partition" PARTUUID="12890ae1-64b7-4aab-9628-3f47296ec587"
/dev/nvme0n1p3: LABEL="Windows" UUID="7EDE789EDE784FFF" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="eefa2bc6-d6fc-4706-8c4b-6da568a4face"
/dev/nvme0n1p4: UUID="543CC08D3CC06C14" TYPE="ntfs" PARTUUID="c7bdefa2-3376-4e90-9a12-52585cb0d97e"
/dev/sda1: LABEL="Store" UUID="7DA31EC576D6AD90" TYPE="ntfs" PTTYPE="dos" PARTUUID="1bae2464-d33d-4528-9baa-bc5b262ba4b8"
/dev/nvme0n1p2: PARTLABEL="Microsoft reserved partition" PARTUUID="88538c6b-d5cb-483c-b7fb-79e54f31411d"
```

Notice that in our case, we need to mount the parition that is
identified as `/dev/sda1` and has `LABEL="Store"`, copy the
value of UUID (you can also use `LABEL` value here but UUID is more
reliable as it won't change until you reformat the partition).

Now we need to determine the _mount-point_ for this partition,
usually a directory within `/media` folder is ideal for non-system
partitions. Create a directory (preferably with same name as LABEL of
our target partition) within it;

```bash
sudo mkdir /media/Store
```

Once it is done, open `/etc/fstab` file for editing;

```bash
sudo nano /etc/fstab
```

Now add the following line at the end of the file;

```bash
UUID=7DA31EC576D6AD90   /media/Store    ntfs    rw,defaults 0   0
```

Notice how we used `UUID` as it is along with mount-point directory,
if you want to mount using `LABEL` value, just replace `UUID` with
`LABEL` and its value. Now save the file and exit and then run following;

```bash
sudo mount -a
```

This will mount the partition and now it should also get auto-mounted
on system start-up.

### Enable Bash Password Feedback

Ubuntu by default doesn't show any feedback while you type passwords
in bash (eg; using `sudo` commands), to enable showing asterisks (\*)
for password characters, you can do so by editing `/etc/sudoers` file
using `visudo` command.

Run following to edit the same;

```bash
sudo visudo
```

And then add the following line right below `Defaults env_reset`;

```bash
Defaults        pwfeedback
```

Save and exit the file and then once you logout and log back in, you
should start seeing password characters as `*` while typing
passwords in bash.

## Set GRUB Timeout Duration

If you're running Ubuntu along-side Windows in a dual-boot setup,
chances are that GRUB already has duration of 10 seconds set to
wait before booting into first GRUB menu entry (usually Ubuntu).
But if you want to change this duration, you can do so by editing
`/etc/default/grub` file.

```bash
sudo nano /etc/default/grub
```

Now look for setting `GRUB_TIMEOUT="10"` and change the value
to any other number (it is a unit in _seconds_) you want to make
GRUB wait for. In case you want to make the waiting duration
infinite (i.e. never automatically boot into first menu entry),
change the value to `"-1"`. Now save the file and exit.

Once done, we need to regenerate `grub.cfg` which can be done by running;

```bash
sudo update-grub2
```

Upon next boot, you should see GRUB wait for the duration you had set.
