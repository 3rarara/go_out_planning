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

// 画像プレビューの記述
document.addEventListener('turbolinks:load', () => {
  // 画像プレビューを作成する関数
  const createImageHTML = (blob) => {
    const imageElement = document.getElementById('new-image');
    const blobImage = document.createElement('img');
    blobImage.setAttribute('class', 'new-img');
    blobImage.setAttribute('src', blob);

    imageElement.appendChild(blobImage);
  };

  // 画像選択時のイベントリスナーを設定する関数
  const setImagePreviewListener = () => {
    document.getElementById('plan_plan_image').addEventListener('change', (e) => {
      const imageContent = document.querySelector('.new-img');
      if (imageContent) {
        imageContent.remove();
      }

      const file = e.target.files[0];
      const blob = window.URL.createObjectURL(file);
      createImageHTML(blob);
    });
  };

  // URLがnewまたはeditにマッチする場合に画像プレビューを有効にする
  if (document.URL.match(/new/) || document.URL.match(/edit/)) {
    setImagePreviewListener();
  }
});


// プロフィール画像プレビューの記述
document.addEventListener('turbolinks:load', () => {
  const profileImageInput = document.getElementById('user_profile_image');
  const profileImagePreview = document.getElementById('profile-image-preview');

  const updateImagePreview = (blob) => {
    // プレビュー画像が既に表示されている場合は削除
    const existingImage = profileImagePreview.querySelector('img');
    if (existingImage) {
      existingImage.remove();
    }

    // 新しい画像を表示
    const blobImage = document.createElement('img');
    blobImage.setAttribute('class', 'profile-image-preview-img');
    blobImage.setAttribute('src', blob);
    profileImagePreview.appendChild(blobImage);
  };

  profileImageInput.addEventListener('change', (e) => {
    const file = e.target.files[0];
    if (file) {
      const blob = window.URL.createObjectURL(file);
      updateImagePreview(blob);
    }
  });

  // ページ読み込み時に画像が選択されている場合のプレビュー
  if (profileImageInput.files.length > 0) {
    const file = profileImageInput.files[0];
    const blob = window.URL.createObjectURL(file);
    updateImagePreview(blob);
  }
});
