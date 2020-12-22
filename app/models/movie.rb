class Movie < ApplicationRecord

  has_many :reviews, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations
  has_one_attached :main_image

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :released_on, :duration, presence: true

  validates :title, presence: true, uniqueness: true

  validates :description, length: { minimum: 25 }

  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }

  validates :rating, inclusion: { in: RATINGS }

  validate :acceptable_image

  scope :released, -> { where("released_on <= ?", Time.now).order("released_on desc") }
  scope :upcoming, -> { where("released_on > ?", Time.now).order("released_on asc")}
  scope :recent, -> (max=5) { released.limit(max) }
  scope :hits, -> { released.where("total_gross >= ?", 30_000_000).order("total_gross desc") }
  scope :flops, -> { released.where("total_gross <= ?", 22_500_000).order("total_gross asc") }
  scope :grossed_greater_than, ->(amt) { released.where("total_gross > ? ", amt) }
  scope :grossed_less_than, ->(amt) { released.where("total_gross < ?", amt) }

  before_save :set_slug

  def flop?
    unless reviews.count > 50 && reviews.average(:stars) > 4
      total_gross.blank? || total_gross < 225000000
    end
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def average_stars_as_percent
    (self.average_stars/5) * 100
  end

  def set_slug
    self.slug = title.parameterize
  end

  def to_param
    slug
  end

  private

    def acceptable_image
      return unless main_image.attached?
      
      if main_image.blob.byte_size > 1.megabyte
        errors.add(:main_image, "is too big")
      end

      acceptable_types = ["image/jpeg", "image/png"]
      unless acceptable_types.include?(main_image.content_type)
        errors.add(:main_image, "must be a jpg or png")
      end
    end
  
end
