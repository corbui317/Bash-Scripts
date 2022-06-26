
#!/bin/bash
# Find and replace 'apache1.gitbaking.com'
# with your actual domain name

sudo apt-get update && sudo apt-get install apache2 -y;
sudo ufw allow in "Apache";
sudo install mysql-server -y && sudo mysql_secure_installation | echo y | echo 0;
sudo apt-get install php libapache2-mod-php php-mysql -y;
sudo mkdir /var/www/apache1.gitbaking.com && sudo chown -R $USER:$USER /var/www/apache1.gitbaking.com;
sudo touch /etc/apache2/sites-available/apache1.gitbaking.com.conf && echo > "<VirtualHost *:80>
    ServerName apache1.gitbaking.com
    ServerAlias wnaww.apache1.gitbaking.com
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/apache1.gitbaking.com
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" /etc/apache2/sites-available/apache1.gitbaking.com.conf;
touch /var/www/apache1.gitbaking.com/index.html && sudo a2ensite apache1.gitbaking.com;
touch /etc/apache2/mods-enabled/dir.conf && echo > 
"<IfModule mod_dir.c>
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>" /var/www/apache1.gitbaking.com/index.html;
sudo systemctl reload apache2;
touch /var/www/apache1.gitbaking.com/info.php && echo > "<?php
phpinfo();" /var/www/apache1.gitbaking.com/info.php; 
sudo rm /var/www/apache1.gitbaking.com/info.php;
mysql -e "CREATE DATABASE example_database;"
mysql -e "CREATE USER 'example_user'@'%' IDENTIFIED WITH mysql_native_password BY 'password';"
mysql -e "GRANT ALL ON example_database.* TO 'example_user'@'%';"
mysql -e "SHOW DATABASES;"
mysql -e "CREATE TABLE example_database.todo_list (
item_id INT AUTO_INCREMENT,
content VARCHAR(255),
PRIMARY KEY(item_id)
);"
mysql "INSERT INTO example_database.todo_list (content) VALUES ("My first important item");"
SELECT -e "* FROM example_database.todo_list;"
touch /var/www/apache1.gitbaking.com/todo_list.php && echo > "<?php
$user = "example_user";
$password = "password";
$database = "example_database";
$table = "todo_list";

try {
  $db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
  echo "<h2>TODO</h2><ol>"; 
  foreach($db->query("SELECT content FROM $table") as $row) {
    echo "<li>" . $row['content'] . "</li>";
  }
  echo "</ol>";
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}"
/var/www/apache1.gitbaking.com/todo_list.php; && echo Congratulations LAMP has been Successfully installed on your server;