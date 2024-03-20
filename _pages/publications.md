---
layout: page
permalink: /publications/
title: Publications
description: 
years: [2024, 2023, 2022, 2021, 2020, 2019, 2018, 2017, 2016]
nav: true
---

My most up-to-date list of papers is usually on [Google Scholar](https://scholar.google.com/citations?user=0EOonpYAAAAJ&hl=en), but here you can find some summarized data as well as my best attempt to have an updated and tidy list, with bibtex references, abstracts and links to download.

## Summarized Data
1. **Number of papers**: 20. [^1]
2. **Number of conference papers**: 10
3. **Number of workshop papers**: 2
4. **Number of journal papers**: 2
5. **Citations**: 202
6. **h-index**: 6
7. **Erdős number**: 3 (e.g., me → Daniel Lokshtanov → Noga Alon → Paul Erdős).
8. **Collaborators from**: Chile, France, India, US, the Netherlands, Norway. [^2]
9. **Most common conference**: NeurIPS (5 papers there).
10. **Most fun conference**: <a href="https://sites.google.com/view/fun2022/home?pli=1">FUN with algorithms.</a>
11. **Distinctions**: 1 best paper award at LPAR'202. 1 best paper award nomination at TACAS'2023. 1 spotlight paper at NeurIPS'2021, 1 spotlight paper at <a href="https://www.afciworkshop.org/afci-2020/home">AFCI@NeurIPS'2020 workshop</a>


## Attempt of an Updated List of Papers

<div class="publications">
  
  {% for y in page.years %}
    {% bibliography -f papers -q @*[year={{y}}]* %}
  {% endfor %}

</div>

[^1]: This count might include a journal version of a conference paper separately, if there's a enough difference between the two.
[^2]: I am hoping to work with people from even more countries!
