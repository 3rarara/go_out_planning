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