# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'nao-responda@freelancer.com.br'
  layout 'mailer'
end
