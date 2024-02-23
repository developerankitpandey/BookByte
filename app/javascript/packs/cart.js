
import 'cart'

document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll(".add-to-cart-btn").forEach(function(button) {
      button.addEventListener("click", function() {
        const bookId = button.dataset.bookId;
        addToCart(bookId);
      });
    });
  });
  
  function addToCart(bookId) {
    fetch(`/cart/${bookId}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": "<%= form_authenticity_token %>"
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error("Network response was not ok");
      }
      return response.json();
    })
    .then(data => {
      alert("Book added to cart successfully!");
    })
    .catch(error => {
      console.error("Error adding book to cart:", error);
      alert("Failed to add book to cart. Please try again.");
    });
  }
  