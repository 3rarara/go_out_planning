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


// 投稿の住所入力フォームオートコンプリート
function initAutocomplete() {
  const inputs = document.querySelectorAll('.pac-input');
  inputs.forEach(input => {
    const autocomplete = new google.maps.places.Autocomplete(input);
  });
}

// Turbolinksを考慮したイベントリスナー
document.addEventListener("turbolinks:load", function() {
  if (document.querySelector('.pac-input')) {
    initAutocomplete();
  }
});

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
          <input type="text" class="form-control mb-3 pac-input" name="plan[plan_details_attributes][${x}][address]" placeholder="住所または施設名">
        </div>
        <input type="hidden" name="plan[plan_details_attributes][${x}][_destroy]" class="destroy-field" value="false">
      </div>
    `;

    $(wrapper).append(formHtml);

    // 追加されたフォームにオートコンプリートを適用
    initAutocomplete();
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
  let nameError = false;
  let emailError = false;
  let passError = false;
  let passConfirmError = false;

  $('#registration_name, #registration_email, #registration_pass, #registration_pass_confirm').on('input', function() {
    updateSubmit();
  });

  // ユーザー名のinputイベントを監視
  $('#registration_name').on('input', function() {
    var name = $(this).val();
    if (name.length < 1) {
      nameError = true;
      $('#nameError').text('ユーザー名を入力してください。').show();
      updateSubmit();
    } else {
      $.ajax({
        url: '/users/check_name',
        method: 'GET',
        data: { name: name },
        success: function(response) {
          if (response.status === false) {
            nameError = true;
            $('#nameError').text('このユーザー名は既に登録されています。').show();
          } else {
            nameError = false;
            $('#nameError').hide();
          }
          updateSubmit();
        },
        error: function(xhr, status, error) {
          console.log("AJAXリクエスト失敗:", status, error);
        }
      });
    }
  });

  $('#registration_email').on('input', function() {
    var email = $(this).val();
    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      emailError = true;
      $('#emailError').text('メールアドレスの形式が正しくありません。').show();
      updateSubmit();
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
          updateSubmit();
        },
        error: function(xhr, status, error) {
          console.log("AJAXリクエスト失敗:", status, error);
        }
      });
    }
  });

  // パスワードフィールドのinputイベントを監視
  $('#registration_pass').on('input', function() {
    if ($(this).val().length < 6) {
      passError = true;
      updatePasswordError();
      $('#passError').show();
    } else {
      passError = false;
      $('#passError').hide();
    }
    updateSubmit();
  });

  // パスワード最低文字数カウント
  function updatePasswordError() {
    var remaining = 6 - $('#registration_pass').val().length;
    $('#remainingChars').text(remaining);
  }

  // パスワード確認フィールドのinputイベントを監視
  $('#registration_pass_confirm').on('input', function() {
    if ($(this).val() !== $('#registration_pass').val()) {
      passConfirmError = true;
      $('#passConfirmError').show();
    } else {
      passConfirmError = false;
      $('#passConfirmError').hide();
    }
    updateSubmit();
  });

  function updateSubmit() {
    if ($('#registration_name').val().trim() === '' ||
        $('#registration_email').val().trim() === '' ||
        $('#registration_pass').val().trim() === '' ||
        $('#registration_pass_confirm').val().trim() === '' ||
        nameError || emailError || passError || passConfirmError) {
      $('#registration_submit').addClass('disabled').attr('disabled', true);
    } else {
      $('#registration_submit').removeClass('disabled').attr('disabled', false);
    }
  }
});





// ログインバリデーション
document.addEventListener('turbolinks:load', () => {
  let emailError = false;
  let passwordError = false;
  let loginError = false;

  $('#login_email, #login_pass').on('input', function() {
    if ($('#login_email').val().trim() === '' || $('#login_pass').val().trim() === '') {
      $('#login_submit').addClass('disabled').attr('disabled', true);
    } else if (emailError || passwordError || loginError) {
      $('#login_submit').addClass('disabled').attr('disabled', true);
    } else {
      $('#login_submit').removeClass('disabled').attr('disabled', false);
    }
  });

  // メールアドレスのinputイベントを監視
  $('#login_email').on('input', function() {
    var email = $(this).val();
    var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      $('#loginEmailError').text('メールアドレスの形式が正しくありません。').show();
      emailError = true;
    } else {
      $('#loginEmailError').hide();
      emailError = false;
    }
    updateSubmit();
  });

  // パスワードフィールドのinputイベントを監視
  $('#login_pass').on('input', function() {
    if ($(this).val().length < 6) {
      updateLoginPasswordError();
      $('#loginPassError').show();
      passwordError = true;
    } else {
      $('#loginPassError').hide();
      passwordError = false;
    }
    updateSubmit();
  });

  // パスワード最低文字数カウント
  function updateLoginPasswordError() {
    var remaining = 6 - $('#login_pass').val().length;
    $('#loginRemainingChars').text(remaining);
  }

  function updateSubmit() {
    if ($('#login_email').val().trim() === '' || $('#login_pass').val().trim() === '' || emailError || passwordError) {
      $('#login_submit').addClass('disabled').attr('disabled', true);
    } else {
      $('#login_submit').removeClass('disabled').attr('disabled', false);
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
