#!/bin/sh

# Exit immediately if any command exits with a non-zero status
set -e

# Variables
REPO_URL="https://github.com/v6Org01/web1.git"
BRANCH="staging"
PUBLIC_DIR="$HUGO_DIR/public/"
COMMIT_MESSAGE="+1"
GITHUB_PAT=${GITHUB_PAT:-""}  # :-"" ensures that if GITHUB_PAT is not set or blank it will be assigned "" 

# Check if the public directory exists
if [ ! -d "$PUBLIC_DIR" ]; then
  echo "Directory $PUBLIC_DIR does not exist. Nothing to commit."
  exit 1
fi

# Check if GITHUB_PAT is provided
if [ -z "$GITHUB_PAT" ]; then
  echo "Error: GITHUB_PAT environment variable is not set."
  exit 1
fi

# Configure git
git config --global user.name "devel@web1"
git config --global user.email "devel@github.com"

# Clone the staging branch of the repository
cd /tmp
git clone --single-branch --branch "$BRANCH" "https://$GITHUB_PAT@$REPO_URL"
cd ./web1 

# Copy the public directory to the repo
cp -r "$PUBLIC_DIR" .

# Add, commit, and push the changes
git add "$PUBLIC_DIR"
git commit -m "$COMMIT_MESSAGE"
git push origin "$BRANCH"

# Cleanup
rm -rf /tmp/web1

echo "Public directory has been successfully pushed to the $BRANCH branch."
