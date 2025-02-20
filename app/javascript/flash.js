document.addEventListener("DOMContentLoaded", function() {
  const flashMessages = document.querySelectorAll('.flash-message');
  
  flashMessages.forEach((message) => {
    setTimeout(() => {
      message.style.opacity = '0';
      setTimeout(() => {
        message.remove();
      }, 500); // Wait for fade out
    }, 3000); // Hide after 3 seconds
  });
});
