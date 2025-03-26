class CreateStores < ActiveRecord::Migration[8.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :rut
      t.string :street_name
      t.integer :ext_number
      t.string :int_number
      t.string :geolocation
      t.string :business_name
      t.references :user, null: false, foreign_key: true
      t.string :email
      t.integer :status, default: 0 

      t.timestamps
    end
  end
end
