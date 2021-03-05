# terraform-gcp-gke-registry

The purpose of this repository is to test the Terraform Registry ```kubernetes-engine``` module to create a GKE Kubernetes cluster.

First, we've to create a ```terraform.tfvars``` to configure the ```region``` and ```project``` variables; otherwise, they're going to be required by Terraform throug STDIN when we execute **apply** command, for example.

Once the cluster has been created, we can get the credentials by executing the following ```gcloud``` command:

```
gcloud container clusters get-credentials $(terraform output module.gke.name) --zone $(terraform output module.gke.location)
```
