# Dynamic IP Hunter — Automating IP Tracking for TP-Link ER605 Load Balancer

## Overview
In budget-conscious environments, small to mid-sized companies often avoid static IPs from ISPs due to their recurring cost. Instead, they use **dynamic IPs** provided by consumer-grade routers connected through an **enterprise load balancer like the TP-Link ER605**, which balances internet traffic across multiple ISP lines (e.g., **Jio, Airtel, and Sity**).

However, this introduces an operational headache — **these dynamic public IPs change frequently**, sometimes even daily. This becomes a serious issue when you need to **access AWS resources like EC2 (via SSH) or RDS (via security group whitelisting)** from your internal dev environment.

---

## Problem Statement
Your dev and testing teams need **stable outbound access to AWS EC2 and RDS** environments. But since **your TP-Link ER605 gets different public IPs every day from your three ISPs**, you constantly need to:

- Track the current public IPs of all three ISP links
- Identify which IP belongs to which ISP (Jio, Airtel, Sity)
- Update AWS security groups (for SSH and RDS) with these IPs daily

This is tedious and error-prone if done manually.

---

## Solution: Dynamic IP Hunter Script

This **Python script** automates the following:

- Fetches the **current public IP addresses** exposed by each WAN interface on the TP-Link ER605 (simulated by outbound calls)
- Performs **WHOIS lookups** to identify the associated ISP (Jio, Airtel, Sity)
- Outputs a clean, formatted list of **IP addresses and their ISPs**
- Can be integrated into an automation pipeline to **update AWS Security Groups**

---

## Use Case Scenario

- You have a **TP-Link ER605** load balancer with **3 ISP uplinks**.
- Each ISP assigns a **dynamic public IP** that may change daily.
- Your dev and QA teams need access to **EC2 (SSH) and RDS** resources.
- AWS security groups are configured to **whitelist these dynamic IPs**.
- This script finds the **latest IPs and their associated ISPs**, so you can:
  - Update EC2 security groups for SSH
  - Update RDS security groups for DB connections
- All done **automatically**, saving time and reducing errors.

---

## How It Works

1. Makes outbound connections (e.g., to `https://api.ipify.org`) via each WAN link (simulated or actual)
2. Captures **real-time public IPs** (no cached results)
3. Runs **WHOIS** queries to get ISP info
4. Outputs a table like:

   | IP Address     | ISP     |
   |----------------|---------|
   | 103.34.xx.xx   | Airtel  |
   | 49.205.xx.xx   | Jio     |
   | 122.167.xx.xx  | Sity    |

5. Can be extended to **push these IPs to AWS** using CLI/SDK

---

## Benefits

- Avoid paying for static IPs
- Eliminate manual daily updates to security groups
- Keep dev environment stable and connected
- Allow smooth testing of APIs, CRUD operations on RDS
- Reduce errors and downtime for the team

---

## Suggestions for Integration

- Run via `cron` daily (or on boot of dev server)
- Combine with **AWS CLI** commands like:
  ```bash
  aws ec2 authorize-security-group-ingress ...
