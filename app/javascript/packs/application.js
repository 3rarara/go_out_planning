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
// import 'select2/dist/js/select2';

Rails.start()
Turbolinks.start()
ActiveStorage.start()


// plans/showでplan_detailsの入力フォームを追加するための記述
$(document).ready(function() {
  var wrapper = '#plan_details_wrapper';
  var addButton = '#add_plan_details';
  var x = 1;

  $(document).on("click", addButton, function(e) {
    e.preventDefault();
    x++;

  var formHtml = `
    <div class="row nested-fields">
      <div class="col-10">
        <input type="text" class="form-control my-3" name="plan[plan_details_attributes][${x}][title]" placeholder="詳細タイトル">
      </div>
      <div class="col-2 d-flex align-items-center">
        <a href="#" class="remove_field btn btn-danger my-3">
          <i class="fa-solid fa-trash" style="color: #ffffff;"></i>
        </a>
      </div>
      <div class="col-12">
        <textarea class="form-control mb-3" name="plan[plan_details_attributes][${x}][body]" placeholder="詳細説明"></textarea>
        <input type="text" class="form-control mb-3" name="plan[plan_details_attributes][${x}][address]" placeholder="住所">
      </div>
      <input type="hidden" name="plan[plan_details_attributes][${x}][_destroy]" class="destroy-field" value="false">
    </div>
  `;

    $(wrapper).append(formHtml);
  });

// plans/showでplan_detailsの入力フォームを削除するための記述
  $(document).on("click", ".remove_field", function(e) {
    e.preventDefault();

// plans/editでplan_detailsの入力フォームを削除するための記述
    if(confirm('この詳細を削除してもよろしいですか？')) {
      var removeButton = $(e.target);
      var destroyField = removeButton.closest('.nested-fields').find('.destroy-field');
      if (destroyField.length > 0) {
        destroyField.val('true');
        removeButton.closest('.nested-fields').hide();
        console.log('Status: success - The item was marked for deletion.');
      } else {
        removeButton.closest('.nested-fields').remove();
        console.log('Status: success - The new item was removed.');
      }
    } else {
      console.log('Status: cancelled - The item was not deleted.');
    }
  });
});


// タブメニューの記述
$(document).on('turbolinks:load', function() {
  $('#tab-contents .tab').not('#tab1').hide();

  $('#tab-menu').on('click', 'a', function(event) {
    $('#tab-contents .tab').hide();
    $('#tab-menu .active').removeClass('active');
    $(this).addClass('active');
    $($(this).attr('href')).show();
    event.preventDefault();
  });
});

// ヘッターの記述
document.addEventListener('turbolinks:load', () => {
  const header = document.querySelector('header');
  let prevY = window.scrollY;

  window.addEventListener('scroll', () => {
    const currentY = window.scrollY;
    console.log('scrolling', { prevY, currentY });
    if (currentY < prevY) {
      header.classList.remove('hidden');
    } else {
      if (currentY > 0) {
        header.classList.add('hidden');
      }
    }
    prevY = currentY;
  });
});

// タグ入力保管機能
$(document).on('turbolinks:load', function() {
    $('#tags-input').select2({
        tags: true,
        tokenSeparators: [','],
        placeholder: 'コンマで区切ってタグを追加してください',
        ajax: {
            url: '/tags_list', // タグ一覧を取得するエンドポイント
            dataType: 'json',
            delay: 250,
            data: function(params) {
                return {
                    q: params.term // 検索クエリを'q'として送信
                };
            },
            processResults: function(data) {
                return {
                    results: data
                };
            },
            cache: true
        }
    });
});

