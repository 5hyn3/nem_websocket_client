require 'spec_helper'

RSpec.describe NemWebsocketClient do
  it "can connected" do
    host = "http://alice3.nem.ninja"
    port = 7778 
    EM::run{
      EM::add_timer 1 do
        EM.stop
        ws = NemWebsocketClient.connect(host,port)
        ws.on :connected do
            EM.stop_event_loop
        end
      end
    }
  end
end

