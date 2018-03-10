require 'spec_helper'

RSpec.describe NemWebsocketClient::Client do
  host = "http://23.228.67.85"
  port = 7778 
  test_address = "TBW4BPO7EDYFN3GDGFQW7DXTYNPCD4AKDJUU5PDC"
  sub_test_address = "TAQSW32FHHWR3MAQYR6RVZL2IFGRPHBN5QKKUN7C"

  it "can connect" do
    EM::run{
      connected = false
      EM::add_timer 0 do
        ws = NemWebsocketClient.connect(host,port)
        ws.connected do
          connected = true
        end
      end
      EM::add_timer 2 do
        expect(connected).to be true
        EM.stop
      end
    }
  end
  
  it "get account" do
    EM::run{
      can_get_account = false
      EM::add_timer 0 do
        ws = NemWebsocketClient.connect(host,port)
        ws.subscribe_account(test_address) do |account,address|
          can_get_account = true
        end
        ws.request_account(test_address)
      end
      EM::add_timer 2 do
        expect(can_get_account).to be true
        EM.stop
      end
    }
  end

  xit "get owned namespace" do
    EM::run{
      can_get_owned_namespace = false
      EM::add_timer 0 do
        ws = NemWebsocketClient.connect(host,port)
        ws.subscribe_owned_namespace(test_address) do |owned_namespace,address|
          can_get_owned_namespace = true
        end
        ws.request_owned_namespace(test_address)
      end
      EM::add_timer 2 do
        expect(can_get_owned_namespace).to be true
        EM.stop
      end
    }
  end

  it "get owned mosaic" do
    EM::run{
      can_get_owned_mosaic = false
      EM::add_timer 0 do
        ws = NemWebsocketClient.connect(host,port)
        ws.subscribe_owned_mosaic(test_address) do |owned_mosaic,address|
          can_get_owned_mosaic = true
        end
        ws.request_owned_mosaic(test_address)
      end
      EM::add_timer 2 do
        expect(can_get_owned_mosaic).to be true
        EM.stop
      end
    }
  end

  it "get owned mosaic definition" do
    EM::run{
      can_get_owned_mosaic_definition = false
      EM::add_timer 0 do
        ws = NemWebsocketClient.connect(host,port)
        ws.subscribe_owned_mosaic_definition(test_address) do |owned_mosaic_definition,address|
          can_get_owned_mosaic_definition = true
        end
        ws.request_owned_mosaic_definition(test_address)
      end
      EM::add_timer 2 do
        expect(can_get_owned_mosaic_definition).to be true
        EM.stop
      end
    }
  end

  it "get recenttransactions" do
    EM::run{
      can_get_recenttransactions = false
      EM::add_timer 0 do
        ws = NemWebsocketClient.connect(host,port)
        ws.subscribe_recenttransactions(test_address) do |recenttransactions,address|
          can_get_recenttransactions = true
        end
        ws.request_recenttransactions(test_address)
      end
      EM::add_timer 2 do
        expect(can_get_recenttransactions).to be true
        EM.stop
      end
    }
  end

  it "get some account" do
    EM::run{
      can_get_test_address = false
      can_get_sub_test_address = false


      EM::add_timer 0 do
        ws = NemWebsocketClient.connect(host,port)
        ws.subscribe_account(test_address) do |account,address|
          can_get_test_address = test_address == address
        end

        ws.subscribe_account(sub_test_address) do |account,address|
          can_get_sub_test_address = sub_test_address == address
        end

        ws.request_account(test_address)
        ws.request_account(sub_test_address)
      end

      EM::add_timer 2 do
        expect(can_get_test_address).to be true
        expect(can_get_sub_test_address).to be true
        EM.stop
      end
    }
  end

  it "can close" do
    EM::run{
      can_close = false
      ws = NemWebsocketClient.connect(host,port)
      EM::add_timer 0 do
        ws.closed do
          can_close = true
        end
      end
      EM::add_timer 1 do
        ws.close
      end
      EM::add_timer 3 do
        expect(can_close).to be true
        EM.stop
      end
    }
  end
end

