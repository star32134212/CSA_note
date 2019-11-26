# HW3-1 要求

FTP over TLS (5%)
===

### sysadm (15%)  
* login from ssh (4%)  
* Full access to “public” (3%)  
* Full access to “upload” (4%)  
* Full access to “hidden” (4%)  

### ftp-vip1, ftp-vip2 (15%)  
* Chrooted (/home/ftp) (4%)  
* Full access to “public” (3%)  
* Full access to “upload”, but can only delete their own files and directories. (4%)  
* Full access to “hidden” (4%)  

### Anonymous login (15%)  
* chroot (/home/ftp) (4%)  ok
* Can only upload and download from “public” (3%)  
* Can only upload and download from “upload” (4%)  
* Hidden directory “/home/ftp/hidden” problem: can enter but can’t retrieve directory listing (4%)  

## Note
#### 改權限
`chmod u/g/o/a + r/w/x [file]` 改權限  
`chmod 數字(4/2/1) [file]` 用數字改  
sticky bit:可以用`+t`或`1xxx`來改  
`chown user:group file` 可以改某檔案或資料夾的所有者/群組  

#### system user
`pw groupadd [group]` 增加group 可以去`/etc/group`看  
`pw useradd [username] -g [group] -d [home dir] -s [sh]` 增加sytemuser  
shell的部分像是平常寫作業用的orange是用/bin/tcsh，如果不想給該使用者登入則不設shell給他，可以設成/sbin/nologin  
`passwd [username]` 改密碼/新增密碼  
`rmuser username`  刪除user  
使用者資訊記在 /etc/passwd   

#### pure-ftpd
`sudo pure-pw useradd ftp-vip1 -u ftp -g ftp -d /home/ftp-vip1 -m` 新增使用者   
這裡要記得`-m`才會把使用者資料放進資料庫(/usr/local/etc/pureftpd.pdb)，不然就是要另外`pure-pw mkdb`  
`-u ftp`：ftp 為前一個步驟所建立的，可以讓所有的虛擬帳號都使用這個  
`-d /hme/ftp`：設定要給這個帳號存放檔案的目錄  
`pure-pw userdel user` 刪除使用者  
`service pure-ftpd restart` 有改conf要restart  
`pure-ftpwho` 列出誰正在連ftp server  

#### pure-pw
虛擬帳號的管理工具：
* `pure-pw usermod` 修改帳號設定
* `pure-pw userdel` 刪除帳號
* `pure-pw passwd` 設定帳號的密碼
* `pure-pw show` 顯示帳號的資料
* `pure-pw list` 列出所有的帳號

#### 開啟TLS
[TLS教學官方文件](http://pureftpd.sourceforge.net/README.TLS)  
`openssl req -x509 -nodes -newkey rsa:1024 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem`
弄好記得去pure-ftpd.conf改，要讓pure-ftpd可以連到pure-ftpd.pem這個檔  

#### wireguard
demo要連到TA電腦，所以再複習一次wg：  
`wg-quick up wg0` Start interface  
`wg-quick down wg0` Stop interface  

#### other
 /var/log/messag 可以看錯誤訊息  
pure-ftpd.conf超級長，可以用下面兩個指令去讀比較方便：  
`more [file]` 可以從頭往下看，但缺點是不能回頭，不過如果很確定想看的偏文件後面直接`cat`比較快owo  
`less [file]` 可以往前翻，比`more`更有彈性，而且可以查關鍵字，用`/ketword`去找  
`df` 檢查硬碟使用量

#### 參考教學
[pure-ftpd架設教學](http://mail.lsps.tp.edu.tw/~gsyan/freebsd2001/ftp-pureftpd.html)  
[pure-ftpd.conf文件說明](https://www.twblogs.net/a/5bedb90d2b717720b51fa65c)  
[systemuser的一些操作](https://dywang.csie.cyut.edu.tw/dywang/linuxSystem/node58.html)  
[作業3-2,3-3的掙扎owq](https://hackmd.io/52tlWKU_Rd2H0atOlT5Bdg?both)  

