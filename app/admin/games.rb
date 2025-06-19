ActiveAdmin.register Game do
  permit_params :name, :description

  # == INDEX
  index title: "🎮 Danh sách Trò chơi" do
    selectable_column
    id_column
    column "🧩 Tên trò chơi", :name
    column "📄 Mô tả", :description
    column "📅 Ngày tạo", :created_at
    actions
  end

  # == SHOW
  show title: proc { |game| "🧩 Chi tiết Game ##{game.id}" } do
    attributes_table title: "🔍 Thông tin Game" do
      row :id
      row :name
      row :description
      row :created_at
      row :updated_at
    end

    panel "🖼 Hình ảnh trò chơi" do
      if game.images.any?
        table_for game.images do
          column :id
          column("Ảnh") do |image|
            if image.file.attached?
              image_tag url_for(image.file), style: "max-height: 100px"
            else
              em "Không có file"
            end
          end
          column :created_at
        end
      else
        div class: "empty-panel" do
          "Chưa có hình ảnh nào được đính kèm."
        end
      end
    end
  end

  # == FORM
  form do |f|
    f.semantic_errors
    f.inputs "📝 Thông tin trò chơi" do
      f.input :name
      f.input :description
    end
    f.actions
  end

  # == FILTER
  filter :name
  filter :created_at
end
