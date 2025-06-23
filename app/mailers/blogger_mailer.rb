class BloggerMailer < ApplicationMailer
  def welcome_email(blogger)
    @blogger = blogger
    mail(to: @blogger.email, subject: "🎉 Chào mừng bạn đến với WasteAI!")
  end

  def warning_email(blogger, subject, body)
    @blogger = blogger
    @body = body
    mail(to: @blogger.email, subject: subject)
  end
end
