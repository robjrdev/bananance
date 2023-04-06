class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
				@user.save
				redirect_to sign_in_path
    else
      #flash.now[:notice] = @user.errors.full_messages.to_sentence
       render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end
  

  def update_status
    @user = User.find(params[:id])
    
    if @user.status == 'pending'
     @user.update_attribute(:status, 'approved')
      redirect_to admin_path
    elsif
      @user.update_attribute(:status, 'pending')
      redirect_to admin_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to admin_path
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name)
  end
end
