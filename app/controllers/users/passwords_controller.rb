class Users::PasswordsController < Devise::PasswordsController

  def edit
    render :edit
  end

  def update
    super
  end
end