# 🛡️ IPTOOLKIT v2.0
**A powerful, batch-based network reconnaissance and information gathering toolkit for Windows.**

![Platform](https://img.shields.io/badge/Platform-Windows-blue)
![Language](https://img.shields.io/badge/Language-Batch%20%7C%20PowerShell-green)
![Version](https://img.shields.io/badge/Version-2.0-brightgreen)
![Author](https://img.shields.io/badge/Author-RaGESH0T-red)

**~by RaGESH0T**

---

## 📖 Overview
IPTOOLKIT is a lightweight, command-line interface (CLI) script designed to streamline various network information gathering tasks. It combines native Windows commands (CMD/PowerShell) with external executable tools to provide a unified dashboard for public and local IP reconnaissance.

## ✨ Features

### 🌐 Public IP Tools
*   **[1] Geolocate:** Fetches detailed geolocation data (ISP, City, Region, Country, Coordinates, Timezone) for any public IP using a secure PowerShell API request.
*   **[2] Trace DNS:** Performs a reverse DNS lookup or domain resolution to find the associated domain name.
*   **[3] Port Scan (External):** Scans specified ports on a target public IP.
*   **[4] DDOS:** Quick-launch menu for popular stress-testing/DDOS websites (requires your own account/API on those platforms).

### 🏠 Local IP Tools
*   **[5] Trace MAC Address:** Pings a local IP and retrieves its corresponding MAC address using the ARP table.
*   **[6] Port Scan (Internal):** Scans specified ports on a local network device.
*   **[7] ARP Spoof (DOS):** Launches an ARP spoofing attack against a target IP (Requires `arpspoof.exe`).
*   **[8] RPC Dump:** Attempts to dump RPC endpoints from a target machine.

## ⚙️ Requirements & Setup

### Prerequisites
1.  **Windows OS** (Windows 10 or 11 recommended).
2.  **PowerShell** (Pre-installed on modern Windows).
3.  **UTF-8 Encoding:** The `.bat` file must be saved with UTF-8 encoding to display the custom ASCII art correctly.

### Folder Structure
For the script to work correctly, your folder structure **must** look like this:

```text
📁 IPTOOLKIT/
 ┣ 📄 IPTOOLKIT.bat       <-- The main script
 ┣ 📄 README.md           <-- This file
 ┗ 📁 files/              <-- Required folder for external tools
    ┣ 📄 PortScanner.exe  <-- Required for Options 3 & 6
    ┣ 📄 arpspoof.exe     <-- Required for Option 7
    ┗ 📄 banner.txt       <-- (Optional) Custom ASCII banner
