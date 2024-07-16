// プロフィール画像プレビューの記述
document.addEventListener('DOMContentLoaded', () => {
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