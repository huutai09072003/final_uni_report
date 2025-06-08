ActiveAdmin.register Image do
  permit_params :game_id, :file

  # ========== BULK UPLOAD ACTIONS ==========
  collection_action :bulk_new, method: :get do
    @games = Game.all
    render 'admin/images/bulk_new'
  end

  collection_action :bulk_create, method: :post do
    game = Game.find(params[:game_id])
    files = params[:files]
    if files.present?
      files = [files] unless files.is_a?(Array)
      files.each do |file|
        image = game.images.build
        image.file.attach(file)
        image.save
      end
      redirect_to admin_images_path, notice: "#{files.size} images uploaded!"
    else
      redirect_to bulk_new_admin_images_path, alert: "No files selected."
    end
  end

  # BULK UPLOAD MENU LINK
  action_item :bulk_upload, only: :index do
    link_to "Bulk Upload Images", bulk_new_admin_images_path
  end

  # FILTERS
  filter :id
  filter :game
  filter :name
  filter :created_at
  filter :updated_at

  # TABLE
  index do
    selectable_column
    id_column
    column :game
    column :name
    column :file do |img|
      if img.file.attached?
        image_tag url_for(img.file), width: 80
      end
    end
    actions
  end

  # FORM (upload 1 ảnh - mặc định)
  form do |f|
    f.inputs do
      f.input :game
      f.input :name
      f.input :file, as: :file
    end
    f.actions
  end

  # SHOW
  show do
    attributes_table do
      row :game
      row :name
      row :file do |img|
        if img.file.attached?
          image_tag url_for(img.file), width: 200
        end
      end
    end
  end
end
