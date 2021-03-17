use NetPacket::Ethernet;
use NetPacket::IP;
use NetPacket::TCP;
use Net::Pcap;
use warnings;

my $pcap_file = "./tcpdump/20190821-1311.pcap";
my $err = undef;

# read data from pcap file.
my $pcap = pcap_open_offline($pcap_file, \$err)
    or die "Can't read $pcap_file : $err\n";

pcap_loop($pcap, -1, \&process_packet, "just for the demo");

# close the device
pcap_close($pcap);

sub process_packet {
    my ($user_data, $header, $packet) = @_;
    my $eth_obj= NetPacket::Ethernet->decode($packet);

    my $ip_obj = NetPacket::IP->decode($eth_obj->{data});
    my $tcp_obj = NetPacket::TCP->decode($ip_obj->{data});
    # my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($header->{tv_sec});
    # print sprintf("%4d-02d-%02d %02d:%02d:%02d", 
    # $year+1900, $mon, $mday, $hour, $min, $sec); 

    # print $header->{tv_sec}, "  ", $header->{tv_usec}, "\n";
    # print "\t", $ip_obj->{src_ip}, ":", $tcp_obj->{src_port}, 
    #     " -> ", 
    #     $ip_obj->{dest_ip}, ":", $tcp_obj->{dest_port}, "\n";
}