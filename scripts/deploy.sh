#!/bin/bash
cd $PWD && git pull
cd frontend && gulp
cd $PWD && git subtree push --prefix backend heroku master