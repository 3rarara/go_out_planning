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

// 新規登録バリデーション
document.addEventListener('turbolinks:load', () => {
   $('#registration_user_email, #registration_user_name, #registration_user_password, #registration_user_password_confirmation').on('input', function() {
      if ($('#registration_user_email').val().trim() === '' || $('#registration_user_name').val().trim() === '' || $('#registration_user_password').val().trim() === '' || $('#registration_user_password_confirmation').val().trim() === '') {
         $('#submit_btn').addClass('disabled').attr('disabled', true);
      } else {
         $('#submit_btn').removeClass('disabled').attr('disabled', false);
      }
  });

  // ユーザー名のinputイベントを監視
  $('#registration_user_name').on('input', function() {
      if ($(this).val().length < 1) {
          updatePasswordError();
          $('#userNameError').show();
      } else {
          $('#userNameError').hide();
      }
  });

  $('#registration_user_email').on('input', function() {
    var email = $(this).val();
    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      $('#emailError').text('メールアドレスの形式が正しくありません。').show();
      $('#submit_btn').addClass('disabled').attr('disabled', true);
    } else {
      console.log("メールアドレス形式チェックを通過しました。AJAXリクエストを送信します。");
      $.ajax({
        url: '/users/check_email',
        method: 'GET',
        data: { email: email },
        success: function(response) {
          console.log("AJAXリクエスト成功:", response);
          if (response.status === false) {
            $('#emailError').text('このメールアドレスは既に登録されています。').show();
            $('#submit_btn').addClass('disabled').attr('disabled', true);
          } else {
            $('#emailError').hide();
            $('#submit_btn').removeClass('disabled').attr('disabled', false);
          }
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
          updatePasswordError();
          $('#passwordError').show();
           $('#submit_btn').addClass('disabled').attr('disabled', true);
      } else {
          $('#passwordError').hide();
           $('#submit_btn').removeClass('disabled').attr('disabled', false);
      }
  });

  // パスワード確認フィールドのinputイベントを監視
  $('#registration_user_password_confirmation').on('input', function() {
      if ($(this).val() !== $('#registration_user_password').val()) {
          $('#passwordConfirmationError').show();
          $('#submit_btn').addClass('disabled').attr('disabled', true);
      } else {
          $('#passwordConfirmationError').hide();
          $('#submit_btn').removeClass('disabled').attr('disabled', false);
      }
  });

  function updatePasswordError() {
      var remaining = 6 - $('#registration_user_password').val().length;
      $('#remainingChars').text(remaining);
  }

});

// ログインバリデーション
document.addEventListener('turbolinks:load', () => {
   $('#login_user_email, #login_user_password').on('input', function() {
      if ($('#login_user_email').val().trim() === '' || $('#login_user_password').val().trim() === '') {
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
          $('#login_submit_btn').addClass('disabled').attr('disabled', true);
      } else {
          $('#loginEmailError').hide();
          $('#login_submit_btn').removeClass('disabled').attr('disabled', false);
      }
  });

  // パスワードフィールドのinputイベントを監視
  $('#login_user_password').on('input', function() {
      if ($(this).val().length < 6) {
          updateLoginPasswordError();
          $('#loginPasswordError').show();
           $('#login_submit_btn').addClass('disabled').attr('disabled', true);
      } else {
          $('#loginPasswordError').hide();
           $('#login_submit_btn').removeClass('disabled').attr('disabled', false);
      }
  });

  function updateLoginPasswordError() {
      var remaining = 6 - $('#login_user_password').val().length;
      $('#loginRemainingChars').text(remaining);
  }

});


$(document).on("ajax:success", '.sessions', function(e){
  var data = e.detail[0];
  if (data.status == true) {
    location.href = "/"
  } else {
    $('#loginError').text('メールアドレスまたはパスワードが間違っています。').show();
    // alert("メールアドレスまたはパスワードが間違っています。")
  }
});

$(document).on("ajax:error", function(e) {
  $('#loginError').text('通信エラーが発生しました。').show();
});