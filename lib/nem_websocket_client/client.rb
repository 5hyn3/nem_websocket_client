module NemWebsocketClient

    def self.connect(url, port)
      client = ::NemWebsocketClient::Client.new(url,port)
      client.connect
      return client
    end

    class Client
      @@block_path = "/blocks"
      @@block_height_path = "/blocks/new"
      @@owned_namespace_path = "/account/namespace/owned/"
      @@owned_mosaic_path = "/account/mosaic/owned/"
      @@owned_mosaic_definition_path = "/account/mosaic/owned/definition/"
      @@transaction_path = "/transactions/"
      @@unconfirmed_transaction_path = "/unconfirmed/"
      @@recenttransactions_path = "/recenttransactions/"
      @@account_path = "/account/"

      @@send_owned_namespace_path = "/w/api/account/namespace/owned"
      @@send_owned_mosaic_path = "/w/api/account/mosaic/owned"
      @@send_owned_mosaic_definition_path = "/w/api/account/mosaic/owned/definition"
      @@send_recenttransactions_path = "/w/api/account/transfers/all"
      @@send_account_path = "/w/api/account/get"

      def initialize(url,port)
        host = url
        port = port
        path = "/w/messages/"
        server = format("%0#{3}d", SecureRandom.random_number(10**3))
        strings = [('a'..'z'), ('0'..'5')].map { |i| i.to_a }.flatten
        session = (0...8).map { strings[rand(strings.length)] }.join
        @endpoint = host + ":" + port.to_s + path + server.to_s + "/" +session + "/websocket/"
        @is_connected = false
        @sub_id_count = 0
      end

      def connected(&fun)
        @ws.connected_func = fun
      end

      def heatbeat(&fun)
        @ws.heatbeat_func = fun
      end

      def errors(&fun)
        @ws.errors_func = fun
      end

      def closed(&fun)
        @ws.closed_func = fun
      end

      def subscribe_block(&fun)
        @ws.subscribe_block_func = fun
        send_subscribe_stomp(@@block_path)
      end

      def subscribe_block_height(&fun)
        @ws.subscribe_block_height_func = fun
        send_subscribe_stomp(@@block_height_path)
      end

      def subscribe_owned_namespace(address,&fun)
        @ws.subscribe_owned_namespace_func = fun
        send_subscribe_stomp(@@owned_namespace_path + address)
      end

      def subscribe_owned_mosaic(address,&fun)
        @ws.subscribe_owned_mosaic_func = fun
        send_subscribe_stomp(@@owned_mosaic_path + address)
      end

      def subscribe_owned_mosaic_definition(address,&fun)
        @ws.subscribe_owned_mosaic_definition_func = fun
        send_subscribe_stomp(@@owned_mosaic_definition_path + address)
      end

      def subscribe_transaction(address,&fun)
        @ws.subscribe_transaction_func = fun
        send_subscribe_stomp(@@transaction_path + address)
      end

      def subscribe_unconfirmed_transaction(address,&fun)
        @ws.subscribe_unconfirmed_transaction_func = fun
        send_subscribe_stomp(@@unconfirmed_transaction_path + address)
      end

      def subscribe_recenttransactions(address,&fun)
        @ws.subscribe_recenttransactions_func = fun
        send_subscribe_stomp(@@recenttransactions_path + address)
      end

      def subscribe_account(address,&fun)
        @ws.subscribe_account_func = fun
        send_subscribe_stomp(@@account_path + address)
      end

      def request_account(address)
        send_send_stomp(@@send_account_path,address)
      end

      def request_owned_namespace(address)
        send_send_stomp(@@send_owned_namespace_path,address)
      end

      def request_owned_mosaic(address)
        send_send_stomp(@@send_owned_mosaic_path,address)
      end

      def request_owned_mosaic_definition(address)
        send_send_stomp(@@send_owned_mosaic_definition_path,address)
      end

      def request_recenttransactions(address)
        send_send_stomp(@@send_recenttransactions_path,address)
      end

      def close
        @ws.close
      end
    
      def connect
        @ws = WebSocket::Client::Simple.connect(@endpoint)
        ws_init
        @ws.on :error do |e|
          errors_func.call(e)
        end
        
        @ws.on :close do |e|
          closed_func.call(e)
        end

        @ws.on :open do
          connect_header = {"accept-version":"1.1,1.0","heart-beat":"10000,10000"}
          stomp_connect = '["' + StompParser::Frame.new("CONNECT", connect_header,"").to_str + '"]'
          send(stomp_connect)
        end

        @ws.on :message do |msg|
          if msg.data[0] == "o"

          end

          if msg.data[0] == "h"
            heatbeat_func.call
          end
          if msg.data[0] == "a"
            data = msg.data
            data.slice!(0,data.index("[")+2)
            data.slice!(data.rindex("]")-1,data.length)
            data.gsub!("\\n","\n")
            data.gsub!("\\r","\r")
            data.gsub!("\\/","\/")
            data.gsub!("\\u0000","\u0000")
            data.gsub!("\\\"","\"")
            parser = StompParser::Parser.new(1024 * 100)
            parser.parse(data) do |frame|
            if frame.command == "CONNECTED" 
              connected_func.call unless connected_func.nil?
              @is_connected = true
              unless subscribe_stomps.empty?
                subscribe_stomps.each do |stomp|
                  send(stomp)
                end
              end
              unless send_stomps.empty?
                send_stomps.each do |stomp|
                  send(stomp)
                end
              end
            end
            if frame.command == "MESSAGE"
              result = JSON.parse(frame.body)
              destination = frame.headers["destination"]
              address = destination.match(/\w{40}/)
              destination.slice!(address.to_s) unless address.nil?
              case destination
              when @@block_path
                subscribe_block_func.call(result)
              when @@block_height_path
                subscribe_block_height_func.call(result) 
              when @@unconfirmed_transaction_path
                subscribe_unconfirmed_transaction_func.call(result,address) 
              when @@recenttransactions_path
                subscribe_recenttransactions_func.call(result,address) 
              when @@account_path
                subscribe_account_func.call(result,address) 
              when @@owned_namespace_path
                subscribe_owned_namespace_func.call(result,address) 
              when @@owned_mosaic_path
                subscribe_owned_mosaic_func.call(result,address) 
              when @@owned_mosaic_definition_path
                subscribe_owned_mosaic_definition_func.call(result,address) 
              when @@transaction_path
                subscribe_owned_mosaic_func.call(result,address) 
              end
            end
          end
        end
      end
    end

    private
      def ws_init
        @ws.singleton_class.class_eval{ attr_accessor :connected_func }
        @ws.singleton_class.class_eval{ attr_accessor :subscribe_block_func }
        @ws.singleton_class.class_eval{ attr_accessor :heartbeat_func }
        @ws.singleton_class.class_eval{ attr_accessor :subscribe_block_height_func }
        @ws.singleton_class.class_eval{ attr_accessor :subscribe_owned_namespace_func }
        @ws.singleton_class.class_eval{ attr_accessor :subscribe_owned_mosaic_func }
        @ws.singleton_class.class_eval{ attr_accessor :subscribe_owned_mosaic_definition_func }
        @ws.singleton_class.class_eval{ attr_accessor :subscribe_transaction_func }
        @ws.singleton_class.class_eval{ attr_accessor :subscribe_unconfirmed_transaction_func }
        @ws.singleton_class.class_eval{ attr_accessor :subscribe_recenttransactions_func }
        @ws.singleton_class.class_eval{ attr_accessor :subscribe_account_func }
        @ws.singleton_class.class_eval{ attr_accessor :errors_func }
        @ws.singleton_class.class_eval{ attr_accessor :closed_func }
        @ws.singleton_class.class_eval{ attr_accessor :subscribe_stomps }
        @ws.singleton_class.class_eval{ attr_accessor :send_stomps }
        @ws.subscribe_stomps = []
        @ws.send_stomps = []
      end
      
      def generate_sub_id
        sub_id = "sub-" + @sub_id_count.to_s
        @sub_id_count += 1
        return sub_id
      end

      def generate_subscribe_stomp(path)
        header = {"id":generate_sub_id,"destination":path}
        stomp = '["' + StompParser::Frame.new("SUBSCRIBE", header, "").to_str + '"]'
        return stomp
      end

      def generate_send_stomp(path,address)
        header = {"destination":path}
        stomp = '["' + StompParser::Frame.new("SEND", header, "{'account':'#{address}'}").to_str + '"]'
        return stomp
      end

      def send_stomp(stomp)
        if @is_connected 
          @ws.send(stomp)
        else
          if stomp.include?("SUBSCRIBE")
            @ws.subscribe_stomps.push(stomp)
          elsif stomp.include?("SEND")
            @ws.send_stomps.push(stomp)
          end
        end
      end

      def send_subscribe_stomp(path)
        stomp = generate_subscribe_stomp(path)
        send_stomp(stomp)
      end

      def send_send_stomp(path,address)
        stomp = generate_send_stomp(path,address)
        send_stomp(stomp)
      end
  end
end