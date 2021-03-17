# acomBackendTest

## Test Objectives 1
### 使用 *sysbench* 對資料庫進行壓力測試

#### 1. sysbench prepare
`sysbench /usr/share/sysbench/oltp_read_write.lua --debug=on 
--mysql-db=sbtest --mysql-password=1234NewPassWord! 
--db-driver=mysql --table-size=1000000 
--mysql-user=root prepare`

#### 2. sysbench run
`sysbench /usr/share/sysbench/oltp_read_write.lua --debug=on 
--mysql-db=sbtest --mysql-password=1234NewPassWord! 
--db-driver=mysql --table-size=1000000 
--mysql-user=root run`

![](https://i.imgur.com/UTLtLg3.jpg)

#### 3. sysbench clean
`sysbench /usr/share/sysbench/oltp_read_write.lua --debug=on 
--mysql-db=sbtest --mysql-password=1234NewPassWord! 
--db-driver=mysql --table-size=1000000 
--mysql-user=root clean`

## Test Objectives 2
### 使用 *perl* parser pcap file

<font color="red">僅完成pcap file parser</font>

無法安裝 perl DBI 及 DBD::mysql model

```perl=
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
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($header->{tv_sec});
    print sprintf("%4d-02d-%02d %02d:%02d:%02d", 
    $year+1900, $mon, $mday, $hour, $min, $sec); 

    print $header->{tv_sec}, "  ", $header->{tv_usec}, "\n";
    print "\t", $ip_obj->{src_ip}, ":", $tcp_obj->{src_port}, 
        " -> ", 
        $ip_obj->{dest_ip}, ":", $tcp_obj->{dest_port}, "\n";
}
```

## Test Objectives 3
### 使用 *php* 確認my sql 狀態
```php=
<?php
$server = "localhost";         # MySQL 伺服器
$dbuser = "root";       # 使用者帳號
$dbpassword = "1234NewPassWord!"; # 使用者密碼
$dbname = "sbtest";    # 資料庫名稱

# 連接 MySQL 資料庫
$connection = new mysqli($server, $dbuser, $dbpassword, $dbname);

# 檢查連線是否成功
if ($connection->connect_error) {
  $data = [ 'mysql_status' => 'ERROR'];
} else {
  $data = [ 'mysql_status' => 'OK'];
}

$connection->close();

header('Content-Type: application/json');
echo json_encode($data);
?>
```

### 使用python 對 php request
```python=
import sys
import configparser
import os
from datetime import datetime

def loadConfig(section, name):
    curpath = os.path.dirname(os.path.realpath(__file__))
    cfgpath = os.path.join(curpath, 'config.ini')
    # 創建對象
    conf = configparser.SafeConfigParser()
    # 讀取INI
    conf.read(cfgpath, encoding='utf-8')
    return conf.get(section, name)

url = loadConfig('system', 'URL')
isLogger = loadConfig('system', 'logger')

resp = requests.get(url)
response = resp.json()
time = '['+datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")+']'
fp = open("../home/logs/monitor.log", 'a+')
if(resp.status_code == requests.codes.ok):
        response = resp.json()
        fp.write(time+ ' '+ response['mysql_status']+':PID:'+str(os.getpid())+' ,response'+str(response)+'\n')
else:
        fp.write(time+ ' ERROR:PID:'+str(os.getpid())+' ,ERROR-Can\'t connect to ' + url + '\n')
```

### bash script
```bash=
#!/bin/sh
export  PATH=/bin:/sbin:/usr/bin:/usr/sbin
python monitor.py
```

### crontab
```
*/5 * * * * /root/job.sh
```
