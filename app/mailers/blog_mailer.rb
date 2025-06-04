class BlogMailer < ApplicationMailer
  def pending_review_email(blog)
    @blog = blog
    @blogger = blog.blogger
    mail(to: @blogger.email, subject: "📝 Bài viết của bạn đang chờ duyệt")
  end

  def approved_email(blog)
    @blog = blog
    @blogger = blog.blogger
    mail(to: @blogger.email, subject: "✅ Bài viết của bạn đã được duyệt!")
  end

  def liked_email(blog, liker)
    @blog = blog
    @liker = liker
    @blogger = blog.blogger

    mail(
      to: @blogger.email,
      subject: "💚 Bài viết của bạn vừa được yêu thích!"
    )
  end
end
