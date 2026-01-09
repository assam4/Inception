FROM python:3.11-slim

WORKDIR app/

COPY tools/smtp_server.py .

RUN pip install aiosmtpd

EXPOSE 1025

CMD ["python", "-u", "smtp_server.py"]