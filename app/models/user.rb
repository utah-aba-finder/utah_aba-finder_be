class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :recoverable,
         :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: { super_admin: 0, provider_admin: 1 }
end