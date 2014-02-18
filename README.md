# Boostrapping VWF Web server

1. SSH to server, create user `vwf`:

        adduser vwf

2. Add `vwf` to `/etc/sudoers`, don't require password:

        vwf ALL=(ALL:ALL) NOPASSWD: ALL

    Note: Remember to use `sudo visudo` when editing sudoers.

3. Copy public keys for user vwf.

4. Disable password authentication. Edit `/etc/ssh/sshd_config` to:

        ChallengeResponseAuthentication no
        PasswordAuthentication no
        UsePAM no

        # Then:
        sudo service ssh restart

5. Fix locales:

        sudo locale-gen en_US.UTF-8
        sudo dpkg-reconfigure locales

6. [Increase SWAP size](https://www.digitalocean.com/community/articles/how-to-add-swap-on-ubuntu-12-04) in case of 512MB droplet

7. Copy the certs to the `/home/vwf` directory as:
    
        public.crt
        private.key
        intermediate.crt

8. Run:

        ./bootstrap.sh virtual.wf
