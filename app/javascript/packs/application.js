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

document.addEventListener('turbolinks:load', () => {
  const planImageInput = document.getElementById('plan_plan_image');
  const imagePreview = document.getElementById('image-preview');

  const updateImagePreview = (blob) => {
    // プレビュー画像が既に表示されている場合は削除
    const existingImage = imagePreview.querySelector('img');
    if (existingImage) {
      existingImage.remove();
    }

    // 新しい画像を表示
    const blobImage = document.createElement('img');
    blobImage.setAttribute('class', 'preview-img');
    blobImage.setAttribute('src', blob);
    imagePreview.appendChild(blobImage);
  };

  if (planImageInput) {
    planImageInput.addEventListener('change', (e) => {
      const file = e.target.files[0];
      if (file) {
        const blob = window.URL.createObjectURL(file);
        updateImagePreview(blob);
      }
    });

    // ページ読み込み時に画像が選択されている場合のプレビュー
    if (planImageInput.files.length > 0) {
      const file = planImageInput.files[0];
      const blob = window.URL.createObjectURL(file);
      updateImagePreview(blob);
    }
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

  if (profileImageInput) {
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
  }
});
