---
layout: page
permalink: /talks/
title: Talks
nav: true
nav_order: 1.5
---

<p class="talks-intro">A growing collection of talks I've given, with slides and recordings when available.</p>

<div class="talks">
  {% assign talks_by_year = site.data.talks | sort: "date" | reverse | group_by_exp: "talk", "talk.date | date: '%Y'" %}
  {% for year in talks_by_year %}
  <section class="talk-year" aria-labelledby="talk-year-{{ year.name }}">
    <h2 id="talk-year-{{ year.name }}">{{ year.name }}</h2>
    <ol class="talk-list">
      {% for talk in year.items %}
      <li class="talk-entry" id="talk-{{ talk.id | escape }}">
        {% case talk.date_precision %}
          {% when "year" %}
            {% assign machine_date = talk.date | date: "%Y" %}
            {% assign display_date = talk.date | date: "%Y" %}
          {% when "month" %}
            {% assign machine_date = talk.date | date: "%Y-%m" %}
            {% assign display_date = talk.date | date: "%B" %}
          {% else %}
            {% assign machine_date = talk.date | date: "%Y-%m-%d" %}
            {% assign display_date = talk.date | date: "%b %-d" %}
        {% endcase %}
        <time class="talk-date" datetime="{{ machine_date }}">{{ talk.date_label | default: display_date | escape }}</time>
        <div class="talk-copy">
          <h3>{{ talk.title | escape }}</h3>
          <p class="talk-venue">{{ talk.venue | escape }}{% if talk.location %}<span class="talk-location"> · {{ talk.location | escape }}</span>{% endif %}</p>
          {% if talk.slides or talk.short_slides or talk.video or talk.event_url or talk.presentation_source %}
          <div class="talk-links">
            {% if talk.slides %}
              {% if talk.slides contains "://" %}
                {% assign slides_url = talk.slides %}
              {% else %}
                {% assign slides_url = talk.slides | relative_url %}
              {% endif %}
              <a class="btn" href="{{ slides_url | escape }}" aria-label="{{ talk.slides_label | default: 'Slides' | escape }}{% if talk.slides_format %} ({{ talk.slides_format | escape }}){% endif %} for {{ talk.title | escape }}">{{ talk.slides_label | default: 'Slides' | escape }}{% if talk.slides_format %} ({{ talk.slides_format | escape }}){% endif %}</a>
            {% endif %}
            {% if talk.short_slides %}
              {% if talk.short_slides contains "://" %}
                {% assign short_slides_url = talk.short_slides %}
              {% else %}
                {% assign short_slides_url = talk.short_slides | relative_url %}
              {% endif %}
              <a class="btn" href="{{ short_slides_url | escape }}" aria-label="Short slide version{% if talk.short_slides_format %} ({{ talk.short_slides_format | escape }}){% endif %} for {{ talk.title | escape }}">Short version{% if talk.short_slides_format %} ({{ talk.short_slides_format | escape }}){% endif %}</a>
            {% endif %}
            {% if talk.video %}<a class="btn" href="{{ talk.video | escape }}" aria-label="Video of {{ talk.title | escape }}">Video</a>{% endif %}
            {% if talk.presentation_source %}<a class="btn" href="{{ talk.presentation_source | escape }}" aria-label="Animated presentation source for {{ talk.title | escape }}">Animation source</a>{% endif %}
            {% if talk.event_url %}<a class="btn" href="{{ talk.event_url | escape }}" aria-label="Event information for {{ talk.title | escape }}">Event</a>{% endif %}
          </div>
          {% endif %}
        </div>
      </li>
      {% endfor %}
    </ol>
  </section>
  {% endfor %}
</div>
