# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do

    # ===== Thống kê nhanh (Cards dạng danh sách) =====
    columns do
      column do
        panel "📊 Thống kê hệ thống" do
          ul do
            li "👥 Bloggers: #{Blogger.count}"
            li "📝 Blogs: #{Blog.count}"
            li "💬 Comments: #{Comment.count}"
            li "📣 Active Campaigns: #{Campaign.where(status: 'active').count}"
            li "🎯 Participants: #{Participant.count}"
            li "💵 Tổng tiền quyên góp: #{Donation.sum(:amount).to_f.round(2)}"
            li "♻️ Mục tái chế: #{Item.count}"
            li "📍 Trạm phân loại: #{Station.count}"
          end
        end
      end
    end

    # ===== Nội dung mới nhất (Blog / Campaign / Donation) =====
    columns do
      column do
        panel "🆕 Bài viết gần đây" do
          ul do
            Blog.order(created_at: :desc).limit(5).map do |blog|
              li link_to("#{blog.title} (#{blog.created_at.strftime("%d/%m/%Y")})", admin_blog_path(blog))
            end
          end
        end
      end

      column do
        panel "📣 Chiến dịch mới tạo" do
          ul do
            Campaign.order(created_at: :desc).limit(5).map do |c|
              li link_to("#{c.title} (#{c.status})", admin_campaign_path(c))
            end
          end
        end
      end

      column do
        panel "💸 Quyên góp gần đây" do
          ul do
            Donation.order(created_at: :desc).limit(5).map do |d|
              campaign = Campaign.find_by(id: d.campaign_id)&.title || ""
              li "💰 #{d.amount} #{d.currency} - #{campaign} (#{d.created_at.strftime("%d/%m/%Y")})"
            end
          end
        end
      end
    end

    columns do
      column do
        panel "📈 Subscription toàn hệ thống (for_web)" do
          data = Donation
            .where(donation_type: "for_web")
            .group_by_day(:created_at)
            .count

          div do
            line_chart data, xtitle: "Ngày", ytitle: "Số lượng", colors: ["#34d399"]
          end
        end
      end

      column do
        panel "📉 Subscription cho chiến dịch (for_campaign)" do
          data = Donation
            .where(donation_type: "for_campaign")
            .group_by_day(:created_at)
            .count

          div do
            area_chart data, xtitle: "Ngày", ytitle: "Số lượt", colors: ["#60a5fa"]
          end
        end
      end
    end
  end
end
