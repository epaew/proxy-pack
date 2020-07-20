# frozen_string_literal: true

require 'json'

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
          var targets = #{socks_proxy_targets};
          var proxySettingsString = "SOCKS #{public_id_address}:#{socks_proxy_port}";

          function FindProxyForURL(url, host) {
            if (targets.length == 0) {
              return proxySettingsString;
            } else if (targets.some(target => shExpMatch(host, target))) {
              return proxySettingsString;
            } else {
              return "DIRECT";
            }
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

      def socks_proxy_targets
        ENV.fetch('SOCKS_PROXY_TARGETS', '').split(',').to_json
      end
    end
  end
end
