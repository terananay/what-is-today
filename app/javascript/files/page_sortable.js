document.addEventListener('DOMContentLoaded', () => {
  console.log("読み込みテスト");
  const picture_left = document.getElementById('picture_left');
  const picture_right = document.getElementById('picture_right');

  Sortable.create(picture_left, {
    group: 'shared',
    animation: 150,
    pull: true,
    sort: true,
    handle: '.srt_hndl',
    onEnd: function () {
      updatePictureIdsInput();
    }
  });

  Sortable.create(picture_right, {
    group: 'shared',
    animation: 150,
    delay: 100,
    delayOnTouchOnly: true,
    pull: true,
    sort: false,
    handle: '.srt_hndl',
    onEnd: function () {
      updatePictureIdsInput();
    }
  });

  function updatePictureIdsInput() {
    let pictureIds = [];
    let leftItems = picture_left.querySelectorAll('div[page-picture-id], div[picture-id]');
    leftItems.forEach(function (item) {
      // page-picture-id と picture-id のどちらか存在する方を取得
      let id = item.getAttribute('page-picture-id') || item.getAttribute('picture-id');
      if (id) {
        pictureIds.push(id);
      }
    });

    // 隠しフィールドを更新
    let input = document.querySelector('input[name="page[picture_ids][]"]');
    input.value = pictureIds.join(',');
    console.log(input.value);
  }
});