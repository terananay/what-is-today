import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileField", "fileLabel"]

  updateFileLabel() {
    let selectedFileCount = this.fileFieldTarget.files.length;
    this.fileLabelTarget.textContent = selectedFileCount + " 個の画像を選択しています";
  }

  clearText(e) {
    e.preventDefault();
    // クリックイベントが発生した要素の親要素から.form_clearクラスを持つ要素を探す
    let inputElement = e.currentTarget.parentElement.querySelector('.form_clear');

    if (inputElement) {
      inputElement.value = '';
    }
  }
}
