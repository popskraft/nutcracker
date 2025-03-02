document.addEventListener('DOMContentLoaded', () => {
  const htmlElement = document.querySelector('html');
  let lastKnownScrollPosition = 0;
  let ticking = false;

  function updateScrollClass() {
    if (lastKnownScrollPosition > 0) {
      htmlElement.classList.add('scrolled');
    } else {
      htmlElement.classList.remove('scrolled');
    }
    ticking = false;
  }

  document.addEventListener('scroll', () => {
    lastKnownScrollPosition = window.scrollY;

    if (!ticking) {
      window.requestAnimationFrame(() => {
        updateScrollClass();
        ticking = false;
      });
      ticking = true;
    }
  }, { passive: true });
});

