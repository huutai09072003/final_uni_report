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

  def rejected_email(blog)
    @blog = blog
    @blogger = blog.blogger
    mail(to: @blogger.email, subject: "❌ Bài viết của bạn đã bị từ chối")
  end

  def warning_email(blog, subject, body)
    @blog = blog
    @body = body
    mail(to: @blog.blogger.email, subject: subject)
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
