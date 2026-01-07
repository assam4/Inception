FROM alpine:3.16

ARG DB_NAME DB_USER

RUN apk update &&  \
    apk add --no-cache mariadb mariadb-client && \
    mkdir /var/run/mysqld; \
    chmod 777 /var/run/mysqld; \
    { echo '[mysqld]'; \
      echo 'skip-host-cache'; \
      echo 'skip-name-resolve'; \
      echo 'bind-address=0.0.0.0'; \
    } | tee  /etc/my.cnf.d/docker.cnf; \
    sed -i "s|skip-networking|skip-networking=0|g" \
      /etc/my.cnf.d/mariadb-server.cnf; \
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

EXPOSE 3306

COPY conf/create_db.sh .
COPY tools/entrypoint.sh .

RUN chmod +x entrypoint.sh
USER mysql
CMD ["sh", "/entrypoint.sh"]
