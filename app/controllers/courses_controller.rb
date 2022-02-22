class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses or /courses.json
  def index
    # @courses = Course.all
    @courses = Course.paginate(page: params[:page], per_page: 100) if admin_logged_in?
    @courses = current_user.teaching_courses.paginate(page: params[:page], per_page: 4) if teacher_logged_in?
    @courses = current_user.courses.paginate(page: params[:page], per_page: 4) if student_logged_in?
  end

  # GET /courses/1 or /courses/1.json
  # def show
  # end

  # GET /courses/new
  def new
    unless logged_in?
      redirect_to sessions_login_path
      return
    end
    if student_logged_in?
      redirect_to courses_path, notice: 'You are not authorized to access this page.'
    end
    @course = Course.new
  end

  def new2
    unless logged_in?
      redirect_to sessions_login_path
      return
    end
    if student_logged_in?
      redirect_to courses_path, notice: 'You are not authorized to access this page.'
    end
    if User.where(:teacher => true).count == 0
      redirect_to new_user_path, notice: 'Please create a instructor first.'
    end
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
    unless admin_logged_in? || @course.teacher_id == current_user.id
      redirect_to courses_path, notice: 'You are not authorized to access this page.'
    end
  end

  # POST /courses or /courses.json
  def create
    if teacher_logged_in?
      @course = Course.new(course_params)
      respond_to do |format|
        if @course.save
          current_user.teaching_courses << @course
          format.html { redirect_to courses_path, notice: "Course was successfully created." }
          # format.json { render :show, status: :created, location: @course }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      end
    elsif admin_logged_in?
      @user = User.find(course_params2[:teacher_id])
      course_params2.delete(:teacher_id)
      @course = Course.new(course_params2)
      respond_to do |format|
        if @course.save
          @user.teaching_courses << @course
          format.html { redirect_to courses_path, notice: "Course was successfully created." }
          # format.json { render :show, status: :created, location: @course }
        else
          format.html { render :new2, status: :unprocessable_entity }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    if admin_logged_in? || @course.teacher_id == current_user.id
      respond_to do |format|
        if @course.update(course_params)
          format.html { redirect_to courses_path, notice: "Course was successfully updated." }
          # format.json { render :show, status: :ok, location: @course }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to courses_path, notice: 'You are not authorized to access this page.'
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course = Course.find_by_id(params[:id])

    if @course.teacher_id == current_user.id || admin_logged_in?
      current_user.teaching_courses.delete(@course)
      @course.destroy
      respond_to do |format|
        format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      redirect_to courses_path, notice: 'You are not authorized to access this page.'
    end
  end

  #for student
  def list
    if student_logged_in?
      @courses = Course.where(:status => "OPEN").where.not(:id => current_user.courses.pluck(:id)).paginate(page: params[:page], per_page: 4)
    else
      redirect_to courses_path, notice: 'You are not authorized to access this page.'
    end
  end

  def select
    if student_logged_in?
      @course = Course.find_by_id(params[:id])
      if @course.status == "CLOSED"
        redirect_to courses_path, notice: 'This course is not available.'
      else
        current_user.courses << @course
        @course.student_num += 1
        if @course.student_num == @course.capacity
          @course.status = "CLOSED"
        end
        @course.save
        flash = { :suceess => "Successfully enroll in the course: #{@course.name}" }
        redirect_to courses_path, flash: flash
      end
    else
      redirect_to courses_path, notice: 'You are not authorized to access this page.'
    end
  end

  def quit
    if student_logged_in?
      @course = Course.find_by_id(params[:id])
      current_user.courses.delete(@course)
      @course.student_num -= 1
      if @course.status == 'CLOSED'
        @course.status = "OPEN"
      end
      @course.save
      flash = { :success => "Successfully quit the course: #{@course.name}" }
      redirect_to courses_path, flash: flash
    else
      redirect_to courses_path, notice: 'You are not authorized to access this page.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(:name, :description, :weekday_one, :weekday_two, :start_time, :end_time, :course_code, :capacity, :status, :class_room)
  end

  def course_params2
    params.require(:course).permit(:name, :description, :weekday_one, :weekday_two, :start_time, :end_time, :course_code, :capacity, :status, :class_room, :teacher_id)
  end
end
