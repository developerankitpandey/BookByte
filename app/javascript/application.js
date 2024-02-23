// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

//= require jquery3
//= require popper
//= require bootstrap
//= require slick-carousel/slick/slick.min.js

$(document).on('turbolinks:load', function() {
    $('.slick-carousel').slick({
      slidesToShow: 3, // Adjust the number of slides shown
      slidesToScroll: 1,
      autoplay: true,
      autoplaySpeed: 2000, // Adjust the autoplay speed (in milliseconds)
      responsive: [
        {
          breakpoint: 768,
          settings: {
            slidesToShow: 2,
            slidesToScroll: 1
          }
        },
        {
          breakpoint: 480,
          settings: {
            slidesToShow: 1,
            slidesToScroll: 1
          }
        }
      ]
    });
  });
  