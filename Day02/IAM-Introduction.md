# IAM (Identity and Access Management)

AWS IAM (Identity and Access Management) is a service provided by Amazon Web Services (AWS) that helps you manage access to your AWS resources. It acts like a security system for your AWS account.

IAM allows you to create and manage **users**, **groups**, and **roles**:  

- **Users** represent individual people or entities who need access to your AWS resources.
- **Groups** are collections of users with similar access requirements, simplifying permission management.
- **Roles** grant temporary access to external entities or services.

IAM controls access through **policies**, which are JSON documents specifying allowed or denied actions on AWS resources. These policies are attached to users, groups, or roles to regulate permissions.

IAM follows the **principle of least privilege**, meaning users/entities receive only the permissions necessary for their tasks, minimizing security risks.

Additional features include:
- Multi-Factor Authentication (MFA) for added security.
- Audit trails to track user activity and permission changes.

By using AWS IAM, you can securely manage access, ensure only authorized actions are performed, and maintain accountability and compliance.

---

## Components of IAM

### Users
IAM users represent individual people or entities (such as applications or services) interacting with your AWS resources. Each user has a unique name and security credentials (password or access keys) for authentication and access control.

### Groups
IAM groups are collections of users with similar access requirements. Permissions are assigned to groups rather than individuals, simplifying management. Users can be added or removed from groups as needed.

### Roles
IAM roles provide temporary access to AWS resources. Typically used by applications or services accessing AWS on behalf of users or other services. Roles have associated policies defining permitted actions.

### Policies
IAM policies are JSON documents defining permissions. They specify:
- Which actions are allowed or denied.
- Which AWS resources these actions apply to.

Policies can be attached to users, groups, or roles to control access. AWS provides:
- **AWS Managed Policies:** Predefined policies maintained by AWS.
- **Customer Managed Policies:** Custom policies created and managed by you.
