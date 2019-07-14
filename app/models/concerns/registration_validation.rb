require 'open-uri'

module RegistrationValidation
  extend ActiveSupport::Concern
  include AppSettings

  included do
    validate :email_valid, on: :create if app_setting("user_authentication_pretix")
  end

  private

  def email_valid
    self.email = self.email.downcase
    self.errors.add(:email, I18n.t(:invalid_membership_code))    if !Ticket.exists?(email: self.email)
    self.errors.clear if check_email_remote_on_pretix
  end

  def check_email_remote_on_pretix
    return unless parsePretixResponse(self.email)
    return if User.exists?(email: self.email)
    Ticket.create(id_code: self.ticket_id, email: self.email)
  end

  def parsePretixResponse(email)
    email_e     = CGI.escape(email)
    event_url   = ENV['PRETIX_EVENT_URL']
    event_token = ENV['PRETIX_EVENT_TOKEN']
    event       = JSON.parse(open("#{event_url}#{email_e}","Authorization" => "#{event_token}").read)
    count       = event["count"]
    # if pretix has a ticket for that user, count should be 1
    return count == 1
  rescue SocketError => e
    self.errors.add(:ticket_id, e.message)
    puts e.message
  end
end
