// Use IntersectionObserver for scroll detection
const observer = new IntersectionObserver(
  ([entry]) => {
    document.documentElement.classList.toggle('scrolled', !entry.isIntersecting);
  },
  {
    root: null,
    threshold: 0,
    rootMargin: '0px'
  }
);

// Create and observe a sentinel element
const sentinel = document.createElement('div');
sentinel.style.cssText = 'position: absolute; top: 0; width: 1px; height: 1px;';
document.body.prepend(sentinel);
observer.observe(sentinel);

