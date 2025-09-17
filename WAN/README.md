# Setup headscale and headplane in internet





## 1. Prerequisites 

* a free domain name of yours
* a Linux host or VM with public IP address - let's name it hs-server
  * only verified with IP4 and debian Linux 12
  * headscale and headplane will run together in the same host
* install docker.io and docker-compose
* 2 or more Linux hosts with tailscale client installed

## 2. Setup

* add DNS records for headscale and headplane services under your domain name, e.g.:
  * **hs.your-domain.xyz  → headscale**
  * **cp.your-domain.xyz  → headplane**
* wait DNS resolution OK for all the hosts you will run tailscale or access the headplane web UI
* login and put all the stuff in WAN sub-directory into the hs-server
* download the statically linked curl-amd64 with get-curl.sh
* run 'docker-compose up -d', and wait all containers to be **UP**



## 3. Tests

* add an apikey for your headplane UI access
  * in hs-server, execute 'docker exec -it headscale headscale apikeys create'
* login your headplane web UI with the apikey created above
* in headplane UI, add a user (e.g., rabbit) for your tailnet 
* register tailscale host
  * sudo tailscale up --login-server https://hs.your-domain.xyz, and copy & paste the login request string to your web browser which opened the headplane UI
  * you will see a cmdline string like 'headscale nodes register --user USERNAME --keys xxxxxxxxxx' in your web browser
    * replace the USERNAME with the user just created, saying rabbit, and copy it
  * in hs-server, type 'docker exec -it headscale ' and paste the string you copied
  * press return key and execute it
  * in headplane UI see if the node has been registered
    * make a double check in the newly registered tailscale host, run 'tailscale status' and check the output
* use exit-node
  * firstly use one tailscale host as exit-node
    * sudo tailscale up --login-server=https://hs.your-domain.xyz  --advertise-exit-node
  * in headplane UI, enable the exit-node for this host
    * make a double check in the registered tailscale hosts, run 'tailscale status' and check the output
  * in another tailscale host, re-start ts to using the newly enabled exit-node
    * sudo tailscale set --exit-node=EXIT-NODE-TAILNET_IP  --exit-node-allow-lan-access=true
  * check if it works

## 4. NOTE

* use ufw or iptables to limit the access to your services 
  * **ONLY** 80 & 443 are necessary
* if your VPS vendor provides its own firewall, use it

## 5. Links

* [headscale github page](https://github.com/juanfont/headscale)
* [headplane github page](https://github.com/tale/headplane)

* [tailscale kb](https://tailscale.com/kb)

  