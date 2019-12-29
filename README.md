# Firewall-Control
Firewall Control server / client   - Non Standardized Protocol

Requirements:  iptables , openssl, PERL

Tested on: debian/ubuntu 

Purpose: Silent UDP Socket that listens for encrypted messages and has a hook into IP Tables to control adding whitelist entries. This is preconfigured for iptables SSH access but you may use it for any protocol.

This has stopped many ip's from scanning my systems and is less intensive on the machine due to the whitelist.

The UDP server will not respond to anything as just processes messages. Scan away!  

To use:

initialize Ip tables using a whitelist. (See addWhitelist.sh) 

Note: This must run as root as will forward commands to IP tables.

Currently to run the server:
Edit fc_server.pl and supply a port to listen on. Pick a random non standard port as the idea is that the far end will have no clue of what to scan for since there is no standard. Edit the passphrase for decryption of the message and pick your own encryption scheme.

Start the server using:
./fc_server.pl 


Note if using a home router or intermediate firewall will need to port map your UDP message port and the SSH port.


From the remote machine that needs access run the client and supply the arguments:
./fc_client.pl <MESSAGE> <PASS> <IP> <UDPPORT> 





