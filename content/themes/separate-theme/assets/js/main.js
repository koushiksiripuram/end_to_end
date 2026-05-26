// DEVINK — Theme JS

(function () {
  'use strict';

  // ---- Mobile nav toggle ----
  const menuBtn = document.querySelector('.menu-toggle');
  const mobileNav = document.querySelector('.mobile-nav');
  if (menuBtn && mobileNav) {
    menuBtn.addEventListener('click', () => {
      const open = mobileNav.classList.toggle('open');
      menuBtn.setAttribute('aria-expanded', open);
    });
  }

  // ---- Active nav link ----
  const currentPath = window.location.pathname;
  document.querySelectorAll('.site-nav a').forEach(link => {
    if (link.getAttribute('href') === currentPath) {
      link.classList.add('active');
    }
  });

  // ---- Smooth fade-in on scroll ----
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1 });

  document.querySelectorAll('.featured-card, .post-card').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(16px)';
    el.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
    observer.observe(el);
  });

  document.addEventListener('animationend', () => {}, { once: true });

  // Add visible class styles via JS
  const style = document.createElement('style');
  style.textContent = '.featured-card.visible, .post-card.visible { opacity: 1 !important; transform: translateY(0) !important; }';
  document.head.appendChild(style);

  // ---- Copy code blocks ----
  document.querySelectorAll('pre').forEach(pre => {
    const btn = document.createElement('button');
    btn.textContent = 'copy';
    btn.style.cssText = `
      position:absolute; top:10px; right:10px;
      background:var(--bg2); border:1px solid var(--border);
      color:var(--muted); font-family:var(--font-mono);
      font-size:0.7rem; padding:3px 10px; border-radius:4px;
      cursor:pointer; letter-spacing:0.04em; transition:color 0.2s;
    `;
    pre.style.position = 'relative';
    pre.appendChild(btn);
    btn.addEventListener('click', () => {
      navigator.clipboard.writeText(pre.querySelector('code')?.textContent || pre.textContent);
      btn.textContent = 'copied!';
      btn.style.color = 'var(--accent)';
      setTimeout(() => { btn.textContent = 'copy'; btn.style.color = 'var(--muted)'; }, 2000);
    });
  });

})();
