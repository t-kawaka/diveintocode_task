class Agenda < ApplicationRecord
  belongs_to :team
  belongs_to :user
  has_many :articles, dependent: :destroy
  validates :title, presence: true, length: { minimum: 2, maximum: 20 }
end
