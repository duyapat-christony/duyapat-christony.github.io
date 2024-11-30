---
layout: page
title: Data Analytics
icon: fa fa-square-poll-vertical
order: 2
---

{% assign posts = site.categories['Data Analytic'] %}
{% if posts and posts.size > 0 %}
  <div id="post-list" class="flex-grow-1 px-xl-1">
    {% for post in posts %}
      <article class="card-wrapper card">
        <a href="{{ post.url | relative_url }}" class="post-preview row g-0 flex-md-row-reverse">
          {% assign card_body_col = '12' %}
          {% if post.image %}
            {% assign src = post.image.path | default: post.image %}
            {% unless src contains '//' %}
              {% assign src = post.media_subpath | append: '/' | append: src | replace: '//', '/' %}
            {% endunless %}
            {% assign alt = post.image.alt | xml_escape | default: 'Preview Image' %}
            {% assign lqip = null %}
            {% if post.image.lqip %}
              {% capture lqip %}lqip="{{ post.image.lqip }}"{% endcapture %}
            {% endif %}
            <div class="col-md-5">
              <img src="{{ src }}" alt="{{ alt }}" {{ lqip }}>
            </div>
            {% assign card_body_col = '7' %}
          {% endif %}
          <div class="col-md-{{ card_body_col }}">
            <div class="card-body d-flex flex-column">
              <h1 class="card-title my-2 mt-md-0">{{ post.title }}</h1>
              <div class="card-text content mt-0 mb-3">
                <p>{% include post-description.html %}</p>
              </div>
              <div class="post-meta flex-grow-1 d-flex align-items-end">
                <div class="me-auto">
                  <!-- posted date -->
                  <i class="far fa-calendar fa-fw me-1"></i>
                  {% include datetime.html date=post.date lang=lang %}
                </div>
                {% if post.pin %}
                  <div class="pin ms-1">
                    <i class="fas fa-thumbtack fa-fw"></i>
                    <span>{{ site.data.locales[lang].post.pin_prompt }}</span>
                  </div>
                {% endif %}
              </div>
              <!-- .post-meta -->
            </div>
            <!-- .card-body -->
          </div>
        </a>
      </article>
    {% endfor %}
  </div>
{% else %}
  <blockquote class="prompt-info"><strong>⚠️CAUTION⚠️</strong> <br>🚧This page is currently under construction. Check back soon for the final reveal!🚧</blockquote>
{% endif %}
