---
layout: post
title: Flower's Dilemma | Math 7 Edition
subtitle: Revamped version of the classic game Hangman – Grade 7 Math Edition.
date: 2024-09-22 00:00:00 +0800
thumbnail: /assets/thumbnails/flowers-dilemma.webp
comments: true
toc: false
order: 7
---

> 🌻🌻 Your goal is to guess the hidden word by choosing letters. Each wrong guess causes a butterfly to fly away, making the flower sad! If you're on a computer, you can use your keyboard. Feel free to take a screenshot of your highest score and share it in the comment section!🌻🌻
{: .prompt-tip }

<iframe id="flowers-dilemma" src="https://duyapat-christony.github.io/hangman-grade7-math" style="width: 100%; height: 200px; border: none;"></iframe>

<script>
  window.addEventListener('message', (event) => {
    if (event.data === 'expandIframe') {
      const iframe = document.getElementById('flowers-dilemma');
      iframe.style.height = '100vh'; 
    }
  });
</script>

{% include menu-for-students.html %}
