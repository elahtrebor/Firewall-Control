#!/usr/bin/perl
# get arguments

($message, $pass, $ip, $port) = (@ARGV);


if(@ARGV< 4){
	print "Incorrect Arguments. Please use $0 <MESSAGE> <PASS> <IP> <UDPPORT>\n";
	exit;
}

# Call openssl and encrypt your message using password
$encmsg = `echo -n "$message"|openssl enc -e -aes-256-cbc -md sha512 -pbkdf2 -iter 1000 -a -k "$pass"`;

# open a socket to your IP Address and send the message

#print "CONNECT: $message  $pass $ip $udpport
use IO::Socket;

my $sock = IO::Socket::INET->new(
	    Proto    => 'udp',
	    PeerPort => $port,
	    PeerAddr => $ip,
	    ) or die "Could not create socket: $!\n";

	    $sock->send("$encmsg") or die "Send error: $!\n";



