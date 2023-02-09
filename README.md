# Hosting simple websites on containers in EC2 using Terraform, Ansible
## Task
Create Terraform configuration file that creates 2 EC2 instances.

Using Ansible: 
- Install Docker on all instances
- Run nginx containers with instance ip output on websites


## How to run
Clone repository to your computer
```
git clone https://github.com/DanyaCt/AnsibleTerraform
```
Also you need to download Terraform and AWS CLI, you can use these links:

>Terraform: https://developer.hashicorp.com/terraform/downloads
>
>AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

Next you must login to your account in AWS, guide for this:
>https://docs.aws.amazon.com/cli/latest/reference/configure/

You will also need to create a key pair in AWS, guide for this:

>https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html

Then you must change my key to your own in code (line 17)

Run these commands:
```
terraform init
terraform apply -auto-approve
```
Now you can check your websites using output from Terraform, just paste that in your browser!
