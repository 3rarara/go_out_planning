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

document.addEventListener('turbolinks:load', () => {

  // ヘッターの記述
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

  // タブメニューの記述
  const tabContentsWrapper = document.querySelector('#tab-contents');
  if (tabContentsWrapper) {

    const tabContents = tabContentsWrapper.querySelectorAll('.tab');
    tabContents.forEach(tab => {
      if (!tab.matches('#tab1')) {
        tab.style.display = 'none';
      }
    });

    const tabMenu = document.querySelector('#tab-menu');
    tabMenu.addEventListener('click', event => {
      const target = event.target;

      if (target.tagName === 'A') {
        event.preventDefault();
        tabContents.forEach(tab => {
          tab.style.display = 'none';
        });

        const activeLink = tabMenu.querySelector('.active');
        if (activeLink) {
          activeLink.classList.remove('active');
        }
        target.classList.add('active');

        const targetTabId = target.getAttribute('href').substring(1); // hrefの#を除去
        const targetTab = document.querySelector(`#${targetTabId}`);
        if (targetTab) {
          targetTab.style.display = 'block';
        }
      }
    });
  }

  // 新規登録バリデーション
  const registrationSubmitCheck = document.querySelector('#registration_submit');
  if (registrationSubmitCheck) {

    let nameError = false;
    let emailError = false;
    let passError = false;
    let passConfirmError = false;

    const registrationName = document.querySelector('#registration_name');
    const registrationEmail = document.querySelector('#registration_email');
    const registrationPass = document.querySelector('#registration_pass');
    const registrationPassConfirm = document.querySelector('#registration_pass_confirm');
    const registrationSubmit = document.querySelector('#registration_submit');

    const inputs = [registrationName, registrationEmail, registrationPass, registrationPassConfirm];

    inputs.forEach(input => {
      input.addEventListener('input', () => {
        updateSubmit();
      });
    });

    // ユーザー名のinputイベントを監視
    registrationName.addEventListener('input', function() {
      let name = this.value;
      if (name.length < 1) {
        nameError = true;
        document.querySelector('#nameError').textContent = 'ユーザー名を入力してください。';
        document.querySelector('#nameError').style.display = 'block';
        updateSubmit();
      } else {
        fetch(`/users/check_name?name=${name}`)
          .then(response => response.json())
          .then(data => {
            if (data.status === false) {
              nameError = true;
              document.querySelector('#nameError').textContent = 'このユーザー名は既に登録されています。';
              document.querySelector('#nameError').style.display = 'block';
            } else {
              nameError = false;
              document.querySelector('#nameError').style.display = 'none';
            }
            updateSubmit();
          })
          .catch(error => {
            console.log("AJAXリクエスト失敗:", error);
          });
      }
    });

    registrationEmail.addEventListener('input', function() {
      let email = this.value;
      let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email)) {
        emailError = true;
        document.querySelector('#emailError').textContent = 'メールアドレスの形式が正しくありません。';
        document.querySelector('#emailError').style.display = 'block';
        updateSubmit();
      } else {
        fetch(`/users/check_email?email=${email}`)
          .then(response => response.json())
          .then(data => {
            if (data.status === false) {
              emailError = true;
              document.querySelector('#emailError').textContent = 'このメールアドレスは既に登録されています。';
              document.querySelector('#emailError').style.display = 'block';
            } else {
              emailError = false;
              document.querySelector('#emailError').style.display = 'none';
            }
            updateSubmit();
          })
          .catch(error => {
            console.log("AJAXリクエスト失敗:", error);
          });
      }
    });

    // パスワードフィールドのinputイベントを監視
    registrationPass.addEventListener('input', function() {
      if (this.value.length < 6) {
        passError = true;
        updatePasswordError();
        document.querySelector('#passError').style.display = 'block';
      } else {
        passError = false;
        document.querySelector('#passError').style.display = 'none';
      }
      updateSubmit();
    });

    // パスワード最低文字数カウント
    function updatePasswordError() {
      let remaining = 6 - registrationPass.value.length;
      document.querySelector('#remainingChars').textContent = remaining;
    }

    // パスワード確認フィールドのinputイベントを監視
    registrationPassConfirm.addEventListener('input', function() {
      if (this.value !== registrationPass.value) {
        passConfirmError = true;
        document.querySelector('#passConfirmError').style.display = 'block';
      } else {
        passConfirmError = false;
        document.querySelector('#passConfirmError').style.display = 'none';
      }
      updateSubmit();
    });

    function updateSubmit() {
      if (registrationName.value.trim() === '' ||
          registrationEmail.value.trim() === '' ||
          registrationPass.value.trim() === '' ||
          registrationPassConfirm.value.trim() === '' ||
          nameError || emailError || passError || passConfirmError) {
        registrationSubmit.classList.add('disabled');
        registrationSubmit.setAttribute('disabled', true);
      } else {
        registrationSubmit.classList.remove('disabled');
        registrationSubmit.removeAttribute('disabled');
      }
    }
  }

  // ログインバリデーション
  const loginSubmitCheck = document.querySelector('#login_submit');
  if (loginSubmitCheck) {

    let loginEmailError = false;
    let loginPassError = false;
    let loginError = false;

    document.querySelectorAll('#login_email, #login_pass').forEach(element => {
      element.addEventListener('input', function() {
        if (document.querySelector('#login_email').value.trim() === '' || document.querySelector('#login_pass').value.trim() === '') {
          document.querySelector('#login_submit').classList.add('disabled');
          document.querySelector('#login_submit').setAttribute('disabled', true);
        } else if (loginEmailError || loginPassError || loginError) {
          document.querySelector('#login_submit').classList.add('disabled');
          document.querySelector('#login_submit').setAttribute('disabled', true);
        } else {
          document.querySelector('#login_submit').classList.remove('disabled');
          document.querySelector('#login_submit').removeAttribute('disabled');
        }
      });
    });

    // メールアドレスのinputイベントを監視
    document.querySelector('#login_email').addEventListener('input', function() {
      let email = this.value;
      let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email)) {
        document.querySelector('#loginEmailError').textContent = 'メールアドレスの形式が正しくありません。';
        document.querySelector('#loginEmailError').style.display = 'block';
        loginEmailError = true;
      } else {
        document.querySelector('#loginEmailError').style.display = 'none';
        loginEmailError = false;
      }
      updateLoginSubmit();
    });

    // パスワードフィールドのinputイベントを監視
    document.querySelector('#login_pass').addEventListener('input', function() {
      if (this.value.length < 6) {
        updateLoginPasswordError();
        document.querySelector('#loginPassError').style.display = 'block';
        loginPassError = true;
      } else {
        document.querySelector('#loginPassError').style.display = 'none';
        loginPassError = false;
      }
      updateLoginSubmit();
    });

    // パスワード最低文字数カウント
    function updateLoginPasswordError() {
      let remaining = 6 - document.querySelector('#login_pass').value.length;
      document.querySelector('#loginRemainingChars').textContent = remaining;
    }

    function updateLoginSubmit() {
      if (document.querySelector('#login_email').value.trim() === '' || document.querySelector('#login_pass').value.trim() === '' || loginEmailError || loginPassError) {
        document.querySelector('#login_submit').classList.add('disabled');
        document.querySelector('#login_submit').setAttribute('disabled', true);
      } else {
        document.querySelector('#login_submit').classList.remove('disabled');
        document.querySelector('#login_submit').removeAttribute('disabled');
      }
    }

    document.addEventListener("ajax:success", function(e) {
      let data = e.detail[0];
      if (data.status === true) {
        location.href = "/";
      } else if (data.status === false) {
        document.querySelector('#loginError').textContent = 'メールアドレスまたはパスワードが間違っています。';
        document.querySelector('#loginError').style.display = 'block';
      } else if (data.status === "inactive") {
        document.querySelector('#loginError').textContent = '退会済みです。別のメールアドレスをお使いください。';
        document.querySelector('#loginError').style.display = 'block';
      }
    });

    document.addEventListener("ajax:error", function(e) {
      document.querySelector('#loginError').textContent = '通信エラーが発生しました。';
      document.querySelector('#loginError').style.display = 'block';
    });
  }

});