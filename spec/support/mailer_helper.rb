module MailerHelper
  def emails_count
    ActionMailer::Base.deliveries.count
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def reset_email_list
    ActionMailer::Base.deliveries = []
  end
end

