class Category < ActiveRecord::Base
  has_and_belongs_to_many :books

  default_scope  { order('created_at DESC') }
  scope :sort_by_id, -> { order('id') }
  scope :search, lambda{|query| where('title ILIKE :query ', {query: "%#{query}%"}) }

end
