#!/usr/bin/env bash

git checkout gh-pages
cp heroku/composer.json composer.json
cp heroku/index.php index.php
mv index.html home.html

git add composer.json
git add index.php
git remove index.html
git add home.html

git commit -m "Set up app for Heroku deployment"

git push origin gh-pages