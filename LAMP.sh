

#!/bin/bash
# Find and replace 'apache1.gitbaking.com'
# with your actual domain name

sudo apt-get update && sudo apt-get install apache2 -y;
sudo ufw allow in "Apache";
sudo apt-get install mysql-server -y;
sudo apt-get install php libapache2-mod-php php-mysql -y;



sudo echo "Please remember the following database password"
sudo echo "It will be required during the installation wizard"
read -s -p "Please enter a strong database password: " DEFAULT_PASSWORD
sudo echo "Please remember the following MySQL Root password"
read -s -p "Please enter a strong database password: " MYSQL_ROOT_PASSWORD
sudo echo ""
sudo echo "Thanks for inserting your Root Password for MySQL"

sudo echo ""
#SQL commands to be referenced later
SQL_COMMAND_1="CREATE DATABASE example_database.todo_list DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
SQL_COMMAND_2="CREATE USER 'example_database.todo_list'@'localhost' IDENTIFIED BY '${DEFAULT_PASSWORD}';"
SQL_COMMAND_3="GRANT ALL ON example_database.todo_list.* TO 'example_database.todo_list'@'localhost';"

#Create TestRail Database and User
sudo echo "Configuring your TestRail Database now..."
mysql -u root -p$MYSQL_ROOT_PASSWORD << eof
$SQL_COMMAND_1
eof

mysql -u root -p$MYSQL_ROOT_PASSWORD << eof
$SQL_COMMAND_2
eof

mysql -u root -p$MYSQL_ROOT_PASSWORD << eof
$SQL_COMMAND_3
eof

echo "This has been completed"
echo "Running MySQL Secure installation now"
sleep 4s

tee ~/temp.sh > /dev/null << EOF
spawn $(which mysql_secure_installation)

expect "Enter password for user root:"
send "$MYSQL_ROOT_PASSWORD\r"

expect "Press y|Y for Yes, any other key for No:"
send "n\r"

expect "Change the password for root ? ((Press y|Y for Yes, any other key for No) :"
send "n\r"

expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) :"
send "y\r"

EOF

sudo expect ~/temp.sh
rm -v ~/temp.sh
sudo mkdir -p /var/www/apache1.gitbaking.com && sudo chown -R $USER:$USER /var/www/apache1.gitbaking.com;
sudo mkdir -p /etc/apache2/sites-available;
echo "<VirtualHost *:80>
    ServerName apache1.gitbaking.com
    ServerAlias wnaww.apache1.gitbaking.com
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/apache1.gitbaking.com
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/apache1.gitbaking.com.conf;
mkdir -p /var/www/apache1.gitbaking.com/index.html && sudo a2ensite apache1.gitbaking.com;
mkdir -p /etc/apache2/mods-enabled;

 echo "<IfModule mod_dir.c>
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>" > /var/www/apache1.gitbaking.com/index.html;
sudo systemctl reload apache2;
mkdir -p /var/www/apache1.gitbaking.com/info.php && echo > "<?php
phpinfo();" /var/www/apache1.gitbaking.com/info.php; 
sudo rm /var/www/apache1.gitbaking.com/info.php;
mysql "INSERT INTO example_database.todo_list (content) VALUES ("My first important item");"
SELECT -e "* FROM example_database.todo_list;"
touch /var/www/apache1.gitbaking.com/ && touch /var/www/apache1.gitbaking.com/todo_list.php;
echo "<?php
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
}" > /var/www/apache1.gitbaking.com/todo_list.php; && systemctl restart apache2; | echo Congratulations LAMP has been Successfully installed on your server;
