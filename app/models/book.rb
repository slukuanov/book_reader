class Book < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_many :chapters, -> { order(:created_at) }
  serialize :authers

  TYPES = ['Book', 'Article']

  scope :sort_by_id, -> { order('id') }
  scope :search, lambda{|query| where('title ILIKE :query ', {query: "%#{query}%"}) }
end
