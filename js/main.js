document.addEventListener('DOMContentLoaded', () => {

  // ===== MOBILE MENU =====
  const toggle = document.querySelector('.nav-toggle');
  const navLinks = document.querySelector('.nav-links');

  if (toggle && navLinks) {
    toggle.addEventListener('click', () => {
      navLinks.classList.toggle('open');
      toggle.setAttribute('aria-expanded', navLinks.classList.contains('open'));
    });
    navLinks.querySelectorAll('a').forEach(a => {
      a.addEventListener('click', () => navLinks.classList.remove('open'));
    });
  }

  // ===== BLOKADA PRAWEGO PRZYCISKU NA OBRAZKACH =====
  document.addEventListener('contextmenu', e => {
    if (e.target.tagName === 'IMG') e.preventDefault();
  });

  // ===== DARK MODE =====
  const darkToggle = document.getElementById('darkToggle');
  if (darkToggle) {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
      document.body.classList.add('dark');
      darkToggle.textContent = '☀︎';
    }
    darkToggle.addEventListener('click', () => {
      document.body.classList.toggle('dark');
      const isDark = document.body.classList.contains('dark');
      darkToggle.textContent = isDark ? '☀︎' : '☽';
      localStorage.setItem('theme', isDark ? 'dark' : 'light');
    });
  }

  // ===== MASONRY =====
  const NUM_COLS = window.innerWidth <= 680 ? 2 : 3;
  const allCards = [...document.querySelectorAll('#card-source .card')];
  const cols = [
    document.getElementById('col-0'),
    document.getElementById('col-1'),
    document.getElementById('col-2'),
  ];

  function distributeCards(cards) {
    cols.forEach(c => { if (c) c.innerHTML = ''; });
    cards.forEach((card, i) => {
      const colIndex = i % NUM_COLS;
      if (cols[colIndex]) {
        cols[colIndex].appendChild(card.cloneNode(true));
      }
    });
    attachLightbox();
  }

  // ===== FILTRY =====
  const filterBtns = document.querySelectorAll('.filter-btn');
  filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      filterBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      const filter = btn.dataset.filter;
      const filtered = filter === 'all'
        ? allCards
        : allCards.filter(c => c.dataset.category === filter);
      distributeCards(filtered);
    });
  });

  // ===== LIGHTBOX =====
  const lightbox      = document.getElementById('lightbox');
  const lightboxImg   = document.getElementById('lightboxImg');
  const lightboxClose = document.getElementById('lightboxClose');

  function attachLightbox() {
    document.querySelectorAll('#col-0 .card, #col-1 .card, #col-2 .card').forEach(card => {
      card.addEventListener('click', () => {
        const img = card.querySelector('img');
        if (!img) return;
        lightboxImg.src = img.src;
        lightboxImg.alt = img.alt;
        lightbox.classList.add('open');
        document.body.style.overflow = 'hidden';
      });
    });
  }

  function closeLightbox() {
    lightbox.classList.remove('open');
    document.body.style.overflow = '';
  }

  if (lightboxClose) lightboxClose.addEventListener('click', closeLightbox);
  if (lightbox) lightbox.addEventListener('click', e => {
    if (e.target === lightbox) closeLightbox();
  });
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape') closeLightbox();
  });

  // ===== START =====
  distributeCards(allCards);

}); // koniec DOMContentLoaded
