#!/bin/bash
git pull
cd frontend && gulp
git subtree push --prefix backend heroku master