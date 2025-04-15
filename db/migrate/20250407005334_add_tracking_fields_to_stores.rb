class AddTrackingFieldsToStores < ActiveRecord::Migration[8.0]
  def change
    add_column :stores, :last_message_sent_at, :datetime
    add_column :stores, :last_response_at, :datetime
  end
end
