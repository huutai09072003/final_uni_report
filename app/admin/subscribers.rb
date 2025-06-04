ActiveAdmin.register Subscriber do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :nickname, :full_name, :email, :phone_number
  #
  # or
  #
  permit_params do
    permitted = [:nickname, :full_name, :email, :phone_number]
    permitted << :other if params[:action] == 'create'
    permitted
  end
  
end
