function jpostal() {
  $('#zipcode').jpostal({
    postcode : ['#zipcode'],
    address : {
      '#post_image_address': '%3%4%5'
    }
  });
}
$(document).on("turbolinks:load", jpostal);