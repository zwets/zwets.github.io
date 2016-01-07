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

### Kramdown

 - [Kramdown Cheatsheet](http://ricostacruz.com/cheatsheets/kramdown.html)
 - [Kramdown Reference](http://kramdown.gettalong.org/quickref.html)

### Jekyll and Liquid Templating 

 - [Liquid for Designers](https://github.com/Shopify/liquid/wiki/Liquid-for-Designers)
 - [Jekyll Templates](http://jekyllrb.com/docs/templates/)

### Themes for Jekyll

 - [Jekyll Now](https://github.com/barryclark/jekyll-now) from 
   [Building a blog with Jekyll and GitHub pages](http://www.smashingmagazine.com/2014/08/build-blog-jekyll-github-pages/)
 - [Poole](http://getpoole.com/)
 - [Lanyon](http://lanyon.getpoole.com/)
 - [Skinny Bones](https://mmistakes.github.io/skinny-bones-jekyll/)

## Quickstart (local)

From the Jekyll site

{: .terminal }
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

### Kramdown

Kramdown can do footnotes[^1] and assign id, title and class to elements.
{: #id-for-that}
{: .class-for-that}
{: title="title for that"}

Kramdown can do abbrs too.

*[abbrs]: Abbreviations

Kramdown code blocks are either indented by tab or four spaces, or use tilde as delimiters:

~~~ ruby
def what?
  42
end
~~~

##### Footnotes
[^1]: Kramdown can do footnotes

