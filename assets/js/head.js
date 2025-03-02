const htmlElement = document.querySelector('html');

function throttle(func, limit) {
  let inThrottle;
  return function () {
    if (!inThrottle) {
      func.apply(this, arguments);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
}

window.addEventListener('scroll', throttle(() => {
  if (window.pageYOffset > 0) {
    htmlElement.classList.add('scrolled');
  } else {
    htmlElement.classList.remove('scrolled');
  }
}, 200)); // Throttle scroll event to once every 200ms
