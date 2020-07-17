# frozen_string_literal: true

module ProxyPack
  class App
    class << self
      def call(env)
        request = Rack::Request.new(env)

        case request.path
        when '/proxy.pac'
          [200, {}, [proxy_pac]]
        else
          [404, {}, []]
        end
      end

      private

      def proxy_pac
        <<~__EOF__
          function FindProxyForURL(url, host) {
            return "SOCKS #{public_id_address}:#{socks_proxy_port}"
          }
        __EOF__
      end

      def network_interface_name
        ENV['NETWORK_INTERFACE'] || 'eth0'
      end

      def public_id_address
        Socket
          .getifaddrs
          .select { |ifaddr| ifaddr.name == network_interface_name && ifaddr.addr.ipv4? }
          .first
          .addr
          .ip_address
      end

      def socks_proxy_port
        ENV['SOCKS_PROXY_PORT']
      end
    end
  end
end
