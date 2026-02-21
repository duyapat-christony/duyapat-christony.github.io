---
layout: post
title: Grade 7 Learning Materials
subtitle: Access the learning materials for Mathematics 7 under the MATATAG Curriculum.
date: 2024-09-14 00:00:00 +0800
image: /assets/thumbnails/math7-student.webp
thumbnail: /assets/thumbnails/math7-logo.webp
toc: true
comments: true
order: 4
---
{% include lang.html %}

<h2 id="grade-level-standards">Grade Level Standards</h2>

According to the MATATAG Curriculum, here’s what Grade 7 Mathematics students are expected to master. Learners should show their knowledge, skills, and understanding in the following areas:

> **Number and Algebra:** This includes applying percentages, using rates, understanding rational and irrational numbers, and performing operations with integers. Students should also be familiar with square and cube roots, sets and subsets, Venn diagram, and scientific notation. They should be able to solve simple equations, simplify numerical expressions involving integers, and evaluate and rearrange algebraic formulas.
{: .prompt-tip}

> **Measurement and Geometry:** Students need to know the properties of regular and irregular polygons, how to measure angles and determine the number of sides of polygons, and how to convert units of measurement. They should also understand how to calculate the volume of square and rectangular pyramids and cylinders.
{: .prompt-tip}

> **Data and Probability:** This involves collecting and sampling data, presenting data in tables and graphs, interpreting statistical graphs, and understanding experimental outcomes.
{: .prompt-tip}

These learning materials feature engaging illustrated reading resources and interactive activities designed to help students master key learning competencies. They are thoughtfully crafted primarily based on the lesson exemplars provided by DepEd. All copyright belong to the rightful owners.

## Quarter 1

> **Performance Standards**<br>
> By the end of the quarter, the learners are able to...
- [x] draw, and describe the features/properties of, regular and irregular polygons.
- [x] use percentages in different contexts.
- [x] identify and use rates.
- [x] create a financial plan.
- [x] describe, order, and perform operations on, rational numbers.
{: .prompt-info }

{% assign posts = site.categories['G7 Quarter 1'] %}
{% if posts and posts.size > 0 %}
  {% assign posts = posts | sort: 'title' %}
  <div id="post-list" class="flex-grow-1 px-xl-1">
    <div class="row">
      {% assign group_index = 0 %}
      {% for post in posts %}
      <div class="col-md-6 mb-4 d-flex"> <!-- Added d-flex to ensure equal height -->
        <h4 id="header--{{group_index}}" class="visually-hidden">{{ post.title }}</h4>
        <article class="card-wrapper card h-100 d-flex flex-column"> <!-- Added h-100 and d-flex to stretch card -->
          <a href="{{ post.url | relative_url }}" style="color: inherit; text-decoration: none;" class="post-preview card row g-0 flex-md-row-reverse h-100">
            <div class="card-body d-flex flex-column">
              <h4 data-toc-skip class="card-title my-2 mt-md-0">{{ post.title }}</h4>
              <div class="card-text content mt-0 mb-3 flex-grow-1"> <!-- Added flex-grow-1 to allow content to stretch -->
                <p>{% include post-summary.html %}</p>
              </div>
            </div>
          </a>
        </article>
      </div>
        {% capture group_index %}{{ group_index | plus: 1 }}{% endcapture %}
      {% endfor %}
    </div>
  </div>
{% else %}
  <blockquote class="prompt-warning">Oops! It looks like there are no learning materials available for Quarter 1 just yet. Stay tuned—content is coming soon!</blockquote>
{% endif %}

## Quarter 2

> **Performance Standards**<br>
> By the end of the quarter, the learners are able to...
- [x] determine square roots of perfect squares and cube roots of perfect cubes, and identify irrational numbers.
- [x] convert units of measure from different systems of measure.
- [x] find the volume of square and rectangular pyramids, and the volume of cylinders.
- [x] describe sets and their subsets, and the union and intersection of sets.
- [x] illustrates sets and subsets, and union and intersection of sets, using Venn diagrams.
{: .prompt-info }

{% assign posts = site.categories['G7 Quarter 2'] %}
{% if posts and posts.size > 0 %}
  {% assign posts = posts | sort: 'title' %}
  <div id="post-list" class="flex-grow-1 px-xl-1">
    <div class="row">
      {% for post in posts %}
      <div class="col-md-6 mb-4 d-flex"> <!-- Added d-flex to ensure equal height -->
        <h4 id="header--{{group_index}}" class="visually-hidden">{{ post.title }}</h4>
        <article class="card-wrapper card h-100 d-flex flex-column"> <!-- Added h-100 and d-flex to stretch card -->
          <a href="{{ post.url | relative_url }}" style="color: inherit; text-decoration: none;" class="post-preview card row g-0 flex-md-row-reverse h-100">
            <div class="card-body d-flex flex-column">
              <h4 data-toc-skip class="card-title my-2 mt-md-0">{{ post.title }}</h4>
              <div class="card-text content mt-0 mb-3 flex-grow-1"> <!-- Added flex-grow-1 to allow content to stretch -->
                <p>{% include post-summary.html %}</p>
              </div>
            </div>
          </a>
        </article>
      </div>
        {% capture group_index %}{{ group_index | plus: 1 }}{% endcapture %}
      {% endfor %}
    </div>
  </div>
{% else %}
  <blockquote class="prompt-warning">Oops! It looks like there are no learning materials available for Quarter 2 just yet. Stay tuned—content is coming soon!</blockquote>
{% endif %}

## Quarter 3

> **Performance Standards**<br>
> By the end of the quarter, the learners are able to...
- [x] collect data, and organize data in a frequency distribution table.
- [x] represent and interpret data in different types of graphs.
- [x] compare and order integers, including through the use of the number line.
- [x] perform the four operations with integers.
- [x] simplify numerical expressions involving integers.
- [x] identify the absolute value of an integer.
{: .prompt-info }

{% assign posts = site.categories['G7 Quarter 3'] %}
{% if posts and posts.size > 0 %}
  {% assign posts = posts | sort: 'title' %}
  <div id="post-list" class="flex-grow-1 px-xl-1">
    <div class="row">
      {% for post in posts %}
      <div class="col-md-6 mb-4 d-flex"> <!-- Added d-flex to ensure equal height -->
        <h4 id="header--{{group_index}}" class="visually-hidden">{{ post.title }}</h4>
        <article class="card-wrapper card h-100 d-flex flex-column"> <!-- Added h-100 and d-flex to stretch card -->
          <a href="{{ post.url | relative_url }}" style="color: inherit; text-decoration: none;" class="post-preview card row g-0 flex-md-row-reverse h-100">
            <div class="card-body d-flex flex-column">
              <h4 data-toc-skip class="card-title my-2 mt-md-0">{{ post.title }}</h4>
              <div class="card-text content mt-0 mb-3 flex-grow-1"> <!-- Added flex-grow-1 to allow content to stretch -->
                <p>{% include post-summary.html %}</p>
              </div>
            </div>
          </a>
        </article>
      </div>
        {% capture group_index %}{{ group_index | plus: 1 }}{% endcapture %}
      {% endfor %}
    </div>
  </div>
{% else %}
  <blockquote class="prompt-warning">Oops! It looks like there are no learning materials available for Quarter 3 just yet. Stay tuned—content is coming soon!</blockquote>
{% endif %}

## Quarter 4

> **Performance Standards**<br>
> By the end of the quarter, the learners are able to...
- [x] solve simple equations.
- [x] substitute into an algebraic expression to evaluate the expression.
- [x] rearrange a formula to make a different variable the subject of the formula.
- [x] gather data from experiments and represent the data in different forms.
- [x] write numbers in scientific notation and perform operations on numbers written in scientific notation.
{: .prompt-info }

{% assign posts = site.categories['G7 Quarter 4'] %}
{% if posts and posts.size > 0 %}
  {% assign posts = posts | sort: 'title' %}
  <div id="post-list" class="flex-grow-1 px-xl-1">
    <div class="row">
      {% for post in posts %}
      <div class="col-md-6 mb-4 d-flex"> <!-- Added d-flex to ensure equal height -->
        <h4 id="header--{{group_index}}" class="visually-hidden">{{ post.title }}</h4>
        <article class="card-wrapper card h-100 d-flex flex-column"> <!-- Added h-100 and d-flex to stretch card -->
          <a href="{{ post.url | relative_url }}" style="color: inherit; text-decoration: none;" class="post-preview card row g-0 flex-md-row-reverse h-100">
            <div class="card-body d-flex flex-column">
              <h4 data-toc-skip class="card-title my-2 mt-md-0">{{ post.title }}</h4>
              <div class="card-text content mt-0 mb-3 flex-grow-1"> <!-- Added flex-grow-1 to allow content to stretch -->
                <p>{% include post-summary.html %}</p>
              </div>
            </div>
          </a>
        </article>
      </div>
        {% capture group_index %}{{ group_index | plus: 1 }}{% endcapture %}
      {% endfor %}
    </div>
  </div>
{% else %}
  <blockquote class="prompt-warning">Oops! It looks like there are no learning materials available for Quarter 4 just yet. Stay tuned—content is coming soon!</blockquote>
{% endif %}

{% include menu-for-students.html %}
