pipeline {
    agent any

    environment {
        IMAGE_NAME = "python-app"
        CONTAINER_NAME = "python-app-container"
        PATH = "/usr/local/bin:/usr/bin:/bin"
    }

    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

     stage('Login to Docker Hub') {
        steps {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', 
                                          usernameVariable: 'DOCKER_USER', 
                                          passwordVariable: 'DOCKER_PASS')]) {
            sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
        }
    }
}
		stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:3.11-slim ."
                }
            }
        }


        stage('Run Container') {
            steps {
                script {
                    // Stop and remove old container if exists
                    sh """
                    if [ \$(docker ps -aq -f name=${CONTAINER_NAME}) ]; then
                        echo "Removing old container..."
                        docker rm -f ${CONTAINER_NAME} || true
                    fi

		    """
           
                    // Run new container
                    sh "docker run --name ${CONTAINER_NAME} -d ${IMAGE_NAME}:3.11-slim"
                }
            }
        }

        stage('Wait and Check') {
            steps {
                script {
                    sleep 20   //tells jenkins to wait to let container to run with it's image

                    def containerStatus = sh( 
                        script: "docker ps -q -f name=${CONTAINER_NAME}",
                        returnStdout: true   
	            ).trim() //removes spaces from results
		   
                   //Runs shell commands in jenkins and shows only the container we filtered "-q" shows only cont ID "-f" filters container

                    if (containerStatus) {
                        echo "Container is still running after 20s. Test Failed."
                        sh "docker rm -f ${CONTAINER_NAME}"
                    } else {
                        echo "Container finished. Test Success."
                    }
                }
            }
        }
    }

    post {
        always {
            sh "docker ps -a"
        }
    }
}
    
