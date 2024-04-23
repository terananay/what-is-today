# frozen_string_literal: true

# アプリケーション内でメールを送信するためのクラス
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
