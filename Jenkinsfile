//
// copied from https://objectpartners.com/2016/06/01/automating-terraform-projects-with-jenkins/
//

// TODO: AWS credentials currently in Jenkins config, improve that, also means init.sh needs to
//       be run with correct credentials as well

node {
 
  stage ('Checkout') {
    // TODO: // need to have workspaces per branch built, repo will be specified in jenkins job
    //       need to have this script/workflow worked on different branches
    // TODO: also determine how Jenkins generates this ID, seems fragile to have it
    // checked in
    git url: 'git@github.com:jessedavis/terraform-sandbox.git', credentialsId: '4c31906d-75ad-4a83-a7f7-e22929f431ed'
  }

  // TODO: only copy in current environment credentials, or better, source
  stage ('Copy Credentials') {
    sh "cp /data/jenkins/* ./creds"
  }

  // Get the Terraform tool.
  def tfHome = tool name: 'Terraform', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
  env.PATH = "${tfHome}:${env.PATH}"
  wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'XTerm']) {
 
    // Mark the code build 'plan'....
    stage name: 'Plan', concurrency: 1
    // Output Terraform version
    sh "terraform --version"

    // TODO: determine environment from job
    dir ("./envs/dev") {

      //Remove the terraform state file so we always start from a clean state
      if (fileExists(".terraform/terraform.tfstate")) {
        sh "rm -rf .terraform/terraform.tfstate"
      }
      if (fileExists("status")) {
        sh "rm status"
      }
      sh "./init.sh"
      sh "terraform get"
      sh "set +e; terraform plan -out=plan.out -detailed-exitcode; echo \$? &gt; status"
      def exitCode = readFile('status').trim()
      def apply = false
      echo "Terraform Plan Exit Code: ${exitCode}"
      if (exitCode == "0") {
        currentBuild.result = 'SUCCESS'
      }
      if (exitCode == "1") {
        //slackSend channel: '#ci', color: '#0080ff', message: "Plan Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
        currentBuild.result = 'FAILURE'
      }
      if (exitCode == "2") {
        stash name: "plan", includes: "plan.out"
        //slackSend channel: '#ci', color: 'good', message: "Plan Awaiting Approval: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
        try {
          input message: 'Apply Plan?', ok: 'Apply'
          apply = true
        } catch (err) {
          //slackSend channel: '#ci', color: 'warning', message: "Plan Discarded: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
          apply = false
          currentBuild.result = 'UNSTABLE'
        }
      }

      if (apply) {
        stage name: 'Apply', concurrency: 1
        unstash 'plan'
        if (fileExists("status.apply")) {
          sh "rm status.apply"
        }
        sh 'set +e; terraform apply plan.out; echo \$? &amp;gt; status.apply'
        def applyExitCode = readFile('status.apply').trim()
        if (applyExitCode == "0") {
          //slackSend channel: '#ci', color: 'good', message: "Changes Applied ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"    
         } else {
           //slackSend channel: '#ci', color: 'danger', message: "Apply Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
           currentBuild.result = 'FAILURE'
         }
       }
    }
  }
}
