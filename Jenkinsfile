pipeline {
    agent any


    stages {
        stage('Build & Test') {
            steps {
                wrap([$class: 'Xvnc', takeScreenshot: false, useXauthority: true]) {
                    sh '''
                        # Print versions.
                        java -version
                        mvn -version
                        git --version

                        # Print environment.
                        printenv

                        # Check license headers are present for all files, where relevant.
                        #./misc/license-header/license-header-check.bash

                        # Get Git last commit date.
                        GIT_DATE_EPOCH=$(git log -1 --format=%cd --date=raw | cut -d ' ' -f 1)
                        GIT_DATE=$(date -d @$GIT_DATE_EPOCH -u +%Y%m%d-%H%M%S)

                        # Configure 'jenkins' profile for build.
                        BUILD_ARGS="-Pjenkins"

                        # Configure 'sign' profile for build.
                        # Sign 'master' branch, to allow checking release signing before deployment.
                        # Sign releases. Determined based on release version tag name.
                        if [[ "$GIT_BRANCH" == "master" || "$TAG_NAME" =~ ^v[0-9]+\\.[0-9]+.*$ ]]; then
                            BUILD_ARGS="$BUILD_ARGS -Psign"
                        fi

                        # Override the 'escet.version.enduser' property for releases. Remains 'dev' otherwise.
                        if [[ "$TAG_NAME" =~ ^v[0-9]+\\.[0-9]+.*$ ]]; then
                            BUILD_ARGS="$BUILD_ARGS -Descet.version.enduser=$TAG_NAME"
                        fi

                        # Override the 'escet.website.version' property for releases. Remains '' otherwise.
                        if [[ "$TAG_NAME" =~ ^v[0-9]+\\.[0-9]+.*$ ]]; then
                            BUILD_ARGS="$BUILD_ARGS -Descet.website.version=$TAG_NAME"
                        fi

                        # Override the 'escet.version.qualifier' property for Jenkins builds.
                        # It starts with 'v' and the Git date, followed by a qualifier postfix.
                        # For releases, the qualifier postfix is the postfix of the version tag (if any).
                        # For non-releases, the qualifier postfix is 'dev'.
                        if [[ "$TAG_NAME" =~ ^v[0-9]+\\.[0-9]+.*$ ]]; then
                            QUALIFIER_POSTFIX=$(echo "$TAG_NAME" | sed -e 's/^[^-]*//g')
                        else
                            QUALIFIER_POSTFIX=-dev
                        fi
                        BUILD_ARGS="$BUILD_ARGS -Descet.version.qualifier=v$GIT_DATE$QUALIFIER_POSTFIX"

                        # Perform build.
                        #./build.sh $BUILD_ARGS
                        echo "OK"
                    '''
                }
            }

        }
    }
}
