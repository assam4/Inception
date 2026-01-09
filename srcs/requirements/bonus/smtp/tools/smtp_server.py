import asyncio
import sys
from aiosmtpd.controller import Controller
from datetime import datetime

class Handler:
    async def handle_DATA(self, server, session, envelope):
        print(f"\n{'='*70}", flush=True)
        print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] NEW EMAIL RECEIVED", flush=True)
        print(f"{'='*70}", flush=True)
        print(f"From: {envelope.mail_from}", flush=True)
        print(f"To: {', '.join(envelope.rcpt_tos)}", flush=True)
        print(f"\nContent:", flush=True)
        print(envelope.content.decode('utf-8', errors='ignore'), flush=True)
        print(f"{'='*70}\n", flush=True)
        return '250 OK'

print("[*] Starting SMTP Server on 0.0.0.0:1025...", flush=True)
controller = Controller(Handler(), hostname="0.0.0.0", port=1025)
controller.start()
print("[+] SMTP Server started successfully!", flush=True)

try:
    asyncio.get_event_loop().run_forever()
except KeyboardInterrupt:
    print("\n[*] Shutting down...", flush=True)
    controller.stop()
    print("[+] SMTP Server stopped", flush=True)