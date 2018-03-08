require 'spec_helper'

RSpec.describe NemWebsocketClient do
  it "has a version number" do
    expect(NemWebsocketClient::VERSION).not_to be nil
  end
  
  it "can connected" do
    host = "http://alice3.nem.ninja"
    port = 7778 
    EM::run{
      EM::add_timer 1 do
        ws = NemWebsocketClient.connect(host,port)
        ws.on :connected do
            p "Connected!"
            EM::stop_event_loop
        end
      end
    }
  end
end
