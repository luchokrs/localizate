class ChangeUserIdOnStoresAllowNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :stores, :user_id, true
  end
end