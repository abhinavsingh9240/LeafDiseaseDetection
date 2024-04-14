# Server Configuration

Updating to latest packages
```bash
sudo apt-get update
sudo apt-get upgrade
```

Installing Python Virtual Environment Package
```bash
sudo apt-get install python3-venv
```

Cloning Repository
```bash
git clone <project-url/SSH Address>
```

Creating a virtual env with dependencies
```bash
python -m venv env
source env/bin/activate
pip install -r requirements.txt
```

Installing gunicorn too
```bash
pip install gunicorn
```


Installing Nginx
```bash
sudo apt-get install -y nginx
```
Check the IP to ensure that nginx is running 

Installing Supervisor to ensure that server keep running
```bash
sudo apt-get install supervisor
```

Creating configuration to run gunicorn
```bash
cd /etc/supervisor/conf.d/
sudo touch gunicorn.conf
sudo nano gunicorn.conf
```
Sample Conf File
```conf
[program:gunicorn]
directory=/home/ubuntu/LeafDiseaseDetection/API
command=/home/ubuntu/LeafDiseaseDetection/API/env/bin/gunicorn --workers 3 --bind unix:/home/ubuntu/LeafDiseaseDetection/API/app.sock API.wsgi:application  
autostart=true
autorestart=true
stderr_logfile=/var/log/gunicorn/gunicorn.err.log
stdout_logfile=/var/log/gunicorn/gunicorn.out.log

[group:guni]
programs:gunicorn
```

```bash
sudo mkdir /var/log/gunicorn
```

```bash
sudo supervisorctl reread
sudo supervisorctl update
```
Make sure it is running by checking Running Status
```bash
sudo supervisorctl status
```
### Configure Nginx
```bash
cd /etc/nginx
sudo nano nginx.conf
```
In `nginx.conf` ,change `www-data` to `root` user, then

```bash
cd sites-available
sudo touch django.conf
sudo nano django.conf
```
```conf
server{

	listen 80;
	server_name <fill ip_address or domain>;

	
	location / {

		include proxy_params;
		proxy_pass http://unix:/home/ubuntu/LeafDiseaseDetection/API/app.sock;

	}

}
```
Checking nginx is working fine
```bash
sudo nginx -t 
```
Enabling site
```bash
sudo ln django.conf /etc/nginx/sites-enabled 
```
Restarting nginx server
```bash
sudo service nginx restart
```