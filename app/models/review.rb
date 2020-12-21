class Review < ApplicationRecord

  STARS = (1..5).to_a

  belongs_to :user

  belongs_to :movie

  validates :comment, length: { minimum: 4 }

  validates :stars, inclusion: { in: STARS, message: "must be between 1 and 5"}

  scope :past_n_days, ->(days=7) { where("created_at >= ?", days.days.ago)}

  def stars_as_percent
    (stars / 5.0) * 100.0
  end

end
