# app/admin/game.rb
ActiveAdmin.register Game do
  permit_params :name, :description

  index do
    selectable_column
    id_column
    column :name
    column :description
    actions
  end
end
