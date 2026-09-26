---
layout: about
title: Home
permalink: /
description: Bernardo Subercaseaux is a theoretical computer scientist working on automated reasoning, discrete mathematics, and trustworthy computational proofs.
nav_order: 0
math: false
---
<article class="home-sheet">
  <div class="mondrian-rule" aria-hidden="true"><span></span><span></span><span></span><span></span><span></span></div>

  <header class="home-intro">
    <div>
      <h1 class="home-title">Bernardo Subercaseaux</h1>
      <p class="home-lede">I am a PhD candidate at <a href="https://www.cs.cmu.edu/">CMU</a>, where I am advised by the amazing <a href="https://www.cs.cmu.edu/~mheule/">Marijn Heule</a>. I think mostly about using <a href="https://www.sat4math.com">SAT for mathematics</a>,  but to be honest, I just love computer science and discrete mathematics in their full diversity.</p>

      <ul class="home-links" aria-label="Contact and academic profiles">
        <li><a href="mailto:{{ site.email | encode_email }}">email</a></li>
        <li><a href="{{ '/assets/pdf/CV-BernardoSubercaseaux.pdf' | relative_url }}">resume / CV</a></li>
        <li><a href="https://scholar.google.com/citations?user={{ site.scholar_userid }}">Google Scholar</a></li>
        <li><a href="https://github.com/{{ site.github_username }}">GitHub</a></li>
        <li><a href="https://orcid.org/{{ site.orcid_id }}">ORCID</a></li>
      </ul>
    </div>

    <figure class="hero-portrait-card" tabindex="0" aria-label="Portrait of Bernardo; focus to reveal a Curious George illustration">
      <div class="portrait-frame">
        <img class="portrait-main" src="{{ '/assets/img/prof_pic4.jpg' | relative_url }}" alt="Bernardo Subercaseaux in profile" width="852" height="1280">
        <img class="portrait-easter-egg" src="{{ '/assets/img/Curious_George.png' | relative_url }}" alt="" width="360" height="450" aria-hidden="true">
      </div>
      <figcaption class="portrait-caption"><strong>Figure 1:</strong> me.</figcaption>
    </figure>
  </header>

  <section class="home-statement" aria-labelledby="research-statement-heading">
    <h2 class="statement-label" id="research-statement-heading">Research statement.</h2>
    <div class="statement-copy">
      <p>I am passionate about several topics in discrete mathematics and theoretical computer science. My current focus is the intersection between <em>automated reasoning</em> (especially SAT solving) and mathematics. I also have significant experience in theoretical explainability and interpretability in AI, online algorithms, and combinatorial games.</p>

      <ul class="research-threads">
        <li><span class="thread-mark" aria-hidden="true"></span><span><strong>SAT encodings.</strong> How do we design encodings that perform well on actual SAT solvers? What are the theoretical limits and possibilities of CNF encodings?</span></li>
        <li><span class="thread-mark" aria-hidden="true"></span><span><strong>Computers doing mathematics.</strong>  The LLM avalanche is pressing us against the wall with questions about the future of mathematics, and I want to engage with them seriously. </span></li>
        <li><span class="thread-mark" aria-hidden="true"></span><span><strong>Good side quests.</strong> Wordle, Mastermind, explainable AI, online algorithms, geometric puzzles and others; I like working on problems that refuse to let me go.</span></li>
      </ul>
    </div>
  </section>

  <section class="recent-work" aria-labelledby="recent-work-heading">
    <h2 class="recent-heading" id="recent-work-heading">Lately, on paper.</h2>
    <div>
      <ol class="paper-notes">
        <li>
          <span class="paper-date">March 2026</span>
          <span><a class="paper-note-title" href="https://arxiv.org/abs/2603.28954">Near-Optimal Encodings of Cardinality Constraints</a><span class="paper-note-detail">with Andrew Krapivin and Benjamin Przybocki; it begins with SAT encodings and somehow ends at a fifty-year-old circuit problem.</span></span>
        </li>
        <li>
          <span class="paper-date">March 2026</span>
          <span><a class="paper-note-title" href="https://arxiv.org/abs/2603.27774">Automated Reencoding Meets Graph Theory</a><span class="paper-note-detail">with Benjamin Przybocki and Marijn Heule; we ask graph theory what a reencoding tool is really doing—and where it must eventually get stuck.</span></span>
        </li>
        <li>
          <span class="paper-date">January 2026</span>
          <span><a class="paper-note-title" href="https://arxiv.org/abs/2601.19161">Price of Locality in Permutation Mastermind</a><span class="paper-note-detail">a solo excursion into whether TikTok influencers are chaotic enough.</span></span>
        </li>
      </ol>
      <a class="all-papers-link" href="{{ '/publications/' | relative_url }}">All papers, abstracts, and BibTeX →</a>
    </div>
  </section>

  <section class="social-statement" aria-labelledby="social-statement-heading">
    <h2 class="statement-label" id="social-statement-heading">Social statement.</h2>
    <div class="statement-copy">
      <p>I deeply believe that Math and CS are some of the most beautiful collective enterprises of humankind. Understanding them as human activities (at least partially) that take place inside human communities is crucial for me.</p>
      <p>As a consequence, I am very interested in peer review, philosophy of science, history of mathematics, and how we can better leverage computers for doing mathematics. A long-term goal of mine is to contribute to the development of the theoretical CS community in Chile and South America. If you are interested in my research—or in discussing anything else mentioned here—please reach out!</p>
    </div>
  </section>

  <nav class="home-detours" aria-label="Other parts of the site">
    <span>Other doors in this house:</span>
    <a href="{{ '/bio/' | relative_url }}">a long (yet outdated) biography of yours truly</a>
    <a href="{{ '/blog/' | relative_url }}">way too few thoughts on math, philosophy, and life</a>
    <a href="{{ '/literature/' | relative_url }}">poetry and fiction (of the non-mathematical kind)</a>
  </nav>
</article>
