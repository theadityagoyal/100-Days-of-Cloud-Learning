# Day 2 – AWS IAM (Identity & Access Management) Setup

Today, I worked on setting up AWS IAM to control access to AWS services securely and efficiently. IAM is the backbone of AWS security and identity management. The goal was to understand how to manage users, groups, roles, and permissions effectively using IAM.

---

## Objective

- Create IAM Users and Groups
- Attach fine-grained Policies
- Use IAM Roles for EC2 and App Runner
- Enable secure S3, EC2, RDS, App Runner access
- Simulate access errors due to missing permissions

---

## Hands-on Implementation

### 1. Created IAM Users

```text
| Username         | Access Type         | Description                |
|------------------|---------------------|----------------------------|
| dev-user         | Console + CLI       | Developer access           |
| automation-user  | Programmatic (CLI)  | CI/CD or Lambda automation |
```

---

### 2. Created IAM Groups and Attached Policies

```text
| Group Name       | Policies Attached                           |
|------------------|---------------------------------------------|
| DevelopersGroup  | AmazonEC2ReadOnlyAccess, AmazonS3FullAccess |
| AdminsGroup      | AdministratorAccess                         |
```

- Assigned `dev-user` to `DevelopersGroup`
- `automation-user` is without group for testing inline policies

---

### 3. IAM Roles for Services

#### EC2 Role (ec2-s3-access-role)

```json
{
  "Effect": "Allow",
  "Action": ["s3:*"],
  "Resource": "*"
}
```
- Assigned this role to EC2 instances at launch.

#### App Runner Role (app-runner-access-role)

```json
{
  "Effect": "Allow",
  "Action": ["s3:GetObject", "rds:DescribeDBInstances"],
  "Resource": "*"
}
```
- Used for accessing S3 and RDS in App Runner

Also configured **SSM Parameter Store** access for App Runner by attaching role-based permission:

```json
{
  "Effect": "Allow",
  "Action": [
    "ssm:GetParameter",
    "ssm:GetParameters",
    "ssm:GetParametersByPath"
  ],
  "Resource": "*"
}
```
- However, mistakenly provided access using **IAM user policy** instead of attaching to the **App Runner role**, which resulted in temporary failure to fetch secure parameters.

---

## Simulated Errors (Real IAM Issues Faced)

### Error 1 – S3 Access Denied

```bash
aws s3 ls s3://my-bucket-name

# Error:
An error occurred (AccessDenied) when calling the ListObjectsV2 operation: Access Denied
```

**Fix:** Created and attached inline policy to `automation-user`:

```json
{
  "Effect": "Allow",
  "Action": ["s3:*"],
  "Resource": "*"
}
```

---

### Error 2 – EC2 Start Instance Denied

```text
"You are not authorized to perform this operation. Please contact your administrator."
```

**Fix:** Attached `AmazonEC2FullAccess` temporarily to `DevelopersGroup`, later replaced with scoped policy:

```json
{
  "Effect": "Allow",
  "Action": ["ec2:StartInstances", "ec2:StopInstances"],
  "Resource": "*"
}
```

---

### Error 3 – RDS Describe Access Denied in App Runner

```text
"rds:DescribeDBInstances not authorized for assumed role"
```

**Fix:** Modified App Runner role to include RDS permission:

```json
{
  "Effect": "Allow",
  "Action": ["rds:DescribeDBInstances"],
  "Resource": "*"
}
```

---

## Best Practices Followed

- Principle of Least Privilege
- Enabled MFA on IAM users
- Used IAM roles for EC2 and App Runner instead of hardcoded credentials

---

## Summary

IAM is a fundamental AWS service for secure and manageable access control. Today, I experienced real permission errors due to missing policies and learned how to adjust roles and policies to fix these issues effectively.
