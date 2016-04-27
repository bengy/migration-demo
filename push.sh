#!/bin/bash
git push origin master
git subtree push --prefix backend heroku master
