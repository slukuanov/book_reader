class BooksUser < ActiveRecord::Base
  validates_uniqueness_of :user_id, :scope => :book_id
end
