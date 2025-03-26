class Store < ApplicationRecord
  belongs_to :user

  def self.status_enum
    [
      [1, "Open"],
      [2, "Close"],
    ]
  end
end
