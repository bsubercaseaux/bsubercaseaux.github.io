---
layout: page
permalink: /publications/
title: publications
description: in reversed chronological order.
years: [2022, 2021, 2020, 2019, 2018, 2017, 2016]
nav: true
---

Also, you can check my updated list of papers in [Google Scholar](https://scholar.google.com/citations?user=0EOonpYAAAAJ&hl=en) or [DBLP](https://dblp.org/pid/242/3007.html)

<div class="publications">
  
  {% for y in page.years %}
    {% bibliography -f papers -q @*[year={{y}}]* %}
  {% endfor %}

</div>
