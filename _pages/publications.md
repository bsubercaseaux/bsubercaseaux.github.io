---
layout: page
permalink: /publications/
title: Publications
description: Papers, preprints, abstracts, and links—organized by year.
years: [2026, 2025, 2024, 2023, 2022, 2021, 2020, 2019, 2018, 2017, 2016]
nav: true
nav_order: 1
publication_previews: true
---

<p class="publication-intro">My most up-to-date list of papers is usually on <a href="{{ site.data.citations.profile_url }}">Google Scholar</a>, but this page is my tidier, annotated list, with BibTeX, abstracts, and links whenever they are available.</p>

<div class="publication-overview">
  <section class="publication-datapoints" aria-labelledby="publication-datapoints-title">
    <h2 id="publication-datapoints-title">Some datapoints</h2>
    <ol>
      <li><strong>Erdős number:</strong> 3 (for example, Paul Erdős → Noga Alon → Daniel Lokshtanov → me).</li>
      <li><strong>Collaborators from:</strong> Austria, Chile, China, France, Germany, India, Japan, the Netherlands, Norway, Portugal, Russia, Slovakia, Spain, and the USA.</li>
      <li><strong>Most common conference:</strong> NeurIPS (five papers). Actively trying to change this 🙃.</li>
      <li><strong>Most fun conference:</strong> <a href="https://sites.google.com/view/fun2022/home?pli=1">FUN with Algorithms</a>.</li>
      <li><strong>Distinctions:</strong> Best paper at CICM 2025 and LPAR 2023; distinguished paper at PODS 2025; runner-up for best paper at CICM 2024; best-paper nomination at TACAS 2023; spotlights at NeurIPS 2021 and AFCI@NeurIPS 2020; and first place in the IEEE LA-CCI Latin American master's thesis contest in AI.</li>
    </ol>
  </section>
  {% include citation_chart.html %}
</div>


## Papers
<div class="publications">
  {% for y in page.years %}
    <h2 class="year" id="year-{{ y }}">{{ y }}</h2>
    {% bibliography -f papers -q @*[year={{y}}]* %}
  {% endfor %}
</div>

[^1]: This count might include a journal version of a conference paper separately, if there's a enough difference between the two.
