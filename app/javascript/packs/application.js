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
        <input type="text" class="form-control mt-4" name="plan[plan_details_attributes][${x}][title]" placeholder="詳細タイトル">
      </div>
      <div class="col-2 d-flex align-items-center">
        <a href="#" class="remove_field btn btn-danger my-3">
          <i class="fa-solid fa-trash" style="color: #ffffff;"></i>
        </a>
      </div>
      <div class="col-12">
        <textarea class="form-control mt-3" name="plan[plan_details_attributes][${x}][body]" placeholder="詳細説明"></textarea>
        <input type="text" class="form-control my-3" name="plan[plan_details_attributes][${x}][address]" placeholder="住所">
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
// document.addEventListener('DOMContentLoaded', function() {
//   const tagInput = document.querySelector('input[list="tag-list"]');
//   const dataList = document.getElementById('tag-list');

//   tagInput.addEventListener('input', function() {
//     const input = this.value.trim();
//     const tags = input.split(',').map(tag => tag.trim());
//     const options = dataList.querySelectorAll('option');

//     options.forEach(option => {
//       const optionValue = option.value.toLowerCase();
//       const optionDisplay = option.style.display;

//       // タグ入力中の最後のタグを取得
//       const lastTag = tags[tags.length - 1].toLowerCase();

//       // 最後のタグがoptionの値に含まれているかどうかをチェックして表示を設定
//       if (optionValue.includes(lastTag) && optionDisplay === 'none') {
//         option.style.display = '';
//       } else if (!optionValue.includes(lastTag) && optionDisplay !== 'none') {
//         option.style.display = 'none';
//       }
//     });
//   });

//   tagInput.addEventListener('focus', function() {
//     // フォーカス時にdatalistの表示をリセット
//     const options = dataList.querySelectorAll('option');
//     options.forEach(option => {
//       option.style.display = '';
//     });
//   });
// });

