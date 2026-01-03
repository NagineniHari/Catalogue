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
        ACCOUNT_ID = "996058207546"
        PROJECT = "safety"
        COMPONENT = "catalogue"
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
        stage('Install Dependencies') {
            steps {
                script { 
                sh  """
                 npm install 

                 """
                }
            }
        }

        stage('Unit Test') {
            steps {
                script { 
                sh  """
                 npm test

                 """
                }
            }
        }
        //Here you need to select scanner tool and send the analysis to server
        stage('sonar scans') {
            environment {
                def scannerHome = tool 'sonar-8.0'
            }
        steps {
            script {
                withSonarQubeEnv('sonar-server') {
                sh "${scannerHome}/bin/sonar-scanner"
        }
        }
        }
        }
        stage('Quality Gate Check') {
            
            steps {
                timeout(time: 1, unit: 'HoURS') {
                // Pauses the pipeline and waits for the analysis to be completed and quality gate status to be returned
                  def qg = waitForQualityGate abortPipeline: true // Aborts the pipeline if the Quality Gate fails (e.g., "red" status)
            }
        }
        }
        stage('Docker Image Build') {
          steps {
                script { 
withAWS(region:'us-east-1',credentials:'aws-creds') {
  sh """
  aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com
  docker build -t ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion} .
  docker images
  docker push ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion}
"""
}
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

