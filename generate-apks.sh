if [ "$TRAVIS_REPO_SLUG" != "bharat-1809/Unito" ]; then
    echo "Not the original repo. Skip apk upload."
    exit 0
fi

# Travis build triggered by a PR
if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "Just a PR. Skip apk upload."
    exit 0
fi

# Travis build triggered by commit to a branch other than develop
if [ "$TRAVIS_BRANCH" != "develop" ]; then
    echo "Not pushed to develop branch. Skip apk upload."
    exit 0
fi

# Get the name of the author from the last commit
COMMITTER_NAME=$(git log -1 --pretty=format:'%an')

# Pushing generated apks to apk branch
if [ "$TRAVIS_BRANCH" == "develop" ]; then
    echo "Pushed to develop branch. Uploading apk(s) to apk branch."

    # Setting up git configurations
    git config --global user.name "Bharat Sharma"
    git config --global user.email "bharat.sharma1809@gmail.com"

    # Creating a new git repository
    cd $HOME
    mkdir apk
    cd apk
    git init

    # Copy the generated apks in to the repository we just created
    cp $HOME/build/bharat-1809/Unito/build/app/outputs/apk/release/app-release.apk $HOME/apk/

    # Add and commit the apks
    git add app-release.apk
    git commit -m "Apk update: Travis build $TRAVIS_BUILD_NUMBER by $COMMITTER_NAME"

    # Rename the current branch from master to apk
    git branch -m apk

    # Pushing the apk branch to the repository
    git push https:bharat-1809/Unito apk -fq> /dev/null
    if [ $? -eq 0 ]; then
        echo "Apk push successful."
    else
        echo "Apk push failed."
    fi
fi
