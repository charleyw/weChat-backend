#!/bin/sh

REPO_VERSION=`git tag | tail -1`
echo "Development version: $REPO_VERSION"
CURRENT_VERSION=`gem search --remote wei-backend | tail -1 | sed -n 's/wei-backend (\(.*\) .*)/\1/p'`
echo "Production version: $CURRENT_VERSION"
if [ "$REPO_VERSION" != "$CURRENT_VERSION" ]; then
  gem build wei-backend.gemspec
  echo $GEM_KEY > ~/.gem/credentials
  echo "pushing: wei-backend-$REPO_VERSION.gem"
  gem push wei-backend-$REPO_VERSION.gem
else
  echo "Do not need publish new version"
fi
