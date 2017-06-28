class Device < ApplicationRecord
  has_secure_password

  has_many :positions, dependent: :destroy
  belongs_to :user
end
