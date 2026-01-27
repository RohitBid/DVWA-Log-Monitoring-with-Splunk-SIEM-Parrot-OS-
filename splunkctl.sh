#!/bin/bash

SPLUNK_USER="splunk"
SPLUNK_HOME="/opt/splunk"
UF_HOME="/opt/splunkforwarder"

case "$1" in
  start)
    echo "[+] Starting Splunk Enterprise..."
    sudo su - $SPLUNK_USER -c "$SPLUNK_HOME/bin/splunk start"

    echo "[+] Starting Splunk Universal Forwarder..."
    sudo su - $SPLUNK_USER -c "$UF_HOME/bin/splunk start"
    ;;
    
  stop)
    echo "[-] Stopping Splunk Universal Forwarder..."
    sudo su - $SPLUNK_USER -c "$UF_HOME/bin/splunk stop"

    echo "[-] Stopping Splunk Enterprise..."
    sudo su - $SPLUNK_USER -c "$SPLUNK_HOME/bin/splunk stop"
    ;;
    
  restart)
    $0 stop
    sleep 3
    $0 start
    ;;
    
  status)
    echo "[*] Splunk Enterprise status:"
    sudo su - $SPLUNK_USER -c "$SPLUNK_HOME/bin/splunk status"

    echo "[*] Splunk Universal Forwarder status:"
    sudo su - $SPLUNK_USER -c "$UF_HOME/bin/splunk status"
    ;;
    
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac