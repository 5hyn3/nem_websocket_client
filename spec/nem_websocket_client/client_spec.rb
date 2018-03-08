require 'spec_helper'

RSpec.describe NemWebsocketClient::Client do
  host = "http://23.228.67.85"
  port = 7778 
  test_address = "TBW4BPO7EDYFN3GDGFQW7DXTYNPCD4AKDJUU5PDC"
  it "can connect" do
    EM::run{
      connected = false
      EM::add_timer 1 do
        ws = NemWebsocketClient.connect(host,port)
        ws.connected do
          connected = true
        end
      end
      EM::add_timer 3 do
        expect(connected).to be true
        EM.stop
      end
    }
  end
  
  it "get account" do
    EM::run{
      can_get_account = false
      EM::add_timer 1 do
        ws = NemWebsocketClient.connect(host,port)
        ws.subscribe_account(test_address) do |account,address|
          can_get_account = true
        end
        ws.request_account(test_address)
      end
      EM::add_timer 3 do
        expect(can_get_account).to be true
        EM.stop
      end
    }
  end
end

