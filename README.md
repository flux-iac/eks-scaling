# TF-controller demo: A self-managed EKS

This is a TF-controller example to demonstrate manually scaling of a EKS cluster.

### Initial seed the imported `TFSTATE`

The cluster was created by EKSctl. Then the `terraform import` command was used to partially extract the node group resource of the cluster. 
The node group definition was store here as a Terrform file.

```shell
terraform init
terraform import aws_eks_node_group.ng-cc5a1ac4 tf-controller:ng-cc5a1ac4
terraform show -no-color >> main.tf

# correct the nodegroup resource the main.tf file
terraform plan -out tfplan
```

If there's no change, prepare the initial tfstate secret using the following step.
```
gzip terraform.tfstate

NAME=tf-controller-ng-cc5a1ac4
kubectl create secret \
  generic tfstate-default-${NAME} \
  --from-file=tfstate=terraform.tfstate.gz \
  --dry-run=client -o=yaml \
  yq e '.metadata.annotations["encoding"]="gzip"' - > tfstate-default-${NAME}.yaml
  
kubectl apply -f tfstate-default-${NAME}.yaml
```

### Prepare an extra IAM Policy

Here's an extra IAM Policy, attached to a role, used by this example to demonstrate the IRSA support. Please note that the cluster name is `tf-controller`, so that the policy was scoped to only this cluster. Please change the account id and the cluster name to those of yours. 
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "eks:*",
            "Resource": [
                "arn:aws:eks:ap-southeast-1:<account id>:cluster/tf-controller",
                "arn:aws:eks:ap-southeast-1:<account id>:cluster/tf-controller/*",
                "arn:aws:eks:ap-southeast-1:<account id>:cluster/tf-controller/*/*",
                "arn:aws:eks:ap-southeast-1:<account id>:nodegroup/tf-controller/*/*"
            ]
        }
    ]
}
```

### Plan and Apply to manage itself

The cluster is now self-managable in a sense that we can change the number of its size via this Git repository.
TF-controller will plan and apply the change, and the number of the real nodes of this cluster will be adjusted accordingly.
