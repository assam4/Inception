# USER_DOC.md

## Overview
Complete Docker-based infrastructure for WordPress with NGINX (TLS), MariaDB, Redis caching, and multiple bonus services.

## Core Services
- **NGINX** - Reverse proxy with SSL/TLS encryption (HTTPS on port 443)
- **WordPress** - PHP-FPM with Redis cache integration
- **MariaDB** - Database server with automatic initialization

## Bonus Services
- **Redis** - In-memory cache for WordPress performance
- **FTP** - File transfer access to WordPress files (Port 21)
- **Adminer** - Web-based database management tool (http://adminer.fr)
- **SMTP** - Mail server for WordPress email notifications (Port 1025)
- **Static Website** - Portfolio site on resume.fr with HTML/CSS/JavaScript

## Quick Start

### First Time (Build & Run)
```bash
make all          # or: make build && make up
```

### Subsequent Runs (Just Start)
```bash
make up           # Starts existing containers
```

### Stop Services
```bash
make down
```

### Full Reset
```bash
make re           # Cleans everything and starts fresh
make fclean       # Remove all data, images, and SSL certificates
```

## Accessing Services

| Service | URL/Port | Credentials |
|---------|----------|-------------|
| WordPress | https://saslanya.42.fr | Admin: superuser / User: simpleuser |
| WordPress Admin | https://saslanya.42.fr/wp-admin | See secrets/ folder |
| Adminer | http://adminer.fr | MariaDB credentials from secrets/ |
| Portfolio | http://resume.fr | Public page (no auth) |
| FTP | localhost:21 | User: wordpress / Pass: from secrets/wordpress/simplepass.txt |
| SMTP | localhost:1025 | No authentication (debug only) |

## Credentials
All sensitive data stored in `secrets/` folder (not in git):
- `secrets/wordpress/superpass.txt` - Admin password
- `secrets/wordpress/simplepass.txt` - FTP & simple user password
- `secrets/mariadb/db_password.txt` - WordPress DB user password
- `secrets/mariadb/db_root_password.txt` - MariaDB root password

## Data Persistence
- WordPress files: `/home/<user>/data/wordpress`
- Database files: `/home/<user>/data/mariadb`
- Redis data: `/home/<user>/data/redis`

## Useful Commands

### Check Service Status
```bash
docker ps                    # List running containers
docker ps -a                 # List all containers
docker stats                 # Monitor container resources
```

### View Logs
```bash
docker logs nginx            # View NGINX logs
docker logs wordpress        # View WordPress/PHP logs
docker logs mariadb          # View database logs
docker logs smtp             # View mail server logs
docker logs redis            # View Redis logs
docker logs -f nginx         # Follow logs in real-time (Ctrl+C to exit)
```

### WordPress Management
```bash
docker exec wordpress wp user list --allow-root                    # List all users
docker exec wordpress wp post list --allow-root                    # List all posts
docker exec wordpress wp plugin list --allow-root                  # List plugins
```

### Database Management
```bash
docker exec -it mariadb mysql -u wpuser -p wordpress              # MySQL CLI
docker exec mariadb mysqldump -u wpuser -p wordpress > backup.sql # Backup
```

### FTP Access
```bash
ftp localhost                # Connect to FTP
# Login: wordpress
# Password: (from secrets/wordpress/simplepass.txt)
```

### Mail Testing
```bash
docker exec wordpress php -r "mail('test@example.com', 'Test', 'Body', 'From: wordpress@inception.local');"
docker logs smtp                                                   # Check if received
```

### Redis Cache
```bash
docker exec redis redis-cli DBSIZE              # Check number of cached items
docker exec redis redis-cli FLUSHDB             # Clear cache
docker exec redis redis-cli INFO                # Redis info
```

## Troubleshooting

### Certificate Issues
- Self-signed SSL cert auto-generated on first run
- Located at: `/etc/nginx/ssl/saslanya.42.fr.crt` inside nginx container
- Browser will show security warning (normal for self-signed certs)

### Port Already in Use
```bash
# Find process using port
lsof -i :443          # HTTPS
lsof -i :80           # HTTP
lsof -i :3306         # MySQL
lsof -i :6379         # Redis
```

### Container Not Starting
```bash
docker logs <container>     # Check error messages
docker inspect <container>  # Detailed container info
```

### WordPress Not Loading
1. Check NGINX logs: `docker logs nginx`
2. Check PHP logs: `docker logs wordpress`
3. Verify database connection: `docker exec -it wordpress sh` then `env | grep DB`

### Performance Issues
```bash
docker stats                # Check CPU/memory usage
docker exec redis redis-cli INFO stats    # Redis performance
```
