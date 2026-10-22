module Admin
  class UsersController < ApplicationController
    access "Only admins can manage users.", admin: :all

    before_action :set_user, only: [ :edit, :update ]

    def index
      @users = User.order(:email)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to admin_users_path, notice: "Account created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @user.update(account_params)
        redirect_to admin_users_path, notice: "Account updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :role)
      end

      # A blank password on edit keeps the current one.
      def account_params
        permitted = user_params
        if permitted[:password].blank?
          permitted.except(:password, :password_confirmation)
        else
          permitted
        end
      end
  end
end
