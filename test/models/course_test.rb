require 'test_helper'

class CourseTest < ActiveSupport::TestCase

  test 'course should be valid' do
    course = Course.new(
      name: 'Test Course',
      description: 'Test Description',
      weekday_one: 'Mon',
      weekday_two: 'Tue',
      start_time: '10:00',
      end_time: '11:00',
      course_code: 'TES001',
      capacity: 20,
      student_num: 0,
      status: 'OPEN',
      class_room: 'Test Room'
    )
    assert course.valid?
  end

  test 'course name should not be empty' do
    course = Course.new(
      description: 'Test Description',
      weekday_one: 'Mon',
      weekday_two: 'Tue',
      start_time: '10:00',
      end_time: '11:00',
      course_code: 'TES001',
      capacity: 20,
      student_num: 0,
      status: 'OPEN',
      class_room: 'Test Room'
    )
    assert course.invalid?
  end

  test 'course description should not be empty' do
    course = Course.new(
      name: 'Test Course',
      weekday_one: 'Mon',
      weekday_two: 'Tue',
      start_time: '10:00',
      end_time: '11:00',
      course_code: 'TES001',
      capacity: 20,
      student_num: 0,
      status: 'OPEN',
      class_room: 'Test Room'
    )
    assert course.invalid?
  end

  test 'course weekday_one should not be empty' do
    course = Course.new(
      name: 'Test Course',
      description: 'Test Description',
      weekday_two: 'Tue',
      start_time: '10:00',
      end_time: '11:00',
      course_code: 'TES001',
      capacity: 20,
      student_num: 0,
      status: 'OPEN',
      class_room: 'Test Room'
    )
    assert course.invalid?
  end

  test 'course weekday_two can be empty' do
    course = Course.new(
      name: 'Test Course',
      description: 'Test Description',
      weekday_one: 'Mon',
      start_time: '10:00',
      end_time: '11:00',
      course_code: 'TES001',
      capacity: 20,
      student_num: 0,
      status: 'OPEN',
      class_room: 'Test Room'
    )
    assert course.valid?
  end

  test 'course start_time should not be empty' do
    course = Course.new(
      name: 'Test Course',
      description: 'Test Description',
      weekday_one: 'Mon',
      weekday_two: 'Tue',
      end_time: '11:00',
      course_code: 'TES001',
      capacity: 20,
      student_num: 0,
      status: 'OPEN',
      class_room: 'Test Room'
    )
    assert course.invalid?
  end

  test 'course end_time should not be empty' do
    course = Course.new(
      name: 'Test Course',
      description: 'Test Description',
      weekday_one: 'Mon',
      weekday_two: 'Tue',
      start_time: '10:00',
      course_code: 'TES001',
      capacity: 20,
      student_num: 0,
      status: 'OPEN',
      class_room: 'Test Room'
    )
    assert course.invalid?
  end

  test 'course course_code should not be empty' do
    course = Course.new(
      name: 'Test Course',
      description: 'Test Description',
      weekday_one: 'Mon',
      weekday_two: 'Tue',
      start_time: '10:00',
      end_time: '11:00',
      capacity: 20,
      student_num: 0,
      status: 'OPEN',
      class_room: 'Test Room'
    )
    assert course.invalid?
  end

  RSpec.describe Course, 'course course_code must be in the format ABC123' do
    it { should allow_value('ABC123').for(:course_code) }
    it { should_not allow_value('AC123').for(:course_code) }
    it { should_not allow_value('123').for(:course_code) }
    it { should_not allow_value('ACB').for(:course_code) }
  end

  RSpec.describe Course, 'course capacity should be greater than 0' do
    it { should allow_value(1).for(:capacity) }
    it { should_not allow_value(-1).for(:capacity) }
    it { should_not allow_value(0).for(:capacity) }
  end

  RSpec.describe Course, 'course class_room should not be empty' do
    it { should allow_value("dhhd").for(:class_room) }
    it { should_not allow_value("").for(:class_room) }
  end


  test 'course weekday one should be different with weekday two' do
    course = Course.new(
      name: 'Test Course',
      description: 'Test Description',
      weekday_one: 'Mon',
      weekday_two: 'Mon',
      start_time: '10:00',
      end_time: '11:00',
      course_code: 'TES001',
      capacity: 20,
      student_num: 0,
      status: 'OPEN',
      class_room: 'Test Room'
    )
    assert course.invalid?
  end

  test 'course end time should be after start time' do
    course = Course.new(
      name: 'Test Course',
      description: 'Test Description',
      weekday_one: 'Mon',
      weekday_two: 'Tue',
      start_time: '11:00',
      end_time: '11:00',
      course_code: 'TES001',
      capacity: 20,
      student_num: 0,
      status: 'OPEN',
      class_room: 'Test Room'
    )
    assert course.invalid?
  end

  test 'course_code should be unique' do
    course1 = Course.new(
      name: 'Test Course',
      description: 'Test Description',
      weekday_one: 'Mon',
      weekday_two: 'Tue',
      start_time: '11:00',
      end_time: '12:00',
      course_code: 'TES001',
      capacity: 20,
      student_num: 0,
      status: 'OPEN',
      class_room: 'Test Room'
    )
    course1.save
    assert course1.valid?

    course2 = Course.new(
      name: 'Test Course',
      description: 'Test Description',
      weekday_one: 'Mon',
      weekday_two: 'Tue',
      start_time: '11:00',
      end_time: '12:00',
      course_code: 'TES001',
      capacity: 20,
      student_num: 0,
      status: 'OPEN',
      class_room: 'Test Room'
    )
    assert course2.invalid?
  end
end
