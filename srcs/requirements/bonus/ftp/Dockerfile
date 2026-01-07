FROM debian:bullseye

RUN apt-get update && apt-get install -y --no-install-recommends vsftpd && rm -rf /var/lib/apt/lists/*; \
    mkdir -p /var/run/vsftpd/empty && chmod 555 /var/run/vsftpd/empty

WORKDIR /var/www

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 21 6000-6100

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]