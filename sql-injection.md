# 🛡️ SQL Injection Detection Using Splunk (DVWA Lab)

## 📌 Project Overview

This lab demonstrates an end-to-end SOC use case where SQL Injection attacks are generated against a vulnerable web application and detected using Splunk.

**The goal of this project is to:**
- Simulate real-world SQL injection attacks
- Ingest Apache web logs using Splunk
- Detect both manual and automated (sqlmap) SQL injection attempts
- Create alerts (monitors) and a security dashboard

This lab reflects how blue teams monitor and respond to web-based attacks in production environments.

---

## 🧠 Skills Demonstrated

- Web application security (SQL Injection)
- Apache access log analysis
- Splunk log ingestion & SPL
- SOC-style alerting and dashboards
- Blue-team detection engineering
- Security monitoring & incident visibility

---

## 🏗️ Lab Architecture
```
Attacker (Browser / sqlmap)
        ↓
DVWA (Apache Web Server)
        ↓
Apache access.log
        ↓
Splunk Universal Forwarder
        ↓
Splunk Enterprise
        ↓
Detection • Alerts • Dashboard
```

---

## 🔧 Tools & Technologies Used

| Tool | Purpose |
|------|---------|
| DVWA | Vulnerable web application |
| Apache | Web server & log source |
| sqlmap | Automated SQL injection tool |
| Splunk Enterprise | Log analysis & dashboards |
| Splunk Universal Forwarder | Log forwarding |
| Linux | Lab environment |

---

## ⚙️ Environment Setup

- **OS:** Linux (Debian-based)
- **Web Server:** Apache
- **DVWA installed under:**
```
  /var/www/html/DVWA
```
- **Logs monitored:**
```
  /var/log/apache2/access.log
```

---

## 🧪 Attack Simulation

### 🔹 Manual SQL Injection

Payload used in DVWA SQL Injection page:
```sql
' OR '1'='1 --
```

This confirms the application is vulnerable and generates malicious web traffic.

### 🔹 Automated SQL Injection (sqlmap)
```bash
sqlmap -u "http://localhost/DVWA/vulnerabilities/sqli/?id=1" \
-p id \
--cookie="PHPSESSID=; security=low" \
--batch
```

This simulates a real attacker using automation, commonly seen in real-world incidents.

---

## 📥 Log Ingestion in Splunk

Apache logs are ingested using Splunk Universal Forwarder:
```bash
splunk add monitor /var/log/apache2/access.log -index main -sourcetype access_combined
```

**Verification:**
```spl
index=main source="/var/log/apache2/access.log"
```
[screenshots/splunk-sqli-injection-log.png]
---

## 🔍 Detection Logic (SPL)

### 🔹 SQL Injection Payload Detection
```spl
index=main source="/var/log/apache2/access.log"
| regex uri_query="(?i)(or 1=1|union|select|sleep\(|--|%27)"
[screenshots/sql-injection-payload-detection.png]```

### 🔹 sqlmap Detection (Automated Tool)
```spl
index=main source="/var/log/apache2/access.log"
| regex _raw="(?i)sqlmap"
[screenshots/sqlmap-detection.png]```

---

## 🚨 Alert (Monitor) Configuration

**Alert Name:**
```
SQL Injection Attempt Detected – Apache
```

**Trigger Condition:**
- **Scheduled:** Every 5 minutes
- **Trigger if:** Number of results > 0
- **Severity:** High

This alert simulates a SOC detection rule for web attacks.

---

## 📊 Splunk Dashboard Panels

The dashboard includes the following panels:

### 1️⃣ SQL Injection Attempts Over Time
```spl
index=main source="/var/log/apache2/access.log"
| regex uri_query="(?i)(or 1=1|union|select|sleep\(|--|%27)"
| timechart count
```

### 2️⃣ Top Attacking IP Addresses
```spl
index=main source="/var/log/apache2/access.log"
| regex uri_query="(?i)(or 1=1|union|select|sleep\(|--|%27)"
| stats count by clientip
| sort - count
| head 10
```

### 3️⃣ Observed SQL Injection Payloads
```spl
index=main source="/var/log/apache2/access.log"
| regex uri_query="(?i)(or 1=1|union|select|sleep\(|--|%27)"
| table _time clientip uri useragent
```

### 4️⃣ Automated SQL Injection Tools (sqlmap)
```spl
index=main source="/var/log/apache2/access.log"
| regex _raw="(?i)sqlmap"
| stats count by clientip, useragent
```
[screenshots/SQL Injection Monitoring – Apache Logs.png]
---

## 🧭 MITRE ATT&CK Mapping

| Technique ID | Technique |
|--------------|-----------|
| T1190 | Exploit Public-Facing Application |

---

## ✅ Key Outcomes

- ✔️ Successfully detected SQL injection attempts via logs
- ✔️ Identified automated attacks using sqlmap
- ✔️ Built SOC-style alerts and dashboards
- ✔️ Demonstrated real-world blue-team detection workflow

---