require "rails_helper"

RSpec.describe "Update Provider Request", type: :request do
  context "patch /api/v1/provider/:id" do
    before(:each) do
      WebMock.enable!  # Ensure WebMock is enabled only in this file or test
      stub_request(:patch, "https://utah-aba-finder-api-c9d143f02ce8.herokuapp.com/api/v1/providers/1").
      with(
        headers: {
       'Accept'=>'*/*',
       'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       'Authorization'=>'be6205db57ce01863f69372308c41e3a',
       'User-Agent'=>'Faraday v2.10.0'
        }).
      to_return(status: 200, body: { success: true }.to_json, headers: { 'Content-Type' => 'application/json' })
    end
  
    after(:each) do
      WebMock.disable!  # Disable WebMock for the rest of the suite after this test
    end

    it "updates provider" do
      patch "/api/v1/providers/1", params: {
        data: {
          id: 1,
          type: "provider",
          attributes: {
            name: "Updated Provider Name"
          }
        }
      }.to_json, headers: { 'Content-Type' => 'application/json', 'Authorization' => 'be6205db57ce01863f69372308c41e3a' }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response[:success]).to be true
    end
  end
end