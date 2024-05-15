import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileField", "fileLabel"]

  connect() {
    this.fileFieldTarget.addEventListener('change', this.updateFileLabel.bind(this));
  }

  disconnect() {
    this.fileFieldTarget.removeEventListener('change', this.updateFileLabel.bind(this));
  }

  updateFileLabel() {
    let selectedFileCount = this.fileFieldTarget.files.length;
    this.fileLabelTarget.textContent = selectedFileCount + " 個の画像を選択しています";
  }
}