pipeline {
    agent any
    parameters {
  credentials credentialType: 'com.cloudbees.jenkins.plugins.awscredentials.AWSCredentialsImpl', defaultValue: '3bc3c0e2-3081-41ef-92ad-09195816a3f7', name: 'AWS_CREDS', required: false
}
    environment {
        PATH = "${PATH}:${getTerraformPath()}:${getAnsiblePath()}"
    }
    stages{

         stage('Initial Deployment Approval') {
              steps {
                script {
                def userInput = input(id: 'confirm', message: 'Start Pipeline?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Start Pipeline', name: 'confirm'] ])
             }
           }
        }

         stage('terraform init'){
             steps {
                 //sh "returnStatus: true, script: 'terraform workspace new dev'"
                 sh "terraform init"
                 
         }
         }
         stage('terraform plan'){
             steps {
                 //sh "returnStatus: true, script: 'terraform workspace new dev'"
                 //sh "terraform apply -auto-approve"
                 sh "terraform plan -out=tfplan -input=false"
             }
         }
        stage('Final Deployment Approval') {
              steps {
                script {
                def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
             }
           }
        }
         stage('Terraform Apply'){
             steps {
                 //sh "returnStatus: true, script: 'terraform workspace new dev'"
                 //sh "terraform apply -auto-approve"
                //  sh "terraform destroy -input=false -auto-approve"
                 sh "terraform apply  -input=false tfplan"
             }
         }
        
         stage('Build Ansible Inventory List For Post Configuration'){
             steps {
                 sh "aws ec2 describe-instances --query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress}" --filters  "Name=instance-state-name, Values=running" "Name=tag:Name, Values='CliXX-ASG'" --output text > /home/ec2-user/server_inventory_list"
             }
         }
          
    }
}
 def getTerraformPath(){
        def tfHome= tool name: 'terraform-14', type: 'terraform'
        return tfHome
    }

 def getAnsiblePath(){
        def AnsibleHome= tool name: 'Ansible', type: 'org.jenkinsci.plugins.ansible.AnsibleInstallation'
        return AnsibleHome
    }