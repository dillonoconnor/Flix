class User < ApplicationRecord
  has_secure_password

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  validates :name, presence: true

  validates :email, format: { with: /\S+@\S+/ },
            uniqueness: { case_sensitive: false }
  
  validates :password, length: { minimum: 10, allow_blank: true }

  validates :username, presence: true, format: { with: /\A[A-Z0-9]+\z/i },
                       uniqueness: { case_sensitive: false }


  scope :by_name, -> { order(:name) }
  scope :not_admins, -> { by_name.where(admin: false) }

  before_save :set_slug

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def set_slug
    self.slug = username.parameterize
  end

  def to_param
    slug
  end
  
end
