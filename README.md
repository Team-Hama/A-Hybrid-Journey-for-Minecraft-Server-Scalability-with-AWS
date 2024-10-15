# Terraform execution order

```
.
├── versions.tf
├── data.tf
├── local.tf
├── variables.tf
├── aws-ssm.tf
├── vpc.tf
├── eks_cluster.tf
├── iam.tf
└── outputs.tf 
```

For ease of use, we are using the local state file here. In production, you 
must use remote state such as `AWS S3` to store the `.state` files and 
`AWS DynamoDB` for lock files.

