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

app(10%)
===
`https://orangehello.nctu.me/app`：(/app/index.php) route: /  
`https://orangehello.nctu.me/app/1+2`：(/app/index.php) result: 3  
`https://orangehello.nctu.me/app?name=orange`：(/app/index.php) Hello, orange  

nextcloud(10%)
===
`https://orangehello.nctu.me/nextcloud/`進入nextcloud  
nc / 0513404  
0513404 / 0513404  

Personal Webpage(10%)
===
不會:)  

WebSocket(10%)
===
不會:)  


