#!/bin/bash

# Build frontend
pushd frontend-web
gulp deploy
popd

# Deploy on heroku
git subtree push --prefix backend heroku master