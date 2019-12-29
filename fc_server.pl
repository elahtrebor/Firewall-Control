#!/usr/bin/perl -w
# Firewall Control - UDP message server
use strict;
use IO::Socket;
my $DEBUG = 1;
my($server, $clientmsg, $remotehost, $MAXLEN, $UDPPORT);

$MAXLEN = 1024;
$PORTNO = 9999; # THIS IS THE UDP PORT in which the server will listen on

# Start the server
$server = IO::Socket::INET->new(
           LocalPort => $UDPPORT,
       Proto => 'udp') or die "Socket Create Error: $@";
if($DEBUG){
 print "Awaiting UDP messages on port $UDPPORT\n";
}
 # get the messages
while ($server->recv($clientmsg, $MAXLEN)) {
    my($port, $ipaddr) = sockaddr_in($server->peername);
    my $clientip = $server->peerhost;
    $remotehost = gethostbyaddr($ipaddr, AF_INET);
   if($remotehost !~/[0-9]+/){ $remotehost = $clientip;}
if($DEBUG){
    print "Client $remotehost sent $clientmsg\n";
  }
   chomp($clientmsg);
  # Decypt the packet
   my $dmsg = `echo $clientmsg | openssl base64 -d | openssl enc -d  -aes-256-cbc -md sha512 -pbkdf2 -iter 1000 -k "passphrase"`;
  if($DEBUG){
    print "DECODE: $dmsg\n";
    }
 my $v = 0;
 my $cmd = "";
   $clientmsg = $dmsg;
   # Process a message only if it meets the decrypted command 
   if($dmsg=~/100/){
   if($DEBUG){  print "COMMAND 100 iptables add host $remotehost/32..\n"; }
    $cmd = "iptables -I INPUT 2 -s $remotehost/32 -p tcp -m tcp --dport 22 -j ACCEPT"; $v++; }
   if($clientmsg=~/300/){
  if($DEBUG) { print "COMMAND 300 iptables flush executed..\n"; }
  $cmd = "iptables --flush"; $v++; }
   if($clientmsg=~/900/){
   if($DEBUG){ print "COMMAND 900 initialize core whitelist..\n";}
   $cmd = "/home/fwc/addWhitelist.sh"; $v++; }
  if($v > 0) { `$cmd`; $v = 0;}
}
die "recv: $!";
