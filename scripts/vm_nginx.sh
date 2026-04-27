
apt-get update -y


apt-get install -y nginx


systemctl enable nginx
systemctl start nginx

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
</head>
<body>
  <h1>Hello world</h1>
</body>
</html>
EOF

systemctl restart nginx

echo "testing...."