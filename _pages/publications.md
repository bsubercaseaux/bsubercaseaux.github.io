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
1. **h-index**: 7
2. **Erdős number**: 3 (e.g., me → Daniel Lokshtanov → Noga Alon → Paul Erdős).
3. **Collaborators from**: Chile, France, India, US, Portugal, the Netherlands, Norway, Spain. [^2]
4. **Most common conference**: NeurIPS (5 papers there).
5. **Most fun conference**: <a href="https://sites.google.com/view/fun2022/home?pli=1">FUN with algorithms.</a>
6. **Distinctions**: Runner-up for Best paper award at CICM'2024, Best paper award at LPAR'2023. Best paper award nomination at TACAS'2023.  Spotlight paper at NeurIPS'2021, and spotlight paper at <a href="https://www.afciworkshop.org/afci-2020/home">AFCI@NeurIPS'2020 workshop</a>. 1st place in Latin American Contest of Master theses in Artificial Intelligence IEEE LA-CCI.


## Attempt of an Updated List of Papers
<div class="publications">
  {% for y in page.years %}
    {% bibliography -f papers -q @*[year={{y}}]* %}
  {% endfor %}
</div>

[^1]: This count might include a journal version of a conference paper separately, if there's a enough difference between the two.
[^2]: I am hoping to work with people from even more countries!
