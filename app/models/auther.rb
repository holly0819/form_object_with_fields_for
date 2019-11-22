class Auther < ApplicationRecord
  has_many :books, dependent: :destroy

  validates :name, presence: true
  validates :sex, presence: true
end
