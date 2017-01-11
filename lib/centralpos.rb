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

  class << self
    def sandbox_wsdl_endpoint
      @@sandbox_wsdl_endpoint
    end

    def production_wsdl_endpoint
      @@production_wsdl_endpoint
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
  end
end
