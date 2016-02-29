class CreateHeros < ActiveRecord::Migration
  def change
    create_table :heros do |t|
      t.references :photo, index: true, foreign_key: true
      t.references :item, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
