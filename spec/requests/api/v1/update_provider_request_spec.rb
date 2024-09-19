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
      to_return(status: 200, body: "", headers: {})
    end
  
    after(:each) do
      WebMock.disable!  # Disable WebMock for the rest of the suite after this test
    end

    it "updates provider" do

      patch "/api/v1/providers/1"

      expect(response).to be_successful

    end
  end
end