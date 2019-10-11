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
