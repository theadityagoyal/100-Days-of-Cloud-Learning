# AWS CloudTrail Activity Logger (Day 4)

## Problem Statement

In a shared AWS environment, identifying **who did what and when** is critical for accountability and security.

For example, during one incident in our team, an EC2 instance used for testing was unexpectedly terminated. The blame game started — everyone was trying to figure out who did it, and whether it was intentional or accidental. Since multiple users had access, and there was **no easy way to check activity logs quickly**, I had to log in to the AWS Console, navigate to CloudTrail, filter through several events manually, and match timestamps. This process was **time-consuming, inefficient, and error-prone**.

This wasn’t just a one-time situation. Almost daily, I needed to check:
- Who started or stopped EC2 instances?
- Was a user or IAM role changed?
- Did someone modify an S3 bucket or delete a secret?

## Solution

To address this recurring problem, I built an automation script using AWS CLI and Bash, named `cloudtrail.sh`.

This script allows me to:

- Instantly fetch **CloudTrail logs** for a specific date range
- Filter actions by **event names** like `StartInstances`, `DeleteUser`, `PutObject`, etc.
- Check across **multiple services** (EC2, IAM, S3, RDS, Lambda, etc.)
- Automatically handle **region differences** (IAM in `us-east-1`, rest in `ap-south-1`)
- Output a **clean, tabular format** that clearly shows:
  - Who did the action (Username)
  - What action was performed (EventName)
  - When it happened (EventTime)
  - On which resource (ResourceName)
  - From which AWS service (EventSource)

This turns what used to be a 15-30 minute manual console process into a **1-minute terminal command**.

## Benefits

- **Improved visibility:** See exactly who performed what operation and when.
- **Faster investigations:** Pinpoint issues like unintentional deletions or configuration changes.
- **Accountability:** Helps assign responsibility and reduce confusion in team environments.
- **Audit readiness:** Useful during internal audits, security checks, or billing investigations.

## Example Use Case

Let’s say you run this script for April 15th to April 16th:

```bash
bash cloudtrail.sh
```

You get a detailed table like:

```
+----------------------+----------------------+---------------------------+---------------------------+------------------------------+
|      EventTime       |       Username       |         Resource          |         Source            |           EventId           |
+----------------------+----------------------+---------------------------+---------------------------+------------------------------+
| 2025-04-15T07:33:25Z | john.doe             | i-0abc123456def7890       | ec2.amazonaws.com         | abcdefgh-1234-5678-9012-...  |
| 2025-04-15T08:00:00Z | admin-user           | test-instance             | ec2.amazonaws.com         | zyxwvuts-8765-4321-0987-...  |
+----------------------+----------------------+---------------------------+---------------------------+------------------------------+
```

You can immediately tell who terminated an instance or updated an IAM policy — all without logging into the AWS Console.

---

## How to Use

1. Make sure your AWS CLI is configured with permissions to access CloudTrail logs.
2. Clone or download this repository.
3. Open `cloudtrail.sh` and adjust the `START_DATE` and `END_DATE` variables as needed.
4. Run the script:

```bash
bash cloudtrail.sh
```

---

## Supported Services & Events

This script supports key AWS services and event types, including:

- **IAM:** `CreateUser`, `DeleteUser`, `AttachRolePolicy`, etc.
- **EC2:** `StartInstances`, `StopInstances`, `TerminateInstances`
- **S3:** `PutObject`, `DeleteObject`, `CreateBucket`, `DeleteBucket`
- **Others:** RDS, Lambda, Secrets Manager, KMS, VPC, and more

You can easily expand or customize the monitored actions by editing the `SERVICE_EVENTS` section inside the script.
