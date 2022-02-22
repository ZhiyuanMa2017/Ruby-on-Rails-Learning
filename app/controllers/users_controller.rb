class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    if !admin_logged_in?
      redirect_to root_path
    else
      @users = User.all
    end
  end

  #
  # # GET /users/1 or /users/1.json
  # def show
  # end

  # GET /users/new
  def new
    if !logged_in? || current_user.admin?
      @user = User.new
    else
      redirect_to root_path
    end
  end

  def new2
    if !logged_in? || current_user.admin?
      @user = User.new
    else
      redirect_to root_path
    end
  end

  # GET /users/1/edit
  def edit
    if !admin_logged_in?
      redirect_to root_path
    else
      @user = User.find(params[:id])
    end
  end

  # POST /users or /users.json
  def create
    if !logged_in? || current_user.admin?
      @user = User.new(user_params)
      t = user_params[:teacher]
      respond_to do |format|
        if @user.save
          if t
            format.html { redirect_to root_url, notice: "Instructor was successfully created." }
          else
            format.html { redirect_to root_url, notice: "Student was successfully created." }
          end
          format.json { render :show, status: :created, location: @user }
        else
          if t
            format.html { render :new }
          else
            format.html { render :new2 }
          end
          # format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if admin_logged_in?
      respond_to do |format|

        if @user.update(user_params)
          format.html { redirect_to root_path, notice: "User was successfully updated." }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, notice: "You must log in as a admin." }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if admin_logged_in?
      if @user.admin == true
        respond_to do |format|
          format.html { redirect_to users_url, notice: "You can not delete admin account" }
          format.json { head :no_content }
        end
      else
        if @user.teacher
          @user.teaching_courses.each do |course|
            course.destroy
          end
        else
          @enrollments = @user.enrollments
          @enrollments.each do |enrollment|
            @course = Course.find(enrollment.course_id)
            @course.student_num -= 1
            if @course.status == "CLOSED"
              @course.status = "OPEN"
            end
            @course.save
          end
        end

        @user.destroy

        respond_to do |format|
          format.html { redirect_to users_url, notice: "User was successfully destroyed." }
          format.json { head :no_content }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to users_url, notice: "You must log in as asmin" }
        format.json { head :no_content }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :major, :department, :phone_number, :birthday, :teacher)
  end

end

