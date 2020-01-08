HW5 note
===
[大佬yuuki教學](https://yuuki1532.wordpress.com/2020/01/05/sa-hw5-nisnfs/)  
[資工大佬們的共筆教學](https://hackmd.io/qHjXJTbFSK2uxt8erN8iFw)  

### 5-1 NIS Client(15%)  
他原本的設定就是相容模式 要靠以前 +:::::的方式 才能用
如果直接nis files這樣指定 就不用+:::::了，但用+:::::的方式不會卡開機，因此還是要用  
5-1測試：  
可以`su - nisuser1`到nisuser1的家目錄  

### 5-2 NFS Client(10%)  
這兩個服務要記得啟用  
```
service start automount
service start automountd
```
5-2測試：  
可以cd /net/data看到助教的放的檔案  

### 5-3 NFS Server (30%)
照著大佬做  
NFS Server (trying)  
enable NFS + v4 + nfsuserd  
```
(/etc/rc.conf)
nfs_server_enable="YES"
nfsv4_server_enable="YES"
nfsuserd_enable="YES"
nfs_server_flags="-u -t -n 6″
mountd_enable="YES"
```
mkdir  
```
(/net)
$ sudo mkdir alpha share admin
```
exports setting  
```
(/etc/exports)
V4: / -sec=sys
/net/alpha /net/share /net/admin -maproot=nobody -network 10.113.0.0/16
```
### 5-4 Firewall(15%)  
照著大佬打的  

5-4測試：  
開好wireguard 用10.113.128.129  
`sudo service ipfw stop`  
可以ping到  
`sudo service ipfw start`  
可以ping到  
`sudo bash ./set_ip.sh`  
ping 不到  

### 5-5 autoban(15%):  
新增  
```
(/etc/rc.conf)
blacklistd_enable="YES"
sshd_flags="-o UseBlacklist=yes"
pf_enable=yes
```

修改  
```
(/etc/blacklistd.conf)
ssh stream * * * 5 24h
#* * * * * 3 60
#註解* * * * * 3 60
```

新增  
```
(/etc/pf.conf)
anchor “blacklistd/*" in
```

下面理論上是空的，有ban才有東西  
`sudo blacklistctl dump -br` 可以看到ban還會持續多久
`sudo pfctl -a blacklistd/22 -t port22 -T show`只看得到被ban的ip  

故意讓它ban，之後用下面的方式unban  
`sudo pfctl -a blacklistd/22 -t port22 -T delete 192.168.56.1/32`

### 5-5-2 iamagoodguy (5%)
```
(/usr/local/bin/iamagoodguy)
#!/usr/local/bin/bash

if [[ “$#" -ne 1 ]]; then
echo “Usage: iamagoodguy “
exit 0
fi

pfctl -a blacklistd/22 -t port22 -T delete “$1″/32
```
`chmod +x`後就可以直接呼叫，不用透過bash  
`sudo chmod +x /usr/local/bin/iamagoodguy`
`iamagoodguy 192.168.56.1` 

### bonus 
* 之前的作業能正常跑(10%)

* 重新開機不會出問題(10%)

在`/usr/local/etc/rc.d`編輯`wireguard`   
REQUIRE的地方改成下面這樣  
```
# REQUIRE: ntpd DAEMON
```
開機會很久的問題在於ntpd在wireguard之後開啟會卡，REQUIRE代表要開啟以下服務需要先開啟的服務，這邊可以讓ntpd先開完再開wireguard  