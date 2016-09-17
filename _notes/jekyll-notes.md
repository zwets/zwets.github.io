---
title: Jekyll Notes
tags: jekyll, github, markdown
excerpt: Scratch page with Jekyll and (GitHub flavoured) Markdown samples and links.
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
```bash
echo "source 'https://rubygems.org'

require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)                                                                                                                                          
gem 'github-pages', versions['github-pages']" > Gemfile

bundle install
bundle update # regularly
bundle exec jekyll serve
```

```bash
# Seems to be broken
bundle install gem jekyll-docs
bundle exec jekyll docs
```

### Kramdown

Kramdown can do footnotes[^1] and assign id, title and class to elements.
{: #id-for-that}
{: .class-for-that}
{: title="title for that"}

Kramdown can do abbrs too.

*[abbrs]: Abbreviations*

kramdown
: Definitions in Kramdown

Kramdown code blocks are either indented by tab or four spaces, or use tilde as delimiters:

~~~ ruby
def what?
  42
end
~~~

Math support in Kramdown, requires including MathJax, visit http://gastonsanchez.com/blog/opinion/2014/02/16/Mathjax-with-jekyll.html

$$
\alpha \cdots \beta = 0.5
$$


##### Footnotes
[^1]: Kramdown can do footnotes

