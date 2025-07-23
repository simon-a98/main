#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -e
yum update -y
amazon-linux-extras enable nginx1
yum clean metadata
yum install nginx -y
systemctl start nginx
systemctl enable nginx

cat <<EOT > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>${title}</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: ${bgcolor};
      text-align: center;
      padding: 50px;
    }
    h1 {
      color: #333;
    }
    p {
      font-size: 18px;
      color: #666;
    }
    a {
      color: ${linkcolor};
      text-decoration: none;
    }
  </style>
</head>
<body>
  <h1>${heading}</h1>
  <p>${subtitle}</p>
</body>
</html>
EOT
