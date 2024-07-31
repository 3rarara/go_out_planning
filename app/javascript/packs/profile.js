document.addEventListener('turbolinks:load', () => {

  // プロフィール画像プレビューの記述
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

  // ユーザー情報変更時バリデーション
  const editSubmitCheck = document.querySelector('#edit_submit');
  if (editSubmitCheck) {

    let editNameError = false;
    let editEmailError = false;

    document.querySelectorAll('#edit_name, #edit_email').forEach(element => {
      element.addEventListener('input', function() {
        if (document.querySelector('#edit_name').value.trim() === '' || document.querySelector('#login_pass').value.trim() === '') {
          document.querySelector('#edit_submit').classList.add('disabled');
          document.querySelector('#edit_submit').setAttribute('disabled', true);
        } else if (editNameError || editEmailError) {
          document.querySelector('#edit_submit').classList.add('disabled');
          document.querySelector('#edit_submit').setAttribute('disabled', true);
        } else {
          document.querySelector('#edit_submit').classList.remove('disabled');
          document.querySelector('#edit_submit').removeAttribute('disabled');
        }
      });
    });

    // ユーザー名のinputイベントを監視
    document.querySelector('#edit_name').addEventListener('input', function() {
      if (this.value.length < 1) {
        document.querySelector('#editNameError').style.display = 'block';
        editNameError = true;
      } else {
        document.querySelector('#editNameError').style.display = 'none';
        editNameError = false;
      }
      updateEditSubmit();
    });

    // メールアドレスのinputイベントを監視
    document.querySelector('#edit_email').addEventListener('input', function() {
      let email = this.value;
      let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (email.length < 1 ) {
        document.querySelector('#editEmailError').textContent = 'メールアドレスを入力してください。';
        document.querySelector('#editEmailError').style.display = 'block';
        editEmailError = true;
      } else if (!emailRegex.test(email)) {
        document.querySelector('#editEmailError').textContent = 'メールアドレスの形式が正しくありません。';
        document.querySelector('#editEmailError').style.display = 'block';
        editEmailError = true;
      } else {
        fetch(`/users/check_email?email=${email}`)
          .then(response => response.json())
          .then(data => {
            if (data.status === false) {
              editEmailError = true;
              document.querySelector('#editEmailError').textContent = 'このメールアドレスは既に登録されています。';
              document.querySelector('#editEmailError').style.display = 'block';
            } else {
              document.querySelector('#editEmailError').style.display = 'none';
              editEmailError = false;
            }
            updateEditSubmit();
          })
          .catch(error => {
            console.log("AJAXリクエスト失敗:", error);
          });
      }
    });

    function updateEditSubmit() {
      if (document.querySelector('#edit_name').value.trim() === '' || document.querySelector('#edit_email').value.trim() === '' || editNameError || editEmailError) {
        document.querySelector('#edit_submit').classList.add('disabled');
        document.querySelector('#edit_submit').setAttribute('disabled', true);
      } else {
        document.querySelector('#edit_submit').classList.remove('disabled');
        document.querySelector('#edit_submit').removeAttribute('disabled');
      }
    }
  }

});