---
title: Jekyll Notes
layout: page
category: notes
tags: jekyll, github, markdown
ignore: { permalink, category, categories, tags, published }
---

## Links

### Jekyll and Github

 - [Jekyll Documentation](http://jekyllrb.com/docs/home/)
 - [Using Jekyll with GitHub Pages](https://help.github.com/articles/using-jekyll-with-pages/)

### Markdown on GitHub

 - [Mastering Markdown](https://guides.github.com/features/mastering-markdown/)
 - [Markdown Basics](https://help.github.com/articles/markdown-basics/)
 - [Writing on Github](https://help.github.com/articles/writing-on-github/)
 - [GitHub Flavoured Markdown](https://help.github.com/articles/github-flavored-markdown/)

### Themes for Jekyll

 - [Jekyll Now](https://github.com/barryclark/jekyll-now) from 
   [Building a blog with Jekyll and GitHub pages](http://www.smashingmagazine.com/2014/08/build-blog-jekyll-github-pages/)
 - [Poole](http://getpoole.com/)
 - [Lanyon](http://lanyon.getpoole.com/)
 - [Skinny Bones](https://mmistakes.github.io/skinny-bones-jekyll/)

## Quickstart (local)

From the Jekyll site

{% highlight bash %}
echo "source 'https://rubygems.org'" > Gemfile
echo "gem 'github-pages'" >> Gemfile
bundle install
bundle update # regularly
bundle exec jekyll serve
{% endhighlight %}

{% highlight bash %}
# Seems to be broken
bundle install gem jekyll-docs
bundle exec jekyll docs
{% endhighlight %}
