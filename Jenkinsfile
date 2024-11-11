pipeline{
    agent{
        node{
            label "Slave-1"
            customWorkspace "/home/jenkins/mydemo"
        }
    }
    environment{
        JAVA_HOME="/usr/lib/jvm/java-17-amazon-corretto.x86_64"
        PATH="$PATH:$JAVA_HOME/bin"
    }
    parameters {
        string(name: 'COMMIT_ID', defaultValue: '', description: 'Provide the Commit ID')
        string(name: 'REPO_NAME', defaultValue: '', description: 'Provide ECR Repository URI')
        string(name: 'TAG_NAME', defaultValue: '', description: 'Provide a tag name for Docker Image')
        string(name: 'REPLICA_COUNT', defaultValue: '', description: 'Provide the number of Pods to be created')
    }
    stages{
        stage("clone-code"){
            steps{
                cleanWs()
                checkout scmGit(branches: [[name: "${COMMIT_ID}"]], extensions: [], userRemoteConfigs: [[credentialsId: 'github-cred', url: 'https://github.com/singhritesh85/DevSecOps-Project.git']])
            }
        }
        stage("SonarAnalysis"){
            steps {
                withSonarQubeEnv('SonarQube-Server') {
                    sh 'sonar-scanner -Dsonar.projectKey=netflix-clone -Dsonar.projectName=netflix-clone'
                }
            }
        }
        stage("Quality Gate") {
            steps {
              timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
        }
        stage("Install Dependencies"){
            steps {
                sh 'npm install'
            }
        }
        stage("OWASP Dependency Check"){
            steps{
                sh 'dependency-check.sh --disableYarnAudit --disableNodeAudit --scan . --out .'
            }
        }
        stage("Trivy Scan files"){
            steps{
                sh 'trivy fs . > /home/jenkins/trivy-filescan.txt'
            }
        }
        stage("Docker-Image"){
            steps{
                sh 'docker build --build-arg TMDB_V3_API_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -t myimage:1.06 . --no-cache'
                sh 'docker tag myimage:1.06 ${REPO_NAME}:${TAG_NAME}'
                sh 'trivy image --exit-code 0 --severity MEDIUM,HIGH ${REPO_NAME}:${TAG_NAME}'
                sh 'aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 027330342406.dkr.ecr.us-east-2.amazonaws.com'
                sh 'docker push ${REPO_NAME}:${TAG_NAME}'
            }
        }
        stage("Deployment"){
            steps{
                //sh 'yes|argocd login argocd.singhritesh85.com --username admin --password Admin@123'
                sh 'argocd login argocd.singhritesh85.com --username admin --password Admin@123 --skip-test-tls  --grpc-web'
                sh 'argocd app create netflix-clone --project default --repo https://github.com/singhritesh85/helm-repo-for-netflix-clone.git --path ./folo --dest-namespace netflix --dest-server https://kubernetes.default.svc --helm-set service.port=80 --helm-set image.repository=${REPO_NAME} --helm-set image.tag=${TAG_NAME} --helm-set replicaCount=${REPLICA_COUNT} --upsert'
                sh 'argocd app sync netflix-clone'
            }
        }
    }
    post {
        always {
            mail bcc: '', body: "A Jenkins Job with Job Name ${env.JOB_NAME} has been executed", cc: '', from: '', replyTo: '', subject: "Jenkins Job ${env.JOB_NAME} has been executed", to: 'abc@gmail.com'
        }
        success {
            mail bcc: '', body: "A Jenkins Job with Job Name ${env.JOB_NAME} and Build Number=${env.BUILD_NUMBER} has been executed Successfully, Please Open the URL ${env.BUILD_URL} and click on Console Output to see the Log. The Result of execution is ${currentBuild.currentResult}", cc: '', from: '', replyTo: '', subject: "Jenkins Job ${env.JOB_NAME} has been Sucessfully Executed", to: 'abc@gmail.com'
        }
        failure {
            mail bcc: '', body: "A Jenkins Job with Job Name ${env.JOB_NAME} and Build Number=${env.BUILD_NUMBER} has been Failed, Please Open the URL ${env.BUILD_URL} and click on Console Output to see the Log. The Result of execution is ${currentBuild.currentResult}", cc: '', from: '', replyTo: '', subject: "Jenkins Job ${env.JOB_NAME} has been Failed", to: 'abc@gmail.com'
        }
    }    
}
