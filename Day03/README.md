# Dynamic IP Hunter — Automating IP Tracking for Dynamic Load Balancers

## Overview

In many cost-conscious companies, public IP addresses for critical infrastructure such as AWS load balancers are often dynamic rather than static. This is typically done to save costs, but it introduces a daily operational challenge: the public IPs assigned by different ISPs keep changing.

Imagine you have a load balancer connected to three ISP networks (for example, Jio, Airtel, and Sity). Each ISP assigns dynamic public IPs that can change daily. Meanwhile, your development environment relies on these IPs for SSH access to EC2 instances and connections to RDS databases. Since the IPs change regularly, you need to update your access control lists, security groups, or other configurations daily to keep everything running smoothly.

## Problem Statement

Googling *"What’s my IP?"* might seem easy — but here’s the real issue:

- Many sites don’t give accurate results instantly
- Sometimes they show cached IPs or your load balancer’s IP
- And you can’t go around pinging every laptop manually

This script solves that by continuously fetching fresh, real public IPs (until it gets unique ones).  
It’s especially useful in dynamic or load-balanced environments.

By default, it finds 3 IPs — but you can modify it as per your needs.  
Just fork the repo or download and tweak it your way 

## What This Script Does

This Python script automates the process of:

- Detecting the current public IP addresses used by your load balancer’s ISPs.
- Performing WHOIS lookups to identify the owner or ISP associated with each IP.
- Presenting a clean, easy-to-use list of current IPs and their respective owners.

With this information, you can automate updates to your SSH access control, RDS security groups, and other AWS services that rely on IP whitelisting — eliminating manual daily updates and preventing service interruptions.

## Use Case Scenario

- Your load balancer distributes traffic across three ISP connections, each with a dynamic public IP.
- Every day, these public IPs can change unpredictably due to the lack of static IPs (to save costs).
- Your dev environment requires SSH and RDS access restricted to these IPs.
- Manually tracking and updating IPs is time-consuming and error-prone.
- Running this script quickly provides the current IP addresses and their ISPs.
- You feed these IPs into your security groups or firewall rules automatically.
- SSH and RDS connections remain stable without manual troubleshooting.

The script will simulate scanning “dark web nodes” (just for fun), fetch your public IPs, perform WHOIS queries, and print a table of IP addresses along with their ISP owners.

## Benefits

- Avoid paying extra for static IPs by managing dynamic IPs efficiently.
- Reduce manual errors and save time in daily environment maintenance.
- Improve operational reliability of your development environment.
- Use as a foundational tool to integrate into automation pipelines for continuous updates.

## Suggestions for Integration

- Schedule this script to run periodically (e.g., daily via cron).
- Combine output with AWS CLI or SDK scripts to update security groups automatically.
- Extend ISP detection rules for your specific network providers.
- Use as a troubleshooting tool to quickly verify current public IPs used by your infrastructure.

## How to Run

Simply execute:

```bash
python3 dynamic_ip_hunter.py
