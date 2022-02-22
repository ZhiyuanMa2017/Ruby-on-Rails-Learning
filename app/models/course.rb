class Course < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments
  belongs_to :teacher, class_name: 'User', optional: true

  validates :name, presence: true
  validates :description, presence: true
  validates :weekday_one, presence: true, inclusion: { in: %w[Mon Tue Wed Thu Fri], message: 'must be a weekday' }
  validates :weekday_two, allow_blank: true, inclusion: { in: %w[Mon Tue Wed Thu Fri], message: 'must be a weekday' }
  validate :weekday_validation

  validates :start_time, presence: true, format: { with: /\A\d{2}:\d{2}\z/, message: 'must be in the format of HH:MM' }
  # the end time needs to be after the start time
  validates :end_time, presence: true, format: { with: /\A\d{2}:\d{2}\z/, message: 'must be in the format of HH:MM' }
  validate :end_time_after_start_time

  VALID_CODE_REGEX = /[a-zA-Z][a-zA-Z][a-zA-Z][\d][\d][\d]/
  validates :course_code, presence: true, uniqueness: true, format: { with: VALID_CODE_REGEX }
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[OPEN CLOSED] }
  validates :class_room, presence: true

  def end_time_after_start_time
    if start_time.blank?
      errors.add(:start_time, 'can not be empty')
      return
    end
    if end_time.blank?
      errors.add(:end_time, 'can not be empty')
      return
    end
    hour1 = start_time.split(':')[0].to_i
    hour2 = end_time.split(':')[0].to_i
    min1 = start_time.split(':')[1].to_i
    min2 = end_time.split(':')[1].to_i
    if hour1 > 23 || hour1 < 0 || min1 > 59 || min1 < 0
      errors.add(:start_time, 'not valid')
      return
    end
    if hour2 > 23 || hour2 < 0 || min2 > 59 || min2 < 0
      errors.add(:end_time, 'not valid')
      return
    end
    if hour1 > hour2 || (hour1 == hour2 && min1 >= min2)
      errors.add(:end_time, 'must be after the start time')
    end
  end

  def weekday_validation
    if weekday_one == weekday_two
      errors.add(:weekday_two, 'can\'t be the same as Weekday one')
    end
  end
end
