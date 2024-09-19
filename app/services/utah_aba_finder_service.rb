class UtahAbaFinderService
  def self.conn
    # Faraday.new(url: "https://c9d8bfc6-16f1-40be-9dff-f69da7621219.mock.pstmn.io") do |faraday|
    Faraday.new(url: "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com") do |faraday|
      faraday.headers[:Authorization] = ENV['ABA_API_KEY'] || Rails.application.credentials.aba[:api_key]
    end
  end

  def self.get_providers
    response = conn.get("/api/v1/providers")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_provider(id)
    response = conn.get("/api/v1/providers/#{id}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.update_provider(id, provider_data)
    response = conn.patch("/api/v1/providers/#{id}") do |req|
      req.body = provider_data
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end