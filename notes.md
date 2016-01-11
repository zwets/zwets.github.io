---
title: Notes
permalink: /notes/
layout: archive
---

<div class="notes">

  <ul class="pages">
    {% for page in site.pages %}
      <li>
        <span class="page-date">{{ page.date | date: "%b %-d, %Y" }}</span>
        <a class="page-link" href="{{ page.url | prepend: site.baseurl }}">{{ page.title }}</a>
      </li>
    {% endfor %}
  </ul>

</div>
