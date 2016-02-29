ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :created_at
    column :updated_at
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs 'User Details' do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
