#!/usr/bin/env bash

# Ruby Gems
echo "Installing Ruby gems.."
RUBY_GEMS=(
    "bundler"
    "jekyll"
    "nokogiri"
    "rails"
    "rubocop"
)
gem install ${RUBY_GEMS[@]}