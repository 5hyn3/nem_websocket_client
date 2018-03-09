require 'spec_helper'

RSpec.describe NemWebsocketClient do
  it "has a version number" do
    expect(NemWebsocketClient::VERSION).not_to be nil
  end
end
