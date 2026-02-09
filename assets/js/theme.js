document.addEventListener('DOMContentLoaded', function () {
  // Support both legacy Carrd classes (style2/style6) and current contract (style-2/style-6).
  const faqTitles = document.querySelectorAll('#faqBody .style-2, #faqBody .style2');

  // Add click event listener to each title
  faqTitles.forEach(title => {
    title.addEventListener('click', function () {
      // Toggle active class on the title
      this.classList.toggle('active');

      // Get the next element (answer)
      const answer = this.nextElementSibling;

      // If the next element is not an answer block, skip it.
      if (!answer.classList.contains('style-6') && !answer.classList.contains('style6')) {
        return;
      }

      // Toggle active class on the answer
      answer.classList.toggle('active');
    });
  });
});

// const htmlElement = document.querySelector('html');

// function throttle(func, limit) {
//   let inThrottle;
//   return function () {
//     if (!inThrottle) {
//       func.apply(this, arguments);
//       inThrottle = true;
//       setTimeout(() => inThrottle = false, limit);
//     }
//   };
// }

// window.addEventListener('scroll', throttle(() => {
//   if (window.pageYOffset > 0) {
//     htmlElement.classList.add('scrolled');
//   } else {
//     htmlElement.classList.remove('scrolled');
//   }
// }, 200)); // Throttle scroll event to once every 200ms
