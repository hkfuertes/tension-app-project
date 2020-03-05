pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'docker run --rm --volumes-from jenkins-docker --workdir ${WORKSPACE}/tension-app cirrusci/flutter:stable flutter build apk --target-platform android-arm,android-arm64 --split-per-abi'
      }
    }

    stage('Archive') {
      steps {
        sh 'mv  ${WORKSPACE}/build/app/outputs/apk/release/app-arm64-v8a-release.apk  ${WORKSPACE}/tension-app/build/app/outputs/apk/release/TensionApp.arm64.$(date +%d.%m.%Y).apk'
        sh 'mv  ${WORKSPACE}/build/app/outputs/apk/release/app-armeabi-v7a-release.apk  ${WORKSPACE}/tension-app/build/app/outputs/apk/release/TensionApp.arm.$(date +%d.%m.%Y).apk'
        archiveArtifacts 'build/app/outputs/apk/release/*.apk'
      }
    }

    stage('Publish') {
      steps {
        telegramUploader(chatId: '171309216', filter: 'build/app/outputs/apk/release/*.apk')
      }
    }

  }
}
