json.extract! course, :id, :name, :description, :weekday_one, :weekday_two, :start_time, :end_time, :course_code, :capacity, :student_num, :status, :class_room, :created_at, :updated_at
json.url course_url(course, format: :json)
