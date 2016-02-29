class CoreClasses < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,                              :null => false
      t.string :crypted_password
      t.string :salt
      t.string :first_name
      t.string :last_name
      t.string :avatar

      # Remember me
      t.string :remember_me_token,                  :default => nil
      t.datetime :remember_me_token_expires_at,     :default => nil

      # Reset password
      t.string :reset_password_token,               :default => nil
      t.datetime :reset_password_token_expires_at,  :default => nil
      t.datetime :reset_password_email_sent_at,     :default => nil

      # User activation
      t.string :activation_state,                   :default => nil
      t.string :activation_token,                   :default => nil
      t.datetime :activation_token_expires_at,      :default => nil

      # Brute force protection
      t.integer :failed_logins_count,               :default => 0
      t.datetime :lock_expires_at,                  :default => nil
      t.string :unlock_token,                       :default => nil

      # Activity logging
      t.datetime :last_login_at,                    :default => nil
      t.datetime :last_logout_at,                   :default => nil
      t.datetime :last_activity_at,                 :default => nil
      t.string :last_login_from_ip_address,         :default => nil

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :remember_me_token
    add_index :users, :reset_password_token
    add_index :users, :activation_token
    add_index :users, :unlock_token
    add_index :users, [:last_logout_at, :last_activity_at]

    # External authentication
    create_table :authentications do |t|
      t.integer :user_id, :null => false
      t.string :provider, :uid, :null => false
      t.timestamps
    end
    add_index :authentications, [:provider, :uid]

    # rails g model Website slug:string name:string
    create_table :websites do |t|
      t.string :slug
      t.string :name
      t.references :user

      t.timestamps null: false
    end

    # rails g model Collection slug:string name:string
    create_table :collections do |t|
      t.string :slug
      t.string :name
      t.references :website

      t.timestamps null: false
    end

    # rails g model Item slug:string item_type:string item_id:string title:string
    create_table :items do |t|
      t.string :slug
      t.string :item_type
      t.string :item_id
      t.string :title
      t.references :collection
      t.references :folder

      t.timestamps null: false
    end

    # rails g friendly_id
    create_table :friendly_id_slugs do |t|
      t.string   :slug,           :null => false
      t.integer  :sluggable_id,   :null => false
      t.string   :sluggable_type, :limit => 50
      t.string   :scope
      t.datetime :created_at
    end
    add_index :friendly_id_slugs, :sluggable_id
    add_index :friendly_id_slugs, [:slug, :sluggable_type]
    add_index :friendly_id_slugs, [:slug, :sluggable_type, :scope], :unique => true
    add_index :friendly_id_slugs, :sluggable_type

    # rails g model Folder slug:string name:string description:text
    create_table :folders do |t|
      t.string :slug
      t.string :name
      t.text :description
      t.references :collection
      t.integer :parent_id
      t.string :parent_type

      t.timestamps null: false
    end

    # rails g model Photo photo_num:integer filename:string available:boolean sort_order:integer original_height:integer original_width:integer item:references
    create_table :photos do |t|
      t.integer :photo_num
      t.string :filename
      t.boolean :available
      t.integer :sort_order
      t.integer :original_height
      t.integer :original_width
      t.references :item, index: true, foreign_key: true

      t.timestamps null: false
    end

  end
end