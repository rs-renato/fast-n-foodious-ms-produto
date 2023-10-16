# TODOs

# Must

# Should
* create role for ecs task execution: ecsTaskExecutionRole
  * that role needs the permission CloudWatchLogsFullAccess (or at least logs:CreateLogGroup) 
* create ECR repo fast-n-foodious

# Could
* when creating the role ecsTaskExecutionRole, avoid giving all CloudWatch permissions
  * will require investigation of the minimum permissions required for the role

# Would

# Won't
