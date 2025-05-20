pipeline {
    agent {
        node {
            label 'master'
        }
    }
    
    environment {
        DOCKER_NETWORK = 'traefik-public'
        BRANCH_NAME = "${env.BRANCH_NAME}"
    }
    
    stages {
        stage('Select Environment') {
            agent {
                node {
                    label 'master'
                }
            }
            steps {
                script {
                    env.BRANCH = env.BRANCH_NAME
                    
                    if (env.BRANCH == 'prod') {
                        env.NODE_LABEL = 'apis'
                        env.VAULT_PATH = 'rest-prod'
                    } else if (env.BRANCH == 'canary') {
                        env.NODE_LABEL = 'canary'
                        env.VAULT_PATH = 'rest-canary'
                    } else if (env.BRANCH == 'cron-prod') {
                        env.NODE_LABEL = 'apis'
                        env.VAULT_PATH = 'rest-prod'
                    } else {
                        env.NODE_LABEL = 'dev'
                        env.VAULT_PATH = 'aqary-dev'
                    }
                    
                    echo "Selected environment: ${env.BRANCH}"
                    echo "Using node: ${env.NODE_LABEL}"
                    echo "Using vault path: ${env.VAULT_PATH}"
                }
            }
        }
        
        stage('Checkout') {
            agent {
                node {
                    label "${env.NODE_LABEL}"
                }
            }
            steps {
                checkout scm
            }
        }
        
        stage('Create Environment File') {
            agent {
                node {
                    label "${env.NODE_LABEL}"
                }
            }
            steps {
                script {
                    withVault(
                        configuration: [
                            timeout: 60,
                            vaultCredentialId: 'vault-approle',
                            vaultUrl: 'https://vault-cluster-public-vault-95e293ab.6cf721ff.z1.hashicorp.cloud:8200',
                            engineVersion: 2,
                        ],
                        vaultSecrets: [
                            [
                                path: "secret/${env.VAULT_PATH}/aqary-backend",
                                secretValues: [
                                    [envVar: 'AZURE_STORAGE_CONNECTION_STRING', vaultKey: 'AZURE_STORAGE_CONNECTION_STRING'],
                                    [envVar: 'DB_NAME', vaultKey: 'DB_NAME'],
                                    [envVar: 'POSTGRES_USER', vaultKey: 'POSTGRES_USER'],
                                    [envVar: 'DB_PASSWORD', vaultKey: 'DB_PASSWORD'],
                                    [envVar: 'DOCKER_DB_ADDRESS', vaultKey: 'DOCKER_DB_ADDRESS'],
                                    [envVar: 'ENVIRONMENT', vaultKey: 'ENVIRONMENT'],
                                    [envVar: 'REDIS_URL', vaultKey: 'REDIS_URL'],
                                    [envVar: 'REDIS_PORT', vaultKey: 'REDIS_PORT'],
                                    [envVar: 'REDIS_PASSWORD', vaultKey: 'REDIS_PASSWORD'],
                                    [envVar: 'REDIS_DB', vaultKey: 'REDIS_DB'],
                                    [envVar: 'REDIS_HOST', vaultKey: 'REDIS_HOST'],
                                    [envVar: 'HISTORY_SERVICE_API_TOKEN', vaultKey: 'HISTORY_SERVICE_API_TOKEN'],
                                    [envVar: 'RABBITMQ_ADDRESS', vaultKey: 'RABBITMQ_ADDRESS'],
                                    [envVar: 'HISTORY_REPO_BASE_URL', vaultKey: 'HISTORY_REPO_BASE_URL'],
                                    [envVar: 'CRON_PORT', vaultKey: 'CRON_PORT'],
                                    [envVar: 'APPLE_TEAM_ID_INVESTMENT', vaultKey: 'APPLE_TEAM_ID_INVESTMENT'],
                                    [envVar: 'APPLE_CLIENT_ID_INVESTMENT', vaultKey: 'APPLE_CLIENT_ID_INVESTMENT'],
                                    [envVar: 'APPLE_KEY_ID_INVESTMENT', vaultKey: 'APPLE_KEY_ID_INVESTMENT'],
                                    [envVar: 'APPLE_PRIVATE_KEY_INVESTMENT', vaultKey: 'APPLE_PRIVATE_KEY_INVESTMENT']
                                ]
                            ]
                        ]
                    ) {
                        sh '''
                            touch .env
                            echo AZURE_STORAGE_CONNECTION_STRING=${AZURE_STORAGE_CONNECTION_STRING} >> .env
                            echo DB_NAME=${DB_NAME} >> .env
                            echo POSTGRES_USER=${POSTGRES_USER} >> .env
                            echo DB_PASSWORD=${DB_PASSWORD} >> .env
                            echo DOCKER_DB_ADDRESS=${DOCKER_DB_ADDRESS} >> .env
                            echo ENVIRONMENT=${ENVIRONMENT} >> .env
                            echo REDIS_URL=${REDIS_URL} >> .env
                            echo REDIS_PORT=${REDIS_PORT} >> .env
                            echo REDIS_PASSWORD=${REDIS_PASSWORD} >> .env
                            echo REDIS_DB=${REDIS_DB} >> .env
                            echo REDIS_HOST=${REDIS_HOST} >> .env
                            echo HISTORY_SERVICE_API_TOKEN=${HISTORY_SERVICE_API_TOKEN} >> .env
                            echo RABBITMQ_ADDRESS=${RABBITMQ_ADDRESS} >> .env
                            echo HISTORY_REPO_BASE_URL=${HISTORY_REPO_BASE_URL} >> .env
                            echo CRON_PORT=${CRON_PORT} >> .env
                            echo APPLE_TEAM_ID_INVESTMENT=${APPLE_TEAM_ID_INVESTMENT} >> .env
                            echo APPLE_CLIENT_ID_INVESTMENT=${APPLE_CLIENT_ID_INVESTMENT} >> .env
                            echo APPLE_KEY_ID_INVESTMENT=${APPLE_KEY_ID_INVESTMENT} >> .env
                            echo "APPLE_PRIVATE_KEY_INVESTMENT=\"${APPLE_PRIVATE_KEY_INVESTMENT}\"" >> .env
                        '''
                    }
                }
            }
        }
        
        stage('Build and Deploy') {
            parallel {
                stage('Production') {
                    when {
                        branch 'prod'
                    }
                    agent {
                        node {
                            label "${env.NODE_LABEL}"
                        }
                    }
                    steps {
                        sh 'docker compose build app'
                        sh '''
                            if ! docker network ls | grep -q traefik-public; then
                                docker network create traefik-public
                            fi
                        '''
                        sh 'docker compose -f docker-compose-prod.yaml down app db traefik postgres-backup --remove-orphans'
                        sh 'docker compose -f docker-compose-prod.yaml up -d app db traefik postgres-backup'
                        
                        // Health check
                        sh '''
                            sleep 10
                            curl http://app.aqaryservices.com || exit 1
                        '''
                    }
                    post {
                        always {
                            sh 'docker system prune -f'
                        }
                        success {
                            office365ConnectorSend webhookUrl: "${env.MS_TEAMS_WEBHOOK_URL}",
                                message: "Production deployment successful",
                                color: "2eb886",
                                status: "Success",
                                factDefinitions: [[name: "Commit Author", template: "${env.GIT_AUTHOR_NAME}"], 
                                                 [name: "Commit Message", template: "${env.GIT_COMMIT_MESSAGE}"]]
                        }
                        failure {
                            office365ConnectorSend webhookUrl: "${env.MS_TEAMS_WEBHOOK_URL}",
                                message: "Production deployment failed",
                                color: "f2522e",
                                status: "Failure",
                                factDefinitions: [[name: "Commit Author", template: "${env.GIT_AUTHOR_NAME}"], 
                                                 [name: "Commit Message", template: "${env.GIT_COMMIT_MESSAGE}"]]
                        }
                    }
                }
                
                stage('Canary') {
                    when {
                        branch 'canary'
                    }
                    agent {
                        node {
                            label "${env.NODE_LABEL}"
                        }
                    }
                    steps {
                        sh 'docker compose build'
                        sh '''
                            if ! docker network ls | grep -q traefik-public; then
                                docker network create traefik-public
                            fi
                        '''
                        sh 'docker compose -f docker-compose-canary.yaml down --remove-orphans'
                        sh 'docker compose -f docker-compose-canary.yaml up -d'
                        
                        // Health check
                        sh '''
                            sleep 10
                            curl http://app.aqaryservices.com || exit 1
                        '''
                    }
                    post {
                        always {
                            sh 'docker system prune -f'
                        }
                        success {
                            office365ConnectorSend webhookUrl: "${env.MS_TEAMS_WEBHOOK_URL}",
                                message: "Staging deployment successful",
                                color: "2eb886",
                                status: "Success",
                                factDefinitions: [[name: "Commit Author", template: "${env.GIT_AUTHOR_NAME}"], 
                                                 [name: "Commit Message", template: "${env.GIT_COMMIT_MESSAGE}"]]
                        }
                        failure {
                            office365ConnectorSend webhookUrl: "${env.MS_TEAMS_WEBHOOK_URL}",
                                message: "Staging deployment failed",
                                color: "f2522e",
                                status: "Failure",
                                factDefinitions: [[name: "Commit Author", template: "${env.GIT_AUTHOR_NAME}"], 
                                                 [name: "Commit Message", template: "${env.GIT_COMMIT_MESSAGE}"]]
                        }
                    }
                }
                
                stage('Cron Service') {
                    when {
                        branch 'cron-prod'
                    }
                    agent {
                        node {
                            label "${env.NODE_LABEL}"
                        }
                    }
                    steps {
                        sh 'docker compose build cron_service'
                        sh '''
                            if ! docker network ls | grep -q traefik-public; then
                                docker network create traefik-public
                            fi
                        '''
                        sh 'docker compose -f docker-compose-prod.yaml down cron_service --remove-orphans'
                        sh 'docker compose -f docker-compose-prod.yaml up -d cron_service'
                    }
                    post {
                        always {
                            sh 'docker system prune -f'
                        }
                        success {
                            office365ConnectorSend webhookUrl: "${env.MS_TEAMS_WEBHOOK_URL}",
                                message: "Cron Service production deployment successful",
                                color: "2eb886",
                                status: "Success",
                                factDefinitions: [[name: "Commit Author", template: "${env.GIT_AUTHOR_NAME}"], 
                                                 [name: "Commit Message", template: "${env.GIT_COMMIT_MESSAGE}"]]
                        }
                        failure {
                            office365ConnectorSend webhookUrl: "${env.MS_TEAMS_WEBHOOK_URL}",
                                message: "Cron Service production deployment failed",
                                color: "f2522e",
                                status: "Failure",
                                factDefinitions: [[name: "Commit Author", template: "${env.GIT_AUTHOR_NAME}"], 
                                                 [name: "Commit Message", template: "${env.GIT_COMMIT_MESSAGE}"]]
                        }
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
