class Highlight < ActiveRecord::Base
  belongs_to :user
  belongs_to :books_user
  belongs_to :chapter
  acts_as_commentable
end
