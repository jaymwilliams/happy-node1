pipeline {
  triggers {
    githubPush()
    pollSCM('H/15 * * * *')
  }
  parameters {
    booleanParam(
          name: 'CLEAN_WORKSPACE',
          defaultValue: false,
          description: 'Start with empty workspace'
      )
  }
  agent {
    kubernetes {
      inheritFrom 'toolbox'
      label 'pod'
      containerTemplate(
        name: 'buildbox',
        image: 'openjdk:8-jdk',
        ttyEnabled: true,
        command: 'cat'
      )
    }
  }
  stages {
    stage('Init') {
      steps {
        script {
          if (params.CLEAN_WORKSPACE) {
            echo "Wiping out workspace"
            deleteDir()
          } else {
            echo 'Skipping cleanup due to user setting'
          }
        }
      }
    }
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Pull and Push') {
      steps {
        container('toolbox') {
          script {
            final sourceImage
            final targetImage
            final targetAccountRole
            final targetRegion
            dir ('.hub') {
               hub.elaborate(state: params.APP_STATE_FILE)
               outputs = hub.explain(state: params.APP_STATE_FILE).stackOutputs
               sourceImage = outputs['application.source.ecr'] as String
               targetImage = outputs['application.target.ecr'] as String
               targetAccountRole = outputs['application.target.roleArn'] as String
               targetRegion = outputs['application.target.region'] as String
            }
            withAWS() {
              sh script: ecrLogin()
              sh script: "docker pull ${sourceImage}:latest"
              sh script: "docker tag ${sourceImage}:latest ${targetImage}:${gitscm.shortCommit}"
              sh script: "docker tag ${sourceImage}:latest ${targetImage}:latest" 
            }           
            withAWS(role:targetAccountRole, region:targetRegion) {
              sh script: ecrLogin()
              sh script: "docker push ${targetImage}:${gitscm.shortCommit}"
              sh script: "docker push ${targetImage}:latest"
            }
          }
        }
      }
    }
    stage('Deploy') {
      environment {
        HUB_COMPONENT = 'container-promotion'
      }
      steps {
        container('toolbox') {
          script {
            final version = "${gitscm.shortCommit}"
            dir ('.hub') {
                outputs = hub.explain(state: params.APP_STATE_FILE).stackOutputs
                targetPlatformState = outputs['application.target.platform.state.file'] as String
                targetAccountRole = outputs['application.target.roleArn'] as String
                targetRegion = outputs['application.target.region'] as String
                targetDomain = outputs['application.target.domain'] as String
                applicationNamespace = outputs['application.namespace'] as String
                applicationName = outputs['application.name'] as String
                promotionEnv = outputs['promotion.environment'] as String
                applicationImage = outputs['application.target.ecr'] as String
                hub.render(template: '../kubernetes.yaml.template', state: params.APP_STATE_FILE)
            }
            echo readFile('kubernetes.yaml')
            withAWS(role:targetAccountRole, region:targetRegion) {
              dir ('.hub') {
                hub.kubeconfig(state:targetPlatformState)
              }
              sh script: "kubectl config use-context ${targetDomain}"
              final namespaceExists = sh script: "kubectl get namespace ${applicationNamespace}", returnStatus: true
              if (namespaceExists != 0) {
                sh script: "kubectl create namespace ${applicationNamespace}"
              }
              final kubectl = "kubectl -n ${applicationNamespace}"
              final exists = sh script: "${kubectl} get -f kubernetes.yaml", returnStatus: true
              try {
                if (exists == 0) {
                  sh script: "${kubectl} set image --record 'deployment/${applicationName}-${promotionEnv}' 'application=${applicationImage}:${version}'"
                } else {
                  sh script: "${kubectl} apply --force --record -f kubernetes.yaml"
                }
              } catch (err) {
                echo "Rolling back"
                sh script: "${kubectl} rollout undo 'deployment/${outputs['application.name']}"
                sh script: "${kubectl} rollout status -w 'deployment/${outputs['application.name']}'"
                echo "Done"
                error "Failed to deploy ${outputs['application.name']}@${version}. Rolled back"
              }
            }
          }
        }
      }
    }
    stage('Validate') {
      steps {
        container('toolbox') {
          script {
            final appUrl
            dir ('.hub') {
                appUrl = hub.explain(state: params.APP_STATE_FILE).stackOutputs['application.target.url'] as String
            }
            retry(30) {
              sleep time: 3, unit: 'SECONDS'
              final resp = httpRequest url: "${appUrl}"
              echo resp.content
              assert resp.status == 200
            }
          }
        }
      }
    }
  }
}
