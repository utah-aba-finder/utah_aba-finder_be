FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    encrypted_password { Faker::Internet.password(min_length: 8) }
    reset_password_token { nil }
    reset_password_sent_at { nil }
    remember_created_at { nil }
    jti { SecureRandom.uuid }
    provider_id { nil }  # Adjust as necessary depending on your associations
    role { 1 }  # Adjust default role as needed (1 = provider_admin, etc.)

    # Additional traits or customizations can be added
    trait :admin do
      role { 0 }  # Assuming role 0 is for admin users
    end

    trait :provider do
      provider_id { 1 }  # Set a valid provider_id, or link to a provider factory if required
    end
  end
end

