# terraform-sandbox
Sandbox area for Terraform experimentation

Initial experimentation done using this tutorial at: [https://objectpartners.com/2016/06/01/automating-terraform-projects-with-jenkins/](https://objectpartners.com/2016/06/01/automating-terraform-projects-with-jenkins/).

### TODO

* simple TF script for VPC
  * within VPC
    * 2 subnets
    * few security groups
    * common rules for all groups
      * abstract out to make cleaner
    * few extra rules per group
  * maybe one s3 bucket?
    * test making sure bucket is deleted?
  * sample IAM policies
* makefiles/scripts for different environments
  * make two VPCs for starters
* protected branches
  * enable Jenkinsfile to work with different branches as well
* document extra plugins necessary for Jenkinsfile
  * AnsiColor
  * Custom Tools Plugin
