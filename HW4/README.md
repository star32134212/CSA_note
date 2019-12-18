HW4 note
===

domain name: orangehello.nctu.me  

這次用的三個服務：  
nginx
php-fpm
mysql

主要會改到的一些設定檔都在：  
/usr/local/etc/nginx/  
/usr/local/www/  

`wg-quick up wg0` Start interface  
`wg-quick down wg0` Stop interface  

Virtual Host  and Access Control(10%)
===
`https://192.168.56.101`：ip orange  
`https://orangehello.nctu.me`：public orange  
`https://192.168.56.101/public/`：404  
`https://192.168.56.101/private/`：輸入密碼後顯示private orange  
`https://orangehello.nctu.me/public/`：404  
`https://10.113.0.129/public/`：404  
`https://10.113.0.129/private/`：403  
`https://10.113.0.129`：ip orange   

HTTPS(20%)
===
HSTS不確定(5%)  


php-fpm(5%)
===
`https://orangehello.nctu.me/info-0513404.php`：顯示php資訊  


MySQL(10%+5%)
===
user named ‘nc’ and a database named ‘nextcloud’ and pwd studen ID  
Bonus:Explain what this and other isolation levels mean   
[餵狗](https://myapollo.com.tw/zh-tw/database-transaction-isolation-levels/)

* Repeatable Read
如果在同一個 Transaction 內的 nonblocking read 會是第 1 個 read 的 snapshot ，所以相同的 read query 都會取得跟第 1 個 read 一樣的結果。除非commit回去再取才可以取得另一個Transaction更新的結果。  

* Read Committed
跟Repeatable Read差在不用先commit回去再select，直接select也可以取得另一個Transaction所更新的結果。  

* Read Uncommitted
可以讀取到其他 transactions 尚未 commit 時的資料，這被稱為 dirty read ，因為讀取尚未 commit 的資料會有些風險，這些資料在 commit 之前仍有可能還會變化，或者最後被 rollback ，導致此時讀取到的資料與資料庫最新狀態不一致。  

* Serializable
此 isolation level 在 autocommit 未啟用的情況下，會將所有的 select 都視為 select ... for share 的形式處理。此時，所有的 transactions 都能讀取資料，但是如果有其中 1 個 transaction 欲更新資料，就必須等其他 transactions 都 commit 了才行。另外，如果有其中 1 個 transaction 更新資料但是尚未 commit ，其他的 transactions 如要讀取資料，就得等該 transaction commit 。

app(10%)
===
`https://orangehello.nctu.me/app`：(/app/index.php) route: /  
`https://orangehello.nctu.me/app/1+2`：(/app/index.php) result: 3  
`https://orangehello.nctu.me/app?name=orange`：(/app/index.php) Hello, orange  

nextcloud(10%)
===
`https://orangehello.nctu.me/nextcloud/`：進入nextcloud  
nc / 0513404  
0513404 / 0513404  

Personal Webpage(10%)
===
`https://orangehello.nctu.me/sites/~0513404/`：可以看到自訂頁面

加上這段  
```
	location ~ ^\/sites {
		rewrite /sites/~([^/]+) /nextcloud/data/$1/files/public_html/index.html last;
	}
```
改這段 把templates後的data拿掉  
```
    location ~ ^\/nextcloud\/(?:build|tests|config|lib|3rdparty|templates)\/ {
            deny all;
    }
```
WebSocket(10%)
===
不會:)  


