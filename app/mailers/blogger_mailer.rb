class BloggerMailer < ApplicationMailer
  def welcome_email(blogger)
    @blogger = blogger
    mail(to: @blogger.email, subject: "🎉 Chào mừng bạn đến với WasteAI!")
  end
end
