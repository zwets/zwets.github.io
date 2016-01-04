source 'https://rubygems.org'

require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)
gem 'github-pages', versions['github-pages']
# Either the above four lines, or if it doesn't work, just
#gem 'github-pages'

# Install jekyll docs for offline use - apparently broken
#gem 'jekyll-docs'
#gem 'jekyll-docs', versions['jekyll']


