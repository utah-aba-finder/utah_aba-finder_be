class Users::PasswordsController < Devise::PasswordsController

  def edit
    render :edit
  end

  def update
    super
  end
end
# class Users::PasswordsController < Devise::PasswordsController
#   respond_to :json

#   def create
#     self.resource = resource_class.send_reset_password_instructions(resource_params)
#     if successfully_sent?(resource)
#       render json: { status: 'ok', message: 'Reset password instructions sent' }
#     else
#       render json: { status: 'error', message: resource.errors.full_messages.join(', ') }
#     end
#   end

#   def update
#     self.resource = resource_class.reset_password_by_token(resource_params)
#     if resource.errors.empty?
#       render json: { status: 'ok', message: 'Password has been reset' }
#     else
#       render json: { status: 'error', message: resource.errors.full_messages.join(', ') }
#     end
#   end
# end