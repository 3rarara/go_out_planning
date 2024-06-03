// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application";

Rails.start()
Turbolinks.start()
ActiveStorage.start()

$(document).ready(function() {
  var wrapper = '#plan_details_wrapper';
  var addButton = '#add_plan_details';
  var x = 1;

  $(document).on("click", addButton, function(e) {
    e.preventDefault();
    x++;

    var formHtml =
      '<div class="row my-3">' +
        '<div class="col">' +
          '<input type="text" class="form-control" name="plan[plan_details_attributes][' + x + '][title]" placeholder="詳細タイトル">' +
        '</div>' +
        '<div class="col">' +
          '<input type="text" class="form-control" name="plan[plan_details_attributes][' + x + '][body]" placeholder="詳細説明">' +
        '</div>' +
      '</div>';

    $(wrapper).append(formHtml);
  });

  $(document).on("click", wrapper + " .remove_field", function(e) {
    e.preventDefault();
    $(this).parent('div').remove();
    x--;
  });
});