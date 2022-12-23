pipeline{
    agent any

	environment {
		DOCKERHUB_CREDENTIALS=credentials('dockerhublogin')
	}

	stages {
	    
	    stage('gitclone') {

			steps {
				git 'https://github.com/BharathSharath/cicd-for-webapp.git'
			}
		}

		stage('Build') {

			steps {
				sh 'docker build -t $JOB_NAME:v1.$BUILD_ID .'
				sh 'docker tag $JOB_NAME:v1.$BUILD_ID bharathsharath/$JOB_NAME:v1.$BUILD_ID'
				sh 'docker tag $JOB_NAME:v1.$BUILD_ID bharathsharath/$JOB_NAME:latest'
			}
		}

		stage('Login') {

			steps {
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}
		stage('Push') {

			steps {
				sh 'docker push bharathsharath/$JOB_NAME:v1.$BUILD_ID'
				sh 'docker push bharathsharath/$JOB_NAME:latest'
			}
		}
		stage('Delete images') {

			steps {
				sh ' docker rmi $JOB_NAME:v1.$BUILD_ID bharathsharath/$JOB_NAME:v1.$BUILD_ID bharathsharath/$JOB_NAME:latest'
			}
		}
           
    
        stage('Delete previous deployment ') {
            steps {
                sshagent(['k8s']) {
                sh "scp -o StrictHostKeyChecking=no dep-svc.yaml ubuntu@172.31.5.125:/home/ubuntu"
                script {
                      sh "ssh ubuntu@172.31.5.125 kubectl delete -f dep-svc.yaml"
                      sh "ssh ubuntu@172.31.5.125 sleep 10"
                    }
                }    
            }
        }
        stage('Delete old image on node') {
            steps {
                sshagent(['k8s']) {
                
                script {
                      
                      sh "ssh ubuntu@172.31.7.22 sudo docker rmi -f bharathsharath/project-1:latest"
                      
                      
                    }
                }
            }
        }
        stage('Deploy the updated one') {
            steps {
                sshagent(['k8s']) {
                
                script {
                      sh "ssh ubuntu@172.31.5.125 kubectl apply -f dep-svc.yaml"
                    }
                }    
            }
        }
    }
}
