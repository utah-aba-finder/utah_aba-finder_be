class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :recoverable,
         :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: { super_admin: 0, provider_admin: 1 }

  # provider_id is required for provider_admin roles, add:
  validates :provider_id, presence: true, if: :requires_provider_id?
  validates :provider_id, numericality: { only_integer: true }, allow_nil: true

  private

  def requires_provider_id?
    provider_admin?
    # example for when we have new role that require provider_id
    # provider_admin? || other_role? || another_role?
  end
end