pipeline {
    agent any

    environment {
        PATH = "${PATH}:${getTerraformPath()}"
    }
    stages{
         stage('terraform init'){

             environment{
                 AWS_ACCESS_KEY_ID= credentials('ACCESS_KEY_ID')
                 AWS_SECRET_ACCESS_KEY= credentials('SECRET_KEY')
             }
             steps {
                 //sh "returnStatus: true, script: 'terraform workspace new dev'"
                 //change
                 slackSend (color: '#FFFF00', message: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")

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
                 sh "terraform destroy -input=false -auto-approve"
                //sh "terraform apply  -input=false tfplan"
                
             }
         }

          
    }
}
 def getTerraformPath(){
        def tfHome= tool name: 'terraform-14', type: 'terraform'
        return tfHome
    }
