class CampaignMailer < ApplicationMailer
  def pending_review_email(campaign)
    @campaign = campaign
    @subscriber = campaign.founder # assumed to be a Subscriber model
    mail(to: @subscriber.email, subject: "📢 Chiến dịch của bạn đang chờ duyệt")
  end

  def approved_email(campaign)
    @campaign = campaign
    @subscriber = campaign.founder
    mail(to: @subscriber.email, subject: "✅ Chiến dịch của bạn đã được duyệt!")
  end
end
