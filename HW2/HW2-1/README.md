題目要求：  
```
Use only Bourne Shell (/bin/sh).
In ONLY ONE LINE. That is, use PIPE to calculate the results.
No temporary files or shell variables.
Only PIPE is allowed.
```
---
```
ls -ARSl | awk '$1=substr($1,0,1) {print $0}' | sed '1d' | \
awk '$1=="d" {totald += 1}; $1=="-" {totalf += 1} ; {totals += $5};NR < 6 {print NR ":" $5 "\t" $9}; \
END {print "Dir num:"totald "\nFile num:" totalf "\nTotal:" totals}'
```
`ls -A` : 不顯示.和..  
`ls -R` : 顯示所有子目錄或更下層的檔案  
`ls -S` : 依照檔案大小排序  
`ls -l` : 條列式呈現  
`awk '$1=substr($1,0,1) {print $0}'` : 把第一欄的數值取片段(位置0~1) 然後印出整條($0)  
`sed '1d'` : 刪除第一行  
`NR` : 代表awk目前處理的行數  
`$1=="d" {totald += 1}; $1=="-" {totalf += 1}` : 如果是目錄開頭會是d，如果是檔案開頭會是-  


寫成sh後要使用 `chmod +x hw2-1.sh` 讓sh檔可以執行  

## 修正
demo後會有兩個錯誤：  
1.第一個是不該把連結加進來比，所以要`grep '^-\|^d'`，多條件用`|`，加上`\`才生效。  
2.上面的code並不能將所有子資料夾的資料放在一起比較，`ls -S`會分資料夾比較。  
應改成下面：  
```
ls -ARl |grep '^-\|^d' |sort -k5,5 n  |awk '$1=substr($1,0,1) {print $0}' | sed '1d' | \
awk '$1=="d" {totald += 1}; $1=="-" {totalf += 1} ; {totals += $5};NR < 6 {print NR ":" $5 "\t" $9}; \
END {print "Dir num:"totald "\nFile num:" totalf "\nTotal:" totals}'
```
`sort -k5,5 n`：sort原本就是小排到大，不用加r，k前後兩參數是起始和結束，一般只用一個。  
