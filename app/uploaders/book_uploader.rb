# encoding: utf-8

class BookUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper
  if Rails.env.production?
    storage :fog
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Process files as they are uploaded:
  process :resize_to_fit => [415, 415]

  version :thumb_listing do
    # process :cropper
    process :resize_to_fill => [216, 236]
  end

  version :thumb_big do
    # process :cropper
    process :resize_to_fill => [463, 236]
  end

  version :thumb_view do
    process :resize_to_fit => [415, 415]
  end

  def cropper
    manipulate! do |img|
      x = model.crop_x.to_i
      y = model.crop_y.to_i
      w = model.crop_w.to_i
      h = model.crop_h.to_i
      img.crop "#{w}x#{h}+#{x}+#{y}"
      img
    end
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  # def filename
  #   random_token = Digest::SHA2.hexdigest("#{original_filename}#{model.updated_at}").first(40)
  #   "#{random_token}.#{file.extension}" if original_filename
  # end

end
