class Book < ApplicationRecord
  belongs_to :auther

  validates :name, presence: true
  validates :page, presence: true
end
