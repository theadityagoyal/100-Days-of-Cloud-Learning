#!/bin/bash

# ========== CONFIGURATION ==========
DEFAULT_REGION="ap-south-1"
IAM_REGION="us-east-1"

# Change dates yahan se karo (IST based)
START_DATE="2025-04-15"
END_DATE="2025-04-16"

START_TIME=$(date -u -d "$START_DATE 00:00:00" +"%Y-%m-%dT%H:%M:%SZ")
END_TIME=$(date -u -d "$END_DATE 23:59:59" +"%Y-%m-%dT%H:%M:%SZ")

# ========== SERVICE EVENTS ==========
declare -A SERVICE_EVENTS=(

  # Identity & Access
  [IAM]="CreateUser DeleteUser AttachUserPolicy DetachUserPolicy CreateRole UpdateRole AttachRolePolicy DetachRolePolicy PutRolePolicy"
  [KMS]="CreateKey DisableKey ScheduleKeyDeletion CancelKeyDeletion"
  [SecretsManager]="CreateSecret DeleteSecret UpdateSecret PutSecretValue RotateSecret RestoreSecret"
  [SSM_ParameterStore]="PutParameter DeleteParameter"

  # Compute
  [EC2]="StartInstances StopInstances TerminateInstances RebootInstances CreateVolume DeleteVolume AttachVolume DetachVolume"
  [ECS]="CreateService DeleteService UpdateService RunTask StopTask"
  [Lambda]="CreateFunction DeleteFunction UpdateFunctionCode Invoke"

  # Networking
  [VPC]="CreateVpc DeleteVpc CreateSubnet DeleteSubnet AssociateRouteTable DisassociateRouteTable CreateInternetGateway DeleteInternetGateway"
  [SECURITY_GROUP]="AuthorizeSecurityGroupIngress RevokeSecurityGroupIngress AuthorizeSecurityGroupEgress RevokeSecurityGroupEgress CreateSecurityGroup DeleteSecurityGroup"

  # Storage
  [S3]="CreateBucket DeleteBucket PutBucketPolicy DeleteBucketPolicy PutObject DeleteObject"
  [EBS]="CreateSnapshot DeleteSnapshot"

  # Database
  [RDS]="CreateDBInstance DeleteDBInstance ModifyDBInstance CreateDBCluster DeleteDBCluster ModifyDBCluster"
  [DynamoDB]="CreateTable DeleteTable UpdateTable"

  # DevOps
  [APP_RUNNER]="CreateService UpdateService DeleteService StartDeployment PauseService ResumeService"
  [CloudFormation]="CreateStack UpdateStack DeleteStack"
  [CloudWatch]="PutMetricAlarm DeleteAlarms"
  [CloudTrail]="CreateTrail DeleteTrail UpdateTrail StartLogging StopLogging"

  # Messaging
  [SNS]="CreateTopic DeleteTopic Subscribe Unsubscribe Publish"

  # Management
  [Billing]="CreateBudget ModifyBudget DeleteBudget"
  [SSM]="SendCommand CancelCommand CreateAssociation DeleteAssociation UpdateAssociation"
  [SessionManager]="StartSession TerminateSession ResumeSession"
)

# ========== EXECUTION ==========
echo -e "\n\033[1;36mFetching AWS CloudTrail events from $START_TIME to $END_TIME\033[0m\n"

for service in "${!SERVICE_EVENTS[@]}"; do
  if [[ "$service" == "IAM" || "$service" == "Billing" ]]; then
    REGION=$IAM_REGION
  else
    REGION=$DEFAULT_REGION
  fi

  echo -e "\033[1;33m=============================================="
  echo "Events for $service (Region: $REGION)"
  echo -e "==============================================\033[0m"
  
  IFS=' ' read -r -a events_array <<< "${SERVICE_EVENTS[$service]}"

  for event_name in "${events_array[@]}"; do
    echo -e "\n\033[1;34mEvent: $event_name\033[0m"

    aws cloudtrail lookup-events \
      --region "$REGION" \
      --start-time "$START_TIME" \
      --end-time "$END_TIME" \
      --lookup-attributes AttributeKey=EventName,AttributeValue="$event_name" \
      --query 'Events[*].{EventTime:EventTime, Username:Username, Resource:Resources[0].ResourceName, Source:EventSource, EventId:EventId}' \
      --output table
  done
done
