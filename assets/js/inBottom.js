document.addEventListener('DOMContentLoaded', function () {
  // Get all FAQ titles within faqBody
  const faqTitles = document.querySelectorAll('#faqBody .style2');

  // Add click event listener to each title
  faqTitles.forEach(title => {
    title.addEventListener('click', function () {
      // Toggle active class on the title
      this.classList.toggle('active');

      // Get the next element (answer)
      const answer = this.nextElementSibling;

      // If it's not an answer (style6), skip it
      if (!answer.classList.contains('style6')) {
        return;
      }

      // Toggle active class on the answer
      answer.classList.toggle('active');
    });
  });
});
