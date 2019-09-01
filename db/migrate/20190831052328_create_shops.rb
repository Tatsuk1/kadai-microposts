class CreateShops < ActiveRecord::Migration[5.2]
  def change
    create_table :shops do |t|
      t.string :shop_code
      t.string :shop_name
      t.string :area
      t.string :pref
      t.string :areacode_l
      t.string :category_l
      t.string :freeword
      t.integer :private_room
      t.integer :outret
      t.integer :wifi
      t.string :category
      t.string :address
      t.string :areacode
      t.string :areaname
      t.string :string
      t.string :prefcode
      t.string :prefname
      t.string :category_code_l
      t.string :lang
      t.string :area_code
      t.string :area_name
      t.string :pref_code
      t.string :pref_name
      t.string :areaname_l
      t.string :category_l_code
      t.string :category_l_name

      t.timestamps
    end
  end
end
