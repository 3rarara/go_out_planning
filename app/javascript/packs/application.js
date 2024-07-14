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

// plans/newまたはeditでplan_detailsの入力フォームを追加するための記述
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

// plans/newでplan_detailsの入力フォームを削除するための記述
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

// 新規登録バリデーション
document.addEventListener('turbolinks:load', () => {
  let emailError = false;
  let nameError = false;
  let passwordError = false;
  let passwordConfirmationError = false;

  $('#registration_user_email, #registration_user_name, #registration_user_password, #registration_user_password_confirmation').on('input', function() {
    updateSubmitButton();
  });

  // ユーザー名のinputイベントを監視
  $('#registration_user_name').on('input', function() {
    var userName = $(this).val();
    if (userName.length < 1) {
      nameError = true;
      $('#userNameError').text('ユーザー名を入力してください。').show();
      updateSubmitButton();
    } else {
      $.ajax({
        url: '/users/check_name',
        method: 'GET',
        data: { name: userName },
        success: function(response) {
          if (response.status === false) {
            nameError = true;
            $('#userNameError').text('このユーザー名は既に登録されています。').show();
          } else {
            nameError = false;
            $('#userNameError').hide();
          }
          updateSubmitButton();
        },
        error: function(xhr, status, error) {
          console.log("AJAXリクエスト失敗:", status, error);
        }
      });
    }
  });

  $('#registration_user_email').on('input', function() {
    var email = $(this).val();
    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      emailError = true;
      $('#emailError').text('メールアドレスの形式が正しくありません。').show();
      updateSubmitButton();
    } else {
      $.ajax({
        url: '/users/check_email',
        method: 'GET',
        data: { email: email },
        success: function(response) {
          if (response.status === false) {
            emailError = true;
            $('#emailError').text('このメールアドレスは既に登録されています。').show();
          } else {
            emailError = false;
            $('#emailError').hide();
          }
          updateSubmitButton();
        },
        error: function(xhr, status, error) {
          console.log("AJAXリクエスト失敗:", status, error);
        }
      });
    }
  });

  // パスワードフィールドのinputイベントを監視
  $('#registration_user_password').on('input', function() {
    if ($(this).val().length < 6) {
      passwordError = true;
      updatePasswordError();
      $('#passwordError').show();
    } else {
      passwordError = false;
      $('#passwordError').hide();
    }
    updateSubmitButton();
  });

  // パスワード確認フィールドのinputイベントを監視
  $('#registration_user_password_confirmation').on('input', function() {
    if ($(this).val() !== $('#registration_user_password').val()) {
      passwordConfirmationError = true;
      $('#passwordConfirmationError').show();
    } else {
      passwordConfirmationError = false;
      $('#passwordConfirmationError').hide();
    }
    updateSubmitButton();
  });

  // パスワード最低文字数カウント
  function updatePasswordError() {
    var remaining = 6 - $('#registration_user_password').val().length;
    $('#remainingChars').text(remaining);
  }

  function updateSubmitButton() {
    if ($('#registration_user_email').val().trim() === '' ||
        $('#registration_user_name').val().trim() === '' ||
        $('#registration_user_password').val().trim() === '' ||
        $('#registration_user_password_confirmation').val().trim() === '' ||
        emailError || nameError || passwordError || passwordConfirmationError) {
      $('#registration_submit_btn').addClass('disabled').attr('disabled', true);
    } else {
      $('#registration_submit_btn').removeClass('disabled').attr('disabled', false);
    }
  }
});



// ログインバリデーション
document.addEventListener('turbolinks:load', () => {
  let emailError = false;
  let passwordError = false;
  let formatError = false;

  $('#login_user_email, #login_user_password').on('input', function() {
    if ($('#login_user_email').val().trim() === '' || $('#login_user_password').val().trim() === '') {
      $('#login_submit_btn').addClass('disabled').attr('disabled', true);
    } else if (emailError || passwordError || formatError) {
      $('#login_submit_btn').addClass('disabled').attr('disabled', true);
    } else {
      $('#login_submit_btn').removeClass('disabled').attr('disabled', false);
    }
  });

  // メールアドレスのinputイベントを監視
  $('#login_user_email').on('input', function() {
    var email = $(this).val();
    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      $('#loginEmailError').text('メールアドレスの形式が正しくありません。').show();
      emailError = true;
    } else {
      $('#loginEmailError').hide();
      emailError = false;
    }
    updateSubmitButton();
  });

  // パスワードフィールドのinputイベントを監視
  $('#login_user_password').on('input', function() {
    if ($(this).val().length < 6) {
      updateLoginPasswordError();
      $('#loginPasswordError').show();
      passwordError = true;
    } else {
      $('#loginPasswordError').hide();
      passwordError = false;
    }
    updateSubmitButton();
  });

  // パスワード最低文字数カウント
  function updateLoginPasswordError() {
    var remaining = 6 - $('#login_user_password').val().length;
    $('#loginRemainingChars').text(remaining);
  }

  function updateSubmitButton() {
    if ($('#login_user_email').val().trim() === '' || $('#login_user_password').val().trim() === '' || emailError || passwordError) {
      $('#login_submit_btn').addClass('disabled').attr('disabled', true);
    } else {
      $('#login_submit_btn').removeClass('disabled').attr('disabled', false);
    }
  }
});

$(document).on("ajax:success", '.sessions', function(e){
  var data = e.detail[0];
  if (data.status === true) {
    location.href = "/";
  } else {
    $('#loginError').text('メールアドレスまたはパスワードが間違っています。').show();
  }
});

$(document).on("ajax:error", function(e) {
  $('#loginError').text('通信エラーが発生しました。').show();
});
