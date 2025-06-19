ActiveAdmin.register ::Comment, as: "BlogComment" do
  actions :all
  permit_params :content, :blog_id, :blogger_id
end
