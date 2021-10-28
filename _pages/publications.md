---
layout: page
permalink: /publications/
title: publications
description: publications by categories in reversed chronological order.
years: [2021, 2020, 2019, 2018, 2017, 2016]
nav: true
---
<<<<<<< HEAD
<!-- _pages/publications.md -->
=======

Also, you can check my updated list of papers in [Google Scholar](https://scholar.google.com/citations?user=0EOonpYAAAAJ&hl=en) or [DBLP](https://dblp.org/pid/242/3007.html)

>>>>>>> b06a8cd (improve publications)
<div class="publications">
  
  {% for y in page.years %}
    {% bibliography -f papers -q @*[year={{y}}]* %}
  {% endfor %}


<<<<<<< HEAD
{%- for y in page.years %}
  <h2 class="year">{{y}}</h2>
  {% bibliography -f papers -q @*[year={{y}}]* %}
{% endfor %}
=======
>>>>>>> b06a8cd (improve publications)

</div>
