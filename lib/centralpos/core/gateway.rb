module Centralpos
  module Core
    class Gateway
      attr_reader :mode

      def initialize(username, password, mode = :sandbox)
        @username = username
        @password = password
        @mode = mode
      end

      def call(method, extra_data = {})
        message = authentication_params.merge(extra_data)

        response = client.call(method, message: message)

        parse_result(response, method)
      rescue Savon::Error, Errno::ENETUNREACH => error
        handle_exception(error)
      end

      def sandbox
        @client = nil
        @mode = :sandbox
      end

      def live
        @client = nil
        @mode = :live
      end

      private

      def client
        @client ||= Savon.client(opts)
      end

      def opts
        { wsdl: wsdl_endpoint }.merge(Centralpos::Core::Logger.options)
      end

      def wsdl_endpoint
        case @mode
        when :live then Centralpos.production_wsdl_endpoint
        when :sandbox then Centralpos.sandbox_wsdl_endpoint
        else
          Centralpos.sandbox_wsdl_endpoint
        end
      end

      def authentication_params
        {
          "Autenticacion" => {
            "Usuario" => @username,
            "Clave" => @password
          }
        }
      end

      def parse_result(response, method)
        body = parse_body(response, method)

        successful_response(response).merge(result: body)
      end

      def parse_body(response, method)
        method_response = "#{method}_response".to_sym
        method_result = "#{method}_result".to_sym

        response.body[method_response][method_result]
      end

      def handle_exception(error)
        case error
        when Savon::SOAPFault
          failed_response(error).merge(error: error.to_hash[:fault])
        when Savon::HTTPError
          failed_response(error).merge(error: error.to_hash)
        when Errno::ENETUNREACH
          failed_response(error).merge(error: error.to_hash)
        else
          raise error
        end
      end

      def successful_response(response)
        {
          response_code: response.http.code,
          success: true,
          error: nil
        }
      end

      def failed_response(error)
        {
          response_code: error.http.code,
          success: false,
          result: nil
        }
      end
    end
  end
end
