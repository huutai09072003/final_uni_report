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

  def rejected_email(campaign)
    @campaign = campaign
    mail(to: @campaign.founder.email, subject: "❌ Chiến dịch đã bị từ chối")
  end

  def warning_email(campaign, subject, body)
    @campaign = campaign
    @body = body
    mail(to: @campaign.founder.email, subject: subject)
  end

  def contact_founder_email(campaign:, founder:, message:, from_email:, from_name:)
    @campaign = campaign
    @founder = founder
    @message = message
    @from_name = from_name
    @from_email = from_email

    mail(
      to: @founder.email,
      subject: "[WasteAI] Tin nhắn mới về chiến dịch \"#{@campaign.title}\" từ #{@from_name} (#{@from_email})"
    )
  end

  def contact_to_admin_email(campaign:, message:, from_email:, from_name:)
    @campaign = campaign
    @message = message
    @from_name = from_name
    @from_email = from_email

    mail(
      to: ENV['ADMIN_EMAIL'],
      subject: "[WasteAI Admin] Tin nhắn từ #{@from_name} liên quan đến chiến dịch \"#{@campaign.title}\""
    )
  end
end
