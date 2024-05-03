# frozen_string_literal: true

# mailsers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
