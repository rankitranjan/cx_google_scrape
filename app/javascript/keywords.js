document.addEventListener("DOMContentLoaded", function () {
  let keywordList = document.getElementById("keyword-list");
  let shimmerLoader = document.getElementById("shimmer-loader");

  // Simulate shimmer effect before data loads
  if (keywordList && keywordList.innerHTML.trim() === "") {
    shimmerLoader.classList.remove("d-none");
    setTimeout(() => shimmerLoader.classList.add("d-none"), 2000);
  }
});

document.addEventListener("DOMContentLoaded", function() {
  const form = document.getElementById("csvUploadForm");
  const button = document.getElementById("uploadButton");
  const buttonText = document.getElementById("buttonText");
  const spinner = document.getElementById("loadingSpinner");
  const fileInput = document.getElementById("csvFileInput");

  if (form) {
    form.addEventListener("submit", function() {
      if (fileInput.files.length > 0) {
        button.disabled = true;
        buttonText.textContent = "Uploading...";
        spinner.classList.remove("d-none");
      }
    });
  }
});
