class EnrollmentsController < ApplicationController
  before_action :teacher_logged_in

  def index
    @course = Course.find(params[:course_id])
    if teacher_logged_in?
      if @course.teacher_id != current_user.id
        redirect_to root_path, notice: 'You are not authorized to access this page.'
        return
      end
    end
    @enrollments = @course.enrollments.paginate(page: params[:page], per_page: 4)
  end

  def destroy
    @enrollment = Enrollment.find(params[:id])
    @course = @enrollment.course
    if teacher_logged_in?
      if @course.teacher_id != current_user.id
        redirect_to root_path, notice: 'You are not authorized to access this page.'
        return
      end
    end
    @enrollment.destroy
    @course.student_num -= 1
    if @course.status == "CLOSED"
      @course.status = "OPEN"
    end
    @course.save
    flash[:success] = "Enrollment deleted"
    redirect_to enrollments_path(course_id: @course.id)
  end

  def new
    @course = Course.find(params[:course_id])
    if teacher_logged_in?
      if @course.teacher_id != current_user.id
        redirect_to root_path, notice: 'You are not authorized.'
        return
      end
    end
    @users = User.where(:admin => false).where(:teacher => false).where.not(:id => @course.users.pluck(:id)).paginate(page: params[:page], per_page: 10)

  end

  def create
    @course = Course.find(params[:course_id])
    if teacher_logged_in?
      if @course.teacher_id != current_user.id
        redirect_to root_path, notice: 'You are not authorized.'
      end
    end
    if @course.status == "CLOSED"
      redirect_to enrollments_path(course_id: @course.id), flash: { :warning => "Course is closed" }
    else
      @user = User.find(params[:user_id])
      @enrollment = @course.enrollments.build(:user_id => @user.id)
      if @enrollment.save
        @course.student_num += 1
        if @course.student_num == @course.capacity
          @course.status = "CLOSED"
        end
        @course.save
        flash[:success] = "Enrollment created"
        redirect_to enrollments_path(course_id: @course.id)
      else
        render 'new'
      end
    end

  end

  private

  def teacher_logged_in
    unless teacher_logged_in? || admin_logged_in?
      redirect_to root_url, flash: { danger: 'Please login first' }
    end
  end
end
