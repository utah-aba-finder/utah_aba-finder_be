class UtahAbaFinderService
  def self.conn
    # postman mock server
    # Faraday.new(url: "https://c9d8bfc6-16f1-40be-9dff-f69da7621219.mock.pstmn.io") do |faraday|
    Faraday.new(url: "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com") do |faraday|
      faraday.headers[:Authorization] = ENV['ABA_API_KEY'] || Rails.application.credentials.aba[:api_key]
    #localhost server
    # Faraday.new(url: "http://localhost:4000") do |faraday|
      # faraday.headers[:Authorization] = ENV['ABA_API_KEY'] || Rails.application.credentials.localhost[:api_key]
      faraday.headers['Content-Type'] = 'application/json'
    end
  end

  def self.get_providers
    response = conn.get("/api/v1/providers")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_providers_for_admin
    response = conn.get("/api/v1/admin/providers")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_provider(id)
    response = conn.get("/api/v1/providers/#{id}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.update_provider(id, provider_data)
    response = conn.patch("/api/v1/providers/#{id}") do |req|
    req.body = provider_data.to_json
  end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.create_provider(provider_data)
    response = conn.post("/api/v1/providers") do |req|
    req.body = provider_data.to_json
  end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_states
    response = conn.get("/api/v1/states")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_counties_by_state(state_id)
    response = conn.get("/api/v1/states/#{state_id}/counties")
    JSON.parse(response.body, symbolize_names: true)
  end
end