# 🚀 WatoBot — Cloud WhatsApp Automation & 24/7 Scheduled Messaging Platform

<div align="center">

[![Live Production](https://img.shields.io/badge/Production-Live%20Online-success?style=for-the-badge&logo=render)](https://mudbot-erai.onrender.com)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://github.com/sibiabi123/mudbot/blob/main/Dockerfile)
[![Node.js](https://img.shields.io/badge/Node.js-v24%20LTS-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://nodejs.org)
[![Fastify](https://img.shields.io/badge/Fastify-v4.28-000000?style=for-the-badge&logo=fastify&logoColor=white)](https://fastify.io)
[![Protocol](https://img.shields.io/badge/WhatsApp-Multi--Device-25D366?style=for-the-badge&logo=whatsapp&logoColor=white)](https://whatsapp.com)
[![Handover Docs](https://img.shields.io/badge/Documentation-20--Page%20PDF-blue?style=for-the-badge&logo=adobeacrobatreader&logoColor=white)](https://github.com/sibiabi123/mudbot/blob/main/WatoBot_Project_Handover_Document.pdf)

<br/>

**A self-hosted, 24/7 cloud microservice for automated WhatsApp messaging, recurring scheduling, and REST API dispatch.**  
*Runs autonomously in the cloud with zero Meta approvals, zero per-message fees, full group compatibility, and client-side AES-256 zero-knowledge encryption.*

[🌐 Live Production Website](https://mudbot-erai.onrender.com) • [📄 20-Page Handover PDF](https://github.com/sibiabi123/mudbot/blob/main/WatoBot_Project_Handover_Document.pdf) • [⚡ API Reference](#-restful-api-reference) • [🛠️ Architecture](#-system-architecture)

</div>

---

## 🌟 Key Highlights & Capabilities

- 🤖 **24/7 Autonomous Cloud Execution**: Runs on Render.com PaaS with automated UptimeRobot heartbeat keeping the Linux cron engine permanently awake — **your laptop and phone can be turned off!**
- 💬 **No WhatsApp Business API (WABA) Hassles**: Link your existing personal or business WhatsApp number via QR code like WhatsApp Web. No Meta business verification, no template reviews.
- 👥 **Full-Sized WhatsApp Group Support**: Send broadcasts and recurring reminders to full-sized WhatsApp groups (unlike Meta's official API which caps at 8 members).
- 🔒 **Zero-Knowledge AES-256 Encryption**: WhatsApp credentials and message payloads are encrypted with AES-256 using your browser-held secret token. The server operator cannot read your sessions or messages.
- ⚡ **Instant Direct Authentication**: One-click onboarding (<10ms token issue) without complex SMTP or Gmail App Password setups.
- ⏰ **Advanced Crontab Scheduling**: Daily, Weekly, Monthly, or One-time automated triggers with automatic UTC timezone normalization.
- 🔌 **RESTful API Access**: Generate Bearer API keys to trigger WhatsApp alerts from Python, Node.js, cURL, CRMs, or webhooks.

---

## 🏗️ System Architecture

```
                               ┌───────────────────────────────────────────────┐
                               │               User Web Browser                │
                               │   (Holds 256-bit Auth Token in localStorage)  │
                               └───────────────────────┬───────────────────────┘
                                                       │ HTTPS (REST & Static)
                                                       ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ Docker Cloud Container (Render.com - Singapore Region)                                                      │
│                                                                                                             │
│   ┌───────────────────────────┐    HTTP GET /health     ┌──────────────────────────────────────────────┐    │
│   │   Fastify Web Gateway     │ ◄────────────────────── │           UptimeRobot Watchdog               │    │
│   │       (Port 3000)         │                         │         (5-Minute Heartbeat Ping)            │    │
│   └─────────────┬─────────────┘                         └──────────────────────────────────────────────┘    │
│                 │                                                                                           │
│                 ├───────────────────────────────┬───────────────────────────────┐                           │
│                 ▼                               ▼                               ▼                           │
│   ┌───────────────────────────┐   ┌───────────────────────────┐   ┌───────────────────────────┐             │
│   │     API Routing Tier      │   │    UserService (Auth)     │   │   Process Serializer      │             │
│   │    (/api/* Endpoints)     │   │  (users/<dir>/token_hash) │   │    (userQueue FIFO)       │             │
│   └─────────────┬─────────────┘   └───────────────────────────┘   └─────────────┬─────────────┘             │
│                 │                                                               │                           │
│                 ▼                                                               ▼                           │
│   ┌───────────────────────────┐                                   ┌───────────────────────────┐             │
│   │  GNU Cron Subsystem       │                                   │  MudslideService Engine   │             │
│   │  (Linux crontab daemon)   │ ─────── Internal Loopback ──────► │   (AES-256 Encrypt/Temp)  │             │
│   │  (/app/scripts/run-sched) │         (http://127.0.0.1:3000)   └─────────────┬─────────────┘             │
│   └───────────────────────────┘                                                 │                           │
└─────────────────────────────────────────────────────────────────────────────────┼───────────────────────────┘
                                                                                  │ TLS WebSocket
                                                                                  │ (wss://web.whatsapp.com)
                                                                                  ▼
                                                                    ┌───────────────────────────┐
                                                                    │   WhatsApp Edge Servers   │
                                                                    │   (Multi-Device Gateway)  │
                                                                    └───────────────────────────┘
```

---

## 📊 Feature Comparison Matrix

| Feature Dimension | Meta Official WABA | Traditional Android Apps (SKEDit) | **WatoBot (This Project)** |
| :--- | :---: | :---: | :---: |
| **Meta Business Verification** | ❌ Required (Complex) | ❌ None | ✅ **Zero Verification Needed** |
| **Per-Message Fees** | ❌ \$0.01 - \$0.08 / msg | ❌ In-app subscription | ✅ **100% Free Forever** |
| **Message Template Approvals** | ❌ Mandatory | ✅ None | ✅ **Send Any Custom Content** |
| **WhatsApp Group Size** | ❌ Capped at 8 members | ✅ Full Groups | ✅ **Full-Sized Groups Supported** |
| **Device Independence (PC/Phone Off)** | ✅ Yes | ❌ Phone must stay ON & awake | ✅ **Runs 24/7 in Cloud** |
| **RESTful API Access** | ✅ Yes (Graph API) | ❌ No API | ✅ **Clean RESTful Endpoints** |
| **Zero-Knowledge Encryption** | ❌ Meta stores all | ❌ Local SQLite DB | ✅ **Client-Side AES-256** |

---

## 📑 Complete Handover Documentation (20 Pages)

A comprehensive, executive-level technical specification and client delivery document has been generated and checked into the repository:

👉 **[Download WatoBot_Project_Handover_Document.pdf](https://github.com/sibiabi123/mudbot/blob/main/WatoBot_Project_Handover_Document.pdf)**

### Sections Covered:
1. Executive Summary & Delivery Milestones
2. Problem Statement & Market Landscape
3. Proposed Architecture & Strategic Value
4. Complete Technology Stack Inventory
5. System Architecture & Container Process Topology
6. Zero-Knowledge Cryptography & Key Derivation Model
7. Instant Direct Authentication Lifecycle
8. WhatsApp Multi-Device Protocol & Pairing Mechanism
9. Scheduled Messaging Engine & Linux Cron Subsystem
10. Complete RESTful API Specifications
11. Frontend Design System & Responsive Bento-Grid UI
12. Docker Infrastructure & Render Deployment Pipeline
13. 24/7 Uptime & Keep-Alive Watchdog Strategy
14. Comparative Architectural Analysis (WABA vs Web vs Accessibility)
15. Quality Assurance Test Matrix & Bug Remediation History
16. Operational Runbook & Maintenance Standard Operating Procedures
17. WhatsApp Anti-Spam Security & Ban Mitigation Guidelines
18. Future Roadmap (Native APK, Webhooks, AI) & Formal Handover Sign-Off

---

## ⚡ RESTful API Reference

All protected endpoints accept the `Authorization: Bearer <authToken>` header.

### 1. Instant User Registration & Login
```http
POST /api/register
Content-Type: application/json

{
  "email": "user@example.com"
}
```
**Response (200 OK):**
```json
{
  "success": true,
  "token": "973dfe463e4fa813b5b924901325822a1a924ecfbf0e4ba735aa4d001fe7050f",
  "userDir": "973dfe463e",
  "redirectUrl": "/dashboard/?token=973dfe463e4fa813b5b924901325822a1a924ecfbf0e4ba735aa4d001fe7050f",
  "message": "Login successful! Redirecting to dashboard..."
}
```

---

### 2. Send Instant WhatsApp Message
```http
POST /api/message
Authorization: Bearer YOUR_AUTH_TOKEN
Content-Type: application/json

{
  "to": "+919345594698",
  "message": "Hello from WatoBot automated cloud microservice!"
}
```

#### Send to WhatsApp Group:
```http
POST /api/message
Authorization: Bearer YOUR_AUTH_TOKEN
Content-Type: application/json

{
  "to": "120363024829384729@g.us",
  "message": "Team update: Weekly sprint meeting starting in 15 minutes."
}
```

---

### 3. Code Integration Examples

#### Python:
```python
import requests

url = "https://mudbot-erai.onrender.com/api/message"
headers = {
    "Authorization": "Bearer YOUR_AUTH_TOKEN",
    "Content-Type": "application/json"
}
payload = {
    "to": "+919345594698",
    "message": "Automated order alert from Python!"
}

response = requests.post(url, json=payload, headers=headers)
print(response.json())
```

#### Node.js / JavaScript:
```javascript
const response = await fetch('https://mudbot-erai.onrender.com/api/message', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer YOUR_AUTH_TOKEN',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    to: '+919345594698',
    message: 'Automated notification from Node.js backend!'
  })
});
const data = await response.json();
console.log(data);
```

#### cURL:
```bash
curl -X POST https://mudbot-erai.onrender.com/api/message \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "+919345594698",
    "message": "Hello via cURL!"
  }'
```

---

## 🛠️ Technology Stack Inventory

| Component | Technology | Version | Purpose |
| :--- | :--- | :---: | :--- |
| **Runtime** | Node.js (LTS Slim) | `v24.18.0` | Asynchronous event loop engine |
| **HTTP Framework** | Fastify | `v4.28.1` | Ultra low-overhead web framework |
| **WhatsApp Transport** | Baileys / Mudslide Engine | `v0.36.1` | Headless WebSocket multi-device protocol |
| **Task Scheduler** | GNU Cron Daemon | Linux Standard | Native millisecond-accurate scheduling |
| **Containerization** | Docker Multi-Stage | Engine v27+ | 180MB lightweight deployment image |
| **Cloud Hosting** | Render.com PaaS | Singapore Region | Auto-deploying cloud infrastructure |
| **Liveness Probe** | UptimeRobot | Global Cloud | Automated 5-min heartbeat monitor |
| **Styling & Icons** | Tailwind CSS + Material Symbols | v3.4 | Modern responsive Bento-Grid UI |
| **Encryption** | Node.js Native Crypto (OpenSSL) | Native | AES-256-CBC, SHA-256 zero-knowledge |

---

## 🚀 Local Development & Self-Hosting

### Quick Run via Docker:
```bash
# 1. Clone the repository
git clone https://github.com/sibiabi123/mudbot.git
cd mudbot

# 2. Build the Docker container
docker build -t watobot .

# 3. Run container on port 3000
docker run -d -p 3000:3000 --name watobot-instance watobot

# 4. Open in browser
open http://localhost:3000
```

---

## 🔒 Security & Privacy Architecture

- **No Passwords**: Authentication is handled via cryptographically random 256-bit hex tokens (`crypto.randomBytes(32)`).
- **Zero Plaintext Sessions**: WhatsApp session credentials (`creds.json`) are TAR-archived and encrypted with AES-256-CBC (`key = sha256(token)`) into `.mudslide.enc`.
- **Ephemeral Processing**: Unencrypted session files exist in memory / temp directory (`os.tmpdir()`) only for the few milliseconds during message dispatch, and are wiped immediately via `fs.rm`.
- **Safe Public Repositories**: The entire database and `users/` directory can be publicly audited — without the client-held token, data cannot be decrypted by anyone.

---

## 📜 License & Disclaimer

This project is licensed under the MIT License.

> **⚠️ Disclaimer:** This software is an independent open-source automation tool utilizing the official WhatsApp Web multi-device protocol. It is not affiliated with, endorsed by, or sponsored by Meta Platforms, Inc. or WhatsApp LLC. Please observe WhatsApp's terms of service and avoid sending unsolicited spam.

---

<div align="center">
  <b>Designed & Engineered with ❤️ by Cloud Automation Practice</b><br/>
  <i>Ref: WATO-DOC-2026-V1.0 | Certified Production Live 24/7</i>
</div>
