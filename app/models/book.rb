class Book < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :categories
  has_many :chapters, -> { order(:created_at) }
  serialize :authers

  TYPES = ['Book', 'Article']

  scope :sort_by_id, -> { order('id') }
  scope :search, lambda{|query| where('title ILIKE :query ', {query: "%#{query}%"}) }

  mount_uploader :image, BookUploader

  def get_thumb_view
    if !self.image.thumb_view.blank? && File.exist?(self.image.thumb_view.root)
      self.image.thumb_view.url
    else
      'frontend/default/default_img_415.png'
    end
  end

  def get_thumb_listing
    if !self.image.thumb_listing.blank? && File.exist?(self.image.thumb_listing.root)
      self.image.thumb_listing.url
    else
      'frontend/default/default_img_216.png'
    end
  end

  def get_thumb_big
    if !self.image.thumb_big.blank? && File.exist?(self.image.thumb_big.root)
      self.image.thumb_big.url
    else
      'frontend/default/default_img_463.png'
    end
  end

  def crop_image
    image.recreate_versions! unless crop_x.blank?
  end
end
