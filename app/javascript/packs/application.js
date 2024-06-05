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
      '<div class="row nested-fields">' +
        '<div class="col-10">' +
          '<input type="text" class="form-control mt-4" name="plan[plan_details_attributes][' + x + '][title]" placeholder="詳細タイトル">' +
        '</div>' +
        '<div class="col-2 d-flex align-items-center">' +
          '<a href="#" class="remove_field btn btn-danger my-3">' +
          '<i class="fa-solid fa-trash" style="color: #ffffff;"></i>' +
          '</a>' +
        '</div>' +
        '<div class="col-12">' +
          '<textarea class="form-control mt-3" name="plan[plan_details_attributes][' + x + '][body]" placeholder="詳細説明"></textarea>' +
        '</div>' +
      '</div>';

// 22行目で指定した<div id="plan_details_wrapper"></div>=(wrapper)にフォーム(formHtml)を追加(append)する
    $(wrapper).append(formHtml);
  });


  $(document).on("click", ".remove_field", function(e) {
    e.preventDefault();

    if(confirm('この詳細を削除してもよろしいですか？')) {
      // 削除ボタンの参照を変数にセット
      var removeButton = $(e.target);
      // 詳細のあるフォーム
      var form = removeButton.closest('form');
      // 削除する詳細のID
      var detailId = removeButton.closest('.nested-fields').find('input')[0].dataset.planDetailId
      var planId = $("#plan_title")[0].dataset.planId
      // console.log(planId, detailId, removeButton.closest('.nested-fields').find('input')[0]);
      // return false;
      // // var planId = removeButton.closest('.nested-fields').find('input')[0].dataset.planId

      console.log(planId);
      if(detailId) {
        $.ajax({
          url: '/plans/' + planId + '/plan_details/' + detailId,
          method: 'DELETE',
          dataType: 'json',
          success: function() {
            // フォームを削除
            removeButton.closest('.nested-fields').remove();
          },
          error: function(xhr, textStatus, errorThrown) {
            console.log(textStatus);
          }
        });
      } else {
        // フォームを削除
        removeButton.closest('.nested-fields').remove();
      }
    }
  });
});