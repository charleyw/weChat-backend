#!/bin/sh
git tag
REPO_VERSION=`git tag | tail -1`
echo "Development version: $REPO_VERSION"
SEARCH_RESULTS=`gem search --remote wei-backend`
echo $SEARCH_RESULTS
CURRENT_VERSION=`echo $SEARCH_RESULTS | tail -1 | sed -n 's/wei-backend (\(.*\).*)/\1/p'`
echo "Production version: $CURRENT_VERSION"
if [ "$REPO_VERSION" != "$CURRENT_VERSION" ]; then
  echo "---" > ~/.gem/credentials
  echo $GEM_KEY >> ~/.gem/credentials
  gem build wei-backend.gemspec
  chmod 0600 ~/.gem/credentials
  echo "pushing: wei-backend-$REPO_VERSION.gem"
  gem push wei-backend-$REPO_VERSION.gem
else
  echo "Do not need publish new version"
fi
