# SUPPORT LIBS
require "savon"
require "erb"
require "ostruct"

require "centralpos/version"
require "centralpos/errors"
require "centralpos/utils"
# CORE
require "centralpos/core/errors"
require "centralpos/core/logger"
require "centralpos/core/gateway"
# RESOURCES
require "centralpos/account"
require "centralpos/batch"
require "centralpos/transaction"

module Centralpos
  @@sandbox_wsdl_endpoint = ''
  @@production_wsdl_endpoint = ''
  @@override_timezone = true
  @@default_timezone = '-0300'

  class << self
    def sandbox_wsdl_endpoint
      @@sandbox_wsdl_endpoint
    end

    def production_wsdl_endpoint
      @@production_wsdl_endpoint
    end

    def override_timezone
      @@override_timezone
    end

    def default_timezone
      @@default_timezone
    end

    def setup
      yield self
    end

    def sandbox_wsdl_endpoint=(url_string)
      @@sandbox_wsdl_endpoint = url_string
    end

    def production_wsdl_endpoint=(url_string)
      @@production_wsdl_endpoint = url_string
    end

    def override_timezone=(value)
      @@override_timezone = value.is_a?(Boolean) ? value : true
    end

    def default_timezone=(value)
      @@default_timezone = value
    end
  end
end
