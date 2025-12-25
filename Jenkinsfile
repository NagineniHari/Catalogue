pipeline {
    // This steps are Pre-build sections
    agent {
    node {
        label "AGENT-1"
    }
    }
    environment {
        COURSE="Jenkins"
        appVersion= ""
    }
        options {
        timeout(time: 15, unit: 'MINUTES') 
        disableConcurrentBuilds()
    }
   // This is build section part
    stages {
        stage('Read Version') {
            steps {
                script { 
                def packageJSON = readJSON file: 'package.json'
                appVersion=packageJSON.version
                echo "app version: ${appVersion}"
                }
            }
        }
        stage('Stage') {
            steps {
                
                script { 

                sh  """
                 echo "Staging"
                    """
                }
            }
        }
                stage('Test') {
            steps {
                
                script { 

                sh  """
                 echo "Testiing"
                 env

                    """
                }
            }
        }
        // approvals added 
        stage('Deploy') {
            // input {
            //     message "Should we continue?"
            //     ok "Yes, we should."
            //     submitter "alice,bob"
            //     parameters {
            //         string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
            //     }
            // }
          when {
           expression { "$params.DEPLOY" =="true"}
          }

            steps {
                echo "Deploying"
            }
        }
    }

    post{
        always{
            echo 'I will always say Hello again!'
            cleanWs()
        }
        success {
            echo 'I will run if  success !'
        }

        failure {
            echo 'I will run if failure !'
        }
        aborted {
           echo 'Pipeline is aborted executing more time'
        }
    }
}

