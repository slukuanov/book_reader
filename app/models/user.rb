require 'securerandom'

class User < ActiveRecord::Base
  ROLES = %w(unconfirmed confirmed admin venue_owner)
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :avatar, :content_type=>['image/jpeg', 'image/png', 'image/gif']

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  default_scope  { order('created_at DESC') }
  scope :sort_by_id, -> { order('id') }
  scope :sort_by_first_name, -> { order('first_name') }
  scope :sort_by_last_name, -> { order('last_name') }
  scope :sort_by_last_seen, -> { order('last_sign_in_at DESC') }
  scope :sort_by_role, -> { order('role') }
  scope :search, lambda{|query| where('last_name ILIKE :query OR email ILIKE :query OR first_name ILIKE :query ', {query: "%#{query}%"}) }

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  validates :role, inclusion: { in: ROLES }
  validates :first_name, presence: true
  #validates :last_name, presence: true

  after_create :send_confirmation_email, :if => -> { self.role == "unconfirmed" }

  def get_large_avatar
    if !self.avatar.blank?
      self.avatar
    elsif !self.picture.blank?
      self.picture.gsub("type=square", "width=140&height=140")
    else
      'frontend/default/default_img_140.png'
    end
  end

  def get_meidum_avatar
    if !self.avatar.blank?
      self.avatar
    elsif !self.picture.blank?
      self.picture.gsub("type=square", "width=87&height=87")
    else
      'frontend/default/default_user_img_87.png'
    end
  end

  def get_avatar
    if !self.avatar.blank?
      self.avatar
    elsif !self.picture.blank?
      self.picture.gsub("type=square", "width=23&height=23")
    else
      'frontend/default/default_user_img_23.png'
    end
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  def self.full_name_with_email
    order("#{User.table_name}.first_name").map {|c| [c.full_name_with_email, c.id]}
  end

  def full_name_with_email
    Rails.cache.fetch(cache_key + "_full_name_with_email") do
      "#{id} | #{full_name}, #{email}"
    end
  end

  def self.find_for_facebook_oauth(auth)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first

    unless user
      user = User.where(email: auth.info.email).first
      if user
        user.add_fb_account(auth)
      else
        user = User.create(
            first_name: auth.extra.raw_info.first_name,
            last_name: auth.extra.raw_info.last_name,
            birthday: Date.strptime(auth.extra.raw_info.birthday, '%m/%d/%Y'),
            picture: auth.info.image,
            location: auth.info.location,
            provider: auth.provider,
            uid: auth.uid,
            email: auth.info.email,
            password: Devise.friendly_token[0,20],
            role: "confirmed",
            has_password: false
        )
        #user = User.create(first_name: "Artem",last_name: "Pecherin", birthday: Date.strptime(Time.now, '%m/%d/%Y'), location: "en", email: "artempecherin@gmail.com",password: 12345678, role: "admin",has_password: false)
      end
    end
    user
  end

  def full_name
    [self.first_name, self.last_name].join(' ')
  end

  def add_fb_account(auth)
    self.update({provider: auth.provider, uid: auth.uid})
    self.update({birthday: Date.strptime(auth.extra.raw_info.birthday, '%m/%d/%Y')}) unless self.birthday
    self.update({location: auth.info.location}) unless self.location
    self.update({picture: auth.info.image}) unless self.has_avatar? && self.has_picture?
    self.update({role: "confirmed"}) if self.unconfirmed?
  end

  def age
    if birthday
      now = Date.today
      now.year - self.birthday.year - (self.birthday.change(:year => now.year) > now ? 1 : 0)
    else
      ""
    end
  end

  #only with facebook registration
  def has_password?
    self.has_password
  end

  def has_avatar?
    self.avatar.url != "/avatars/original/missing.png"
  end

  def has_picture?
    self.picture != nil
  end

  def has_fb_account?
    self.provider == "facebook" && self.uid != nil
  end

  def has_gplus_account?
    self.provider == "gplus" && self.uid != nil
  end

  def unconfirmed?
    self.role == "unconfirmed"
  end

  def send_confirmation_email
    set_confirmation_token
    ConfirmationMailer.confirmation_email(self).deliver
  end

  private
  def set_confirmation_token
    self.update({confirmation_token: SecureRandom.hex})
  end
end