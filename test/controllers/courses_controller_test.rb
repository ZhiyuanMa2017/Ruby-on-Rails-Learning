require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:one)
    @course2 = courses(:two)
    @teacher = users(:teacher)
    @admin = users(:admin)
    @student = users(:student)
    @student2 = users(:student2)
  end

  def login(user)
    post sessions_login_path(params: { session: { email: user.email, password: 'password' } })
  end

  test "should get index" do
    get sessions_login_path
    login(@teacher)
    assert_redirected_to root_path
  end

  test "should get new" do
    login(@teacher)
    get new_course_path
    assert_response :success
  end

  test "should get new2" do
    login(@teacher)
    get courses_new2_path
    assert_response :success
  end

  test "should get edit" do
    login(@teacher)
    get edit_course_url(@course)
    assert_response :found
  end

  test "should get list" do
    login(@student)
    get list_courses_path
    assert_response :success
  end

  test "should post new course" do
    login(@teacher)
    post courses_path, params: { course: { name: @course.name, description: @course.description, weekday_one: @course.weekday_one, weekday_two: @course.weekday_two, start_time: @course.start_time, end_time: @course.end_time, course_code: "bbb111", capacity: @course.capacity, class_room: @course.class_room } }
    assert_response :found
  end

  test "should patch update course" do
    login(@teacher)
    post courses_path, params: { course: { name: @course.name, description: @course.description, weekday_one: @course.weekday_one, weekday_two: @course.weekday_two, start_time: @course.start_time, end_time: @course.end_time, course_code: "bbb111", capacity: @course.capacity, class_room: @course.class_room } }
    patch course_path(@course), params: { course: { name: "update name", description: @course.description, weekday_one: @course.weekday_one, weekday_two: @course.weekday_two, start_time: @course.start_time, end_time: @course.end_time, course_code: "bbb111", capacity: @course.capacity, class_room: @course.class_room } }
    assert_response :found
  end

  test "should delete course" do
    login(@teacher)
    post courses_path, params: { course: { name: @course.name, description: @course.description, weekday_one: @course.weekday_one, weekday_two: @course.weekday_two, start_time: @course.start_time, end_time: @course.end_time, course_code: "bbb111", capacity: @course.capacity, class_room: @course.class_room } }
    delete course_path(@course)
    assert_response :found
  end

  test "should select course" do
    login(@student)
    get select_course_path(id: @course.id)
    assert_response :found
  end

  test "should quit course" do
    login(@student)
    get select_course_path(id: @course.id)
    get quit_course_path(id: @course.id)
    assert_response :found
  end

  test "should not select closed course" do
    login(@student)
    get select_course_path(id: @course2.id)
    assert(flash[:notice] == 'This course is not available.')
  end

  test 'student should not be able to delete course' do
    login(@student)
    get select_course_path(id: @course.id)
    delete course_path(@course)
    assert(flash[:notice] == 'You are not authorized to access this page.')
  end

  test 'student should not be able to create course' do
    login(@student)
    get new_course_path
    post courses_path, params: { course: { name: @course.name, description: @course.description, weekday_one: @course.weekday_one, weekday_two: @course.weekday_two, start_time: @course.start_time, end_time: @course.end_time, course_code: "bbb111", capacity: @course.capacity, class_room: @course.class_room } }
    assert(flash[:notice] == 'You are not authorized to access this page.')
  end

  test 'student should not be able to update course' do
    login(@student)
    get edit_course_url(@course)
    patch course_path(@course), params: { course: { name: "update name", description: @course.description, weekday_one: @course.weekday_one, weekday_two: @course.weekday_two, start_time: @course.start_time, end_time: @course.end_time, course_code: "bbb111", capacity: @course.capacity, class_room: @course.class_room } }
    assert(flash[:notice] == 'You are not authorized to access this page.')
  end

  test 'student can not get edit ' do
    login(@student)
    get edit_course_url(@course)
    assert(flash[:notice] == 'You are not authorized to access this page.')
  end

  test 'student can not get new ' do
    login(@student)
    get new_course_path
    assert(flash[:notice] == 'You are not authorized to access this page.')
  end

  test 'student can not get new2 ' do
    login(@student)
    get courses_new2_path
    assert(flash[:notice] == 'You are not authorized to access this page.')
  end


end
