class User < ApplicationRecord
  has_one :store, dependent: :nullify
end
