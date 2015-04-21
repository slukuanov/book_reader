class Category < ActiveRecord::Base
  has_and_belongs_to_many :books

  scope :sort_by_id, -> { order('id') }
  scope :search, lambda{|query| where('title ILIKE :query ', {query: "%#{query}%"}) }

  validates :title, :presence => true, :uniqueness => true
end
