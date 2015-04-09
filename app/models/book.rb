class Book < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_many :chapters
  serialize :authers

  TYPES = ['Book', 'Article']
end
