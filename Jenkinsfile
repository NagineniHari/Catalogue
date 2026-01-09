pipeline {
    agent {
        node {
            label "AGENT-1"
        }
    }

    environment {
        COURSE      = "Jenkins"
        appVersion  = ""
        ACCOUNT_ID  = "996058207546"
        PROJECT     = "safety"
        COMPONENT   = "catalogue"
    }

    options {
        timeout(time: 15, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    stages {

        stage('Read Version') {
            steps {
                script {
                    def packageJSON = readJSON file: 'package.json'
                    appVersion = packageJSON.version
                    echo "App Version: ${appVersion}"
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Unit Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Sonar Scan') {
            steps {
                script {
                    def scannerHome = tool 'sonar-8.0'
                    withSonarQubeEnv('sonar-server') {
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }

        stage('Quality Gate Check') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    script {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }

        stage('Dependabot Security Gate') {
            environment {
                GITHUB_OWNER = 'NagineniHari'
                GITHUB_REPO  = 'Catalogue'
                GITHUB_API   = 'https://api.github.com'
                GITHUB_TOKEN = credentials('GITHUB_TOKEN')
            }

            steps {
                sh '''
                echo "Fetching Dependabot alerts..."

                response=$(curl -s \
                    -H "Authorization: token ${GITHUB_TOKEN}" \
                    -H "Accept: application/vnd.github+json" \
                    "${GITHUB_API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/dependabot/alerts?per_page=100")

                echo "${response}" > dependabot_alerts.json

                high_critical_open_count=$(echo "${response}" | jq '[.[] 
                    | select(
                        .state == "open" and
                        (.security_advisory.severity == "high" or
                         .security_advisory.severity == "critical")
                    )
                ] | length')

                echo "Open HIGH/CRITICAL alerts: ${high_critical_open_count}"

                if [ "${high_critical_open_count}" -gt 0 ]; then
                    echo "❌ Blocking pipeline due to security vulnerabilities"
                    exit 1
                else
                    echo "✅ No HIGH/CRITICAL vulnerabilities found"
                fi
                '''
            }
        }

        stage('Docker Image Build & Push') {
            steps {
                script {
                    withAWS(region: 'us-east-1', credentials: 'aws-creds') {
                        sh """
                        aws ecr get-login-password --region us-east-1 \
                        | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com

                        docker build -t ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion} .
                        docker push ${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion}
                        """
                    }
                }
            }
        }

        stage('Test') {
            steps {
                sh '''
                echo "Testing environment variables"
                env
                '''
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed'
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded ✅'
        }
        failure {
            echo 'Pipeline failed ❌'
        }
        aborted {
            echo 'Pipeline aborted ⛔'
        }
    }
}
