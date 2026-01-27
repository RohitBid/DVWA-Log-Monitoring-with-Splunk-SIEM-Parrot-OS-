# 🛡️ DVWA Log Monitoring with Splunk SIEM (Parrot OS)

This lab demonstrates how to deploy **Splunk Enterprise** and **Splunk Universal Forwarder** on **Parrot OS**, forward **DVWA (Apache) and Linux system logs**, and validate log ingestion for SOC‑style monitoring.

---

## 📌 Lab Objectives

* Deploy Splunk Enterprise on Parrot OS
* Configure Splunk Universal Forwarder
* Forward DVWA (Apache) logs to Splunk
* Handle OpenSSL & systemd conflicts on rolling Linux
* Validate log ingestion via Splunk Web
* Implement clean start/stop operational control

---

## 🧪 Lab Environment

| Component | Details                         |
| --------- | ------------------------------- |
| OS        | Parrot Security OS (rolling)    |
| Web App   | DVWA (Apache + PHP)             |
| SIEM      | Splunk Enterprise 10.x          |
| Log Agent | Splunk Universal Forwarder 10.x |
| Browser   | Firefox                         |

---

## 🏗️ Architecture

```
DVWA (Apache)
   ├── access.log
   ├── error.log
   ↓
Splunk Universal Forwarder
   ↓ TCP 9997
Splunk Enterprise (Indexer + Search Head)
   ↓
Splunk Web (http://localhost:8000)
```

---

## ⚙️ Installation Summary

### Splunk Enterprise

* Installed using `.deb` package
* Installed to `/opt/splunk`
* Managed manually (no systemd auto‑start)

### Splunk Universal Forwarder

* Installed using `.deb` package
* Installed to `/opt/splunkforwarder`
* Forwarding configured to `127.0.0.1:9997`

---

## ⚠️ Key Challenges & Fixes

### 1. OpenSSL / systemd Conflict

**Issue:**

```
libcrypto.so.3: version `OPENSSL_3.4.0' not found
```

**Cause:**

* Parrot OS uses OpenSSL 3.4
* Splunk bundles older OpenSSL

**Fix:**

* Avoid systemd boot‑start
* Manually control Splunk using CLI and custom script

---

### 2. Forwarder Management Port Conflict

**Issue:**

* Both Splunk Enterprise and Forwarder tried to use port `8089`

**Fix:**

* Changed Universal Forwarder management port to `8090`

---

### 3. Apache Log Permission Issues

**Issue:**

```
Permission denied: /var/log/apache2/access.log
```

**Cause:**

* Apache logs owned by `root:adm`

**Fix:**

```bash
sudo usermod -aG adm splunk
```

---

### 4. File‑based Monitoring CLI Bug

**Issue:**

```
Parameter name: Path must be a file or directory
```

**Fix (Best Practice):**

* Monitor **directory** instead of single file

```bash
/opt/splunkforwarder/bin/splunk add monitor /var/log/apache2/
```

---

### 5. System Logs on Parrot OS

**Finding:**

* `/var/log/syslog` does not exist
* Parrot uses `systemd‑journald`

**Resolution:**

* Focused on Apache + auth logs for this lab
* rsyslog can be enabled if needed

---

## 🔁 Operational Control Script

To safely manage Splunk without systemd:

```bash
splunkctl start
splunkctl stop
splunkctl restart
splunkctl status
```

**Benefits:**

* Avoids OpenSSL/systemd crash
* Saves system resources
* SOC‑friendly manual control

---

## 🔍 Validation in Splunk Web

### Check Apache Logs

```spl
index=* source="/var/log/apache2/access.log"
```

### Check Forwarder Health

```spl
index=_internal sourcetype=splunkd component=TcpOutputProc
```

### Inventory All Data Sources

```spl
index=* | stats count by source
```

---

## 📊 Splunk Health Check

* File Monitor Input ✅
* Index Processor ✅
* Search Scheduler ✅
* IOWait ⚠️ (Expected in lab VM)

---

## 🎯 Outcomes

* Successfully deployed Splunk SIEM on Parrot OS
* Forwarded DVWA Apache logs in real time
* Validated end‑to‑end log ingestion
* Gained hands‑on experience with:

  * Linux permissions
  * SIEM deployment
  * Forwarder/indexer architecture
  * Rolling‑release OS challenges

---

## 🧠 SOC Skills Demonstrated

* SIEM installation & troubleshooting
* Log forwarding architecture
* Linux security & permissions
* Apache log analysis
* Operational hardening
* Incident‑ready monitoring setup

---

## 📌 Future Enhancements

* SQL Injection detection SPL
* XSS attack correlation
* SSH brute‑force detection
* MITRE ATT&CK mapping
* SOC dashboards

---

## 🏁 Conclusion

This lab simulates a **real‑world SOC SIEM deployment** on a hardened Linux distribution. It highlights practical challenges faced by analysts and demonstrates effective troubleshooting, secure configuration, and operational discipline.

---

**Author:** SOC / Blue Team Lab
**Status:** ✅ Completed
