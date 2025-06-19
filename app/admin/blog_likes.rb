ActiveAdmin.register BlogLike do
  actions :all
  permit_params :blog_id, :blogger_id
end
