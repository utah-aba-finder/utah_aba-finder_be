class UtahAbaFinderService
  def self.conn
    # need to get real url
    # Faraday.new(url: "https://c9d8bfc6-16f1-40be-9dff-f69da7621219.mock.pstmn.io") do |faraday|
    Faraday.new(url: "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com") do |faraday|
    end
  end

  def self.get_providers
    # response = conn.get("/api/v1/providers")
    response = conn.get("/api/v1/providers")
    # binding.pry
    JSON.parse(response.body, symbolize_names: true)
  end

end