// 投稿の住所入力フォームオートコンプリート
function addAutocompleteEvent() {
  const textFields = document.querySelectorAll(".js-address-autocomplete");
  if (typeof google !== 'undefined' && typeof google.maps !== 'undefined') {
    textFields.forEach(function(textField) {
      new google.maps.places.Autocomplete(textField);
    });
  }
}

// 投稿バリデーションの記述
function validateEvent() {
  const planSubmitCheck = document.querySelector('#plan_submit');
  if (planSubmitCheck) {
    let planTitleError = false;
    let planDetailTitleError = false;

    const planTitle = document.querySelector('#plan_title');
    const planSubmit = document.querySelector('#plan_submit');

    function validateInput(input) {
      let error = false;
      let errorElement;
      if (input === planTitle) {
        errorElement = document.querySelector('#planTitleError');
        if (input.value.trim() === '') {
          error = true;
          errorElement.textContent = 'タイトルを入力してください。';
        }
      } else if (input.classList.contains('plan_detail_title')) {
        errorElement = input.nextElementSibling; // 各入力フィールドの隣にエラー要素を置く
        if (input.value.trim() === '') {
          error = true;
          errorElement.textContent = 'スケジュールタイトルを入力してください。';
        }
      }
      if (error) {
        errorElement.style.display = 'block';
        if (input === planTitle) {
          planTitleError = true;
        } else {
          planDetailTitleError = true;
        }
      } else {
        errorElement.style.display = 'none';
        if (input === planTitle) {
          planTitleError = false;
        } else {
          planDetailTitleError = false;
        }
      }
    }

    function updatePlanSubmit() {
      const planDetailTitles = document.querySelectorAll('.plan_detail_title:not(.hidden)');
      let hasError = planTitleError || planDetailTitleError;

      planDetailTitles.forEach(input => {
        if (input.value.trim() === '') {
          hasError = true;
        }
      });

      if (planTitle.value.trim() === '' || hasError) {
        planSubmit.classList.add('disabled');
        planSubmit.setAttribute('disabled', true);
      } else {
        planSubmit.classList.remove('disabled');
        planSubmit.removeAttribute('disabled');
      }
    }

    const planDetailTitles = document.querySelectorAll('.plan_detail_title');
    const inputs = [planTitle, ...planDetailTitles];

    inputs.forEach(input => {
      input.addEventListener('input', () => {
        validateInput(input);
        updatePlanSubmit();
      });
    });

    updatePlanSubmit(); // 初期状態をチェック
  }
}

document.addEventListener('turbolinks:load', () => {
  validateEvent();

  // plans/newまたはeditでplan_detailsの入力フォームを追加するための記述
  const wrapper =  document.getElementById("plan_details_wrapper");
  const addButton = document.getElementById("add_plan_details");
  let x = 1;

  // IDの生成と管理
  const existingFields = document.querySelectorAll('.nested-fields');
  if (existingFields.length > 0) {
    const lastField = existingFields[existingFields.length - 1];
    const match = lastField.querySelector('input[name*="[title]"]').name.match(/\[(\d+)\]/);
    x = match ? parseInt(match[1], 10) + 1 : 0;
  }


  addButton.addEventListener("click", function(e) {
    e.preventDefault();

    const formHtml = `
      <div class="row nested-fields">
        <div class="col-10">
          <div class="text-left" style="color: red;">*</div>
          <input type="text" class="form-control plan_detail_title" name="plan[plan_details_attributes][${x}][title]" placeholder="詳細タイトル">
          <div id="planDetailTitleError" class="text-left mt-1" style="display: none; color: red;"></div>
        </div>
        <div class="col-2 d-flex align-items-center mt-4">
          <a href="#" class="remove_field btn btn-danger">
            <i class="fa-solid fa-trash" style="color: #ffffff;"></i>
          </a>
        </div>
        <div class="col-12">
          <textarea class="form-control my-3" name="plan[plan_details_attributes][${x}][body]" placeholder="詳細説明"></textarea>
          <input type="text" class="form-control mb-3 js-address-autocomplete" name="plan[plan_details_attributes][${x}][address]" placeholder="住所または施設名">
        </div>
        <input type="hidden" name="plan[plan_details_attributes][${x}][_destroy]" class="destroy-field" value="false">
      </div>
    `;

    wrapper.insertAdjacentHTML('beforeend', formHtml);
    x++;

    // 追加されたフォームにオートコンプリートを適用
    if (typeof google !== 'undefined' && typeof google.maps !== 'undefined') {
      addAutocompleteEvent();
    }

    // 追加されたフォームにバリデーションを適用
    validateEvent();
  });

  // plans/newでplan_detailsの入力フォームを削除するための記述
  document.addEventListener("click", function(e) {
    if(e.target.closest(".remove_field")) {
      e.preventDefault();

      // plans/editでplan_detailsの入力フォームを削除するための記述
      if(confirm('この詳細を削除してもよろしいですか？')) {
        const removeButton = e.target.closest(".remove_field");
        const nestedFields = removeButton.closest('.nested-fields');
        const destroyField = nestedFields.querySelector('.destroy-field');
        const inputs = nestedFields.querySelectorAll('input');

        if (destroyField) {
          destroyField.value = 'true';
          nestedFields.style.display = 'none';

          // バリデーションするためクラスを付与
          inputs.forEach(input => input.classList.add('hidden'));
          validateEvent();

        } else {
          nestedFields.remove();
        }

        // フォームが削除された場合にバリデーションを再確認
        validateEvent();
      }
    }
  });

  // 投稿画像プレビューの記述
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
        const blob = URL.createObjectURL(file);  // window.URL.createObjectURL の代わりに URL.createObjectURL を使う
        updateImagePreview(blob);
      }
    });

    // ページ読み込み時に画像が選択されている場合のプレビュー
    if (planImageInput.files.length > 0) {
      const file = planImageInput.files[0];
      const blob = URL.createObjectURL(file);  // window.URL.createObjectURL の代わりに URL.createObjectURL を使う
      updateImagePreview(blob);
    }
  }
});
