document.addEventListener('turbolinks:load', () => {

  // // 投稿の住所入力フォームオートコンプリート
  function addAutocompleteEvent() {
    const textFields = document.querySelectorAll(".js-address-autocomplete");
    textFields.forEach(function(textField) {
      new google.maps.places.Autocomplete(textField);
    });
  }

  // // 住所入力フォームオートコンプリート
  addAutocompleteEvent();

// plans/newまたはeditでplan_detailsの入力フォームを追加するための記述
  let wrapper = '#plan_details_wrapper';
  let addButton = '#add_plan_details';
  let x = 1;

  $(document).on("click", addButton, function(e) {
    e.preventDefault();
    x++;

    let formHtml = `
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
          <input type="text" class="form-control mb-3 js-address-autocomplete" name="plan[plan_details_attributes][${x}][address]" placeholder="住所または施設名">
        </div>
        <input type="hidden" name="plan[plan_details_attributes][${x}][_destroy]" class="destroy-field" value="false">
      </div>
    `;

    $(wrapper).append(formHtml);

    // 追加されたフォームにオートコンプリートを適用
    addAutocompleteEvent();
  });

// plans/newでplan_detailsの入力フォームを削除するための記述
  $(document).on("click", ".remove_field", function(e) {
    e.preventDefault();

// plans/editでplan_detailsの入力フォームを削除するための記述
    if(confirm('この詳細を削除してもよろしいですか？')) {
      let removeButton = $(e.target);
      let destroyField = removeButton.closest('.nested-fields').find('.destroy-field');
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