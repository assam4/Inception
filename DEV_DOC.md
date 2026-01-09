# DEV_DOC.md - Developer Documentation

## Project Structure
```
Inception/
├── Makefile                           # Build automation
├── README.md                          # Project overview
├── USER_DOC.md                        # User guide
├── DEV_DOC.md                         # This file
├── secrets/                           # Sensitive data (not in git)
│   ├── mariadb/
│   │   ├── db_password.txt
│   │   └── db_root_password.txt
│   └── wordpress/
│       ├── superpass.txt
│       └── simplepass.txt
└── srcs/
    ├── .env                          # Environment variables
    ├── docker-compose.yml            # Docker services definition
    └── requirements/
        ├── nginx/                    # Web server (reverse proxy)
        ├── wordpress/                # PHP-FPM application
        ├── mariadb/                  # Database
        └── bonus/
            ├── redis/                # In-memory cache
            ├── ftp/                  # File transfer
            ├── adminer/              # DB management UI
            ├── smtp/                 # Mail server
            └── website/              # Static portfolio
```

## Environment Setup
### Prerequisites
```bash
# Required
docker --version          # Docker Engine 20.10+
docker-compose --version  # Docker Compose 2.0+
make --version           # GNU Make

# Optional
curl, wget               # For testing
mysql-client             # For direct DB access
```

### Initial Setup
1. Clone repository
2. Create secrets folder and files:
```bash
mkdir -p secrets/mariadb secrets/wordpress
echo "dbpassword" > secrets/mariadb/db_password.txt
echo "dbrootpassword" > secrets/mariadb/db_root_password.txt
echo "superpassword" > secrets/wordpress/superpass.txt
echo "simplepassword" > secrets/wordpress/simplepass.txt
```

3. Edit `srcs/.env` with your domain and usernames

## Makefile Commands Reference

| Command | Action |
|---------|--------|
| `make all` | Build (if needed) + start services |
| `make build` | Rebuild all images with `--no-cache` |
| `make up` | Start existing containers |
| `make down` | Stop and remove containers |
| `make re` | Full reset: fclean → all |
| `make clean` | Stop containers and delete data |
| `make fclean` | Complete cleanup: containers, images, volumes, SSL certs |

## Service-Specific Development

### NGINX (Reverse Proxy)
**Location:** `srcs/requirements/nginx/`

**Key Files:**
- `Dockerfile` - Alpine Linux + OpenSSL + NGINX
- `conf/nginx.conf` - NGINX configuration
- `tools/generate_ssl.sh` - Self-signed certificate generation

**Verification:**
```bash
# Check NGINX status
docker logs nginx

# Test SSL certificate
docker exec nginx openssl x509 -in /etc/nginx/ssl/saslanya.42.fr.crt -text -noout

# Test connectivity
curl -k https://saslanya.42.fr        # Test WordPress
curl http://adminer.fr                # Test Adminer proxy
curl http://resume.fr                 # Test static site

# Check NGINX configuration
docker exec nginx nginx -t            # Syntax check
docker exec nginx cat /etc/nginx/nginx.conf
```

### WordPress (PHP-FPM)
**Location:** `srcs/requirements/wordpress/`

**Key Features:**
- Redis cache enabled
- SMTP mail server integration
- Automatic user creation
- WP-CLI for management

**Verification:**
```bash
# Check PHP-FPM
docker exec wordpress ps aux | grep php

# Verify database connection
docker exec wordpress php -r "
  \$link = mysqli_connect('mariadb', 'wpuser', getenv('DB_PASS'), 'wordpress');
  echo mysqli_connect_error() ? 'FAILED' : 'OK';
"

# Test Redis cache
docker exec wordpress php -r "
  \$redis = new Redis();
  \$redis->connect('redis', 6379);
  echo 'Redis: ' . (\$redis->ping() ? 'OK' : 'FAILED');
"

# Test SMTP mail
docker exec wordpress php -r "mail('test@example.com', 'Test', 'Body', 'From: wordpress@inception.local');"
docker logs smtp

# Check WordPress installation
docker exec wordpress wp --version --allow-root
docker exec wordpress wp option get siteurl --allow-root
```

### MariaDB (Database)
**Location:** `srcs/requirements/mariadb/`

**Key Features:**
- Automatic database initialization
- User creation with password from secrets
- Persistent storage

**Verification:**
```bash
# Check database status
docker logs mariadb

# Test database connection
docker exec -it mariadb mysql -u wpuser -p$(cat ~/secrets/mariadb/db_password.txt) -e "SELECT 1;"

# Check WordPress database
docker exec mariadb mysql -u wpuser -p$(cat ~/secrets/mariadb/db_password.txt) -e "USE wordpress; SHOW TABLES;"

# Backup database
docker exec mariadb mysqldump -u wpuser -p$(cat ~/secrets/mariadb/db_password.txt) wordpress > backup.sql

# Check database size
docker exec mariadb mysql -u wpuser -p$(cat ~/secrets/mariadb/db_password.txt) -e "SELECT table_name, ROUND(((data_length + index_length) / 1024 / 1024), 2) AS size_mb FROM information_schema.TABLES WHERE table_schema = 'wordpress';"
```

### Redis (Cache)
**Location:** `srcs/requirements/bonus/redis/`

**Verification:**
```bash
# Check Redis status
docker logs redis

# Test Redis connectivity
docker exec redis redis-cli ping                    # Should return PONG

# Monitor cache
docker exec redis redis-cli DBSIZE                  # Number of keys
docker exec redis redis-cli KEYS '*'                # List all keys
docker exec redis redis-cli INFO stats              # Statistics

# Clear cache
docker exec redis redis-cli FLUSHDB                 # Clear current DB
docker exec redis redis-cli FLUSHALL                # Clear all DBs

# Real-time monitoring
docker exec redis redis-cli MONITOR
```

### FTP Server
**Location:** `srcs/requirements/bonus/ftp/`

**Verification:**
```bash
# Check FTP status
docker logs ftp

# Test FTP connection
ftp localhost
# Login: wordpress
# Password: (from secrets/wordpress/simplepass.txt)
# ls, get, put, quit

# Or use curl
curl ftp://localhost --user wordpress:simplepassword

# Check FTP config
docker exec ftp cat /etc/vsftpd.conf | grep -E "^[^#]"
```

### Adminer (Database Web UI)
**Location:** `srcs/requirements/bonus/adminer/`

**Verification:**
```bash
# Check Adminer status
docker logs adminer

# Access web interface
# URL: http://adminer.fr
# Server: mariadb
# Username: wpuser
# Password: (from secrets/mariadb/db_password.txt)
# Database: wordpress

# Test connectivity
curl -s http://adminer.fr | grep -i "adminer" | head -1
```

### SMTP Mail Server
**Location:** `srcs/requirements/bonus/smtp/`

**Verification:**
```bash
# Check SMTP status
docker logs smtp

# Test mail sending
docker exec wordpress php -r "mail('test@example.com', 'Test Subject', 'Test Body', 'From: wordpress@inception.local');"

# Check if mail was received
docker logs smtp | grep -A 10 "NEW EMAIL"

# Test with telnet (inside container)
docker exec -it smtp sh
telnet localhost 1025        # Should connect to SMTP

# Check msmtp configuration
docker exec wordpress cat /etc/msmtprc
docker exec wordpress cat /var/log/msmtp.log
```

### Static Website (Portfolio)
**Location:** `srcs/requirements/bonus/website/`

**Verification:**
```bash
# Check website status
curl -s http://resume.fr | grep -i "portfolio\|devportfolio"

# Check static files
docker exec nginx ls -la /portfolio/
docker exec nginx cat /portfolio/index.html | head -20
```

## Debugging Tips

### Container Shell Access
```bash
# Interactive shell
docker exec -it <container> sh       # Alpine/lightweight
docker exec -it <container> bash     # Debian-based

# Example: WordPress shell
docker exec -it wordpress sh
```

### Environment Variables
```bash
# Check container environment
docker exec <container> env | sort

# Example: WordPress environment
docker exec wordpress env | grep DB
docker exec wordpress env | grep REDIS
```

### Network Testing
```bash
# Check container connectivity
docker exec wordpress ping mariadb
docker exec wordpress ping redis
docker exec wordpress ping smtp

# DNS resolution
docker exec wordpress nslookup mariadb
docker exec wordpress getent hosts mariadb
```

### File Inspection
```bash
# Check mounted volumes
docker exec wordpress ls -la /var/www/
docker exec mariadb ls -la /var/lib/mysql/

# Check logs
docker exec wordpress tail -f /var/log/php-fpm.log
docker exec nginx tail -f /var/log/nginx/error.log
```

### Resource Monitoring
```bash
# Real-time stats
docker stats

# Container inspection
docker inspect <container>

# Memory usage
docker exec <container> free -h

# Disk usage
docker exec <container> df -h
```

## Custom Commands (Add to Makefile)

### Add cache flush command
```makefile
flush-cache:
	@docker exec redis redis-cli FLUSHDB
	@echo "Redis cache cleared"
```

### Add database backup
```makefile
backup-db:
	@docker exec mariadb mysqldump -u wpuser -p $(shell cat ~/secrets/mariadb/db_password.txt) wordpress > backup-$(shell date +%Y%m%d-%H%M%S).sql
	@echo "Database backed up"
```

### Add log viewer
```makefile
logs:
	docker compose -f ./srcs/docker-compose.yml logs -f
```

## Useful Docker Compose Commands

```bash
# Manual operations (don't use Makefile)
docker compose -f srcs/docker-compose.yml --env-file srcs/.env ps

# Rebuild single service
docker compose -f srcs/docker-compose.yml --env-file srcs/.env build --no-cache wordpress

# Restart service
docker compose -f srcs/docker-compose.yml --env-file srcs/.env restart wordpress

# Execute command in running container
docker compose -f srcs/docker-compose.yml exec wordpress wp option get siteurl --allow-root
```

## Performance Optimization

### WordPress Caching
```bash
# Verify WordPress cache is working
docker exec wordpress wp redis status --allow-root
```

### Database Optimization
```bash
# Analyze tables
docker exec -it mariadb mysql -u wpuser -p wordpress -e "ANALYZE TABLE wp_posts, wp_postmeta;"

# Check query log (for debugging)
docker exec -it mariadb mysql -u wpuser -p wordpress -e "SET GLOBAL general_log = 'ON';"
```

### Disk Usage Cleanup
```bash
# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# See disk space
docker system df
```

## Security Notes
- Secrets are NOT committed to git (.gitignore)
- SSL certificates are self-signed (for development)
- Database password changes require container rebuild
- FTP credentials from WordPress simple user password
- SMTP is debug-only (no authentication)
