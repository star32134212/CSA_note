# CSA_note
Computer System Administration


### 寄信
`uuencode filename.zip Attachment.zip| mail -s "Subject" abc@domain`  
filename.zip : 要寄信的檔名  
Attachment.zip: 收件者看到附件的名字  
Subject: 信件標題  
abc@domain: Email  
若找不到 uuencode, 可: apt-get install sharutils  
或是只是想把某段文字寄出可以先打在一個檔中再用下面的方式寄  
`mail -s '0513404' star32134212@gmail.com < file`  

### 壓縮
`tar xvf FileName.tar` 解壓縮tar  
`tar cvf FileName.tar DirName` 壓縮tar  


### 安裝
`sudo pkg install XXXX`
