require "test_helper"

class Centralpos::Core::GatewayTest < Minitest::Test

  # def test_constants_present
  #   assert_instance_of String, Centralpos::Core::Gateway::SANDBOX_WSDL_URL
  #   assert_instance_of String, Centralpos::Core::Gateway::PRODUCTION_WSDL_URL
  # end

  def test_sandbox_by_default
    @gateway = Centralpos::Core::Gateway.new("username", "password")

    assert_equal :sandbox, @gateway.mode
  end

  # def test_live_initialize
  #   @gateway = Centralpos::Core::Gateway.new("username", "password", :live)

  #   assert_equal :live, @gateway.mode
  #   assert_equal Centralpos::Core::Gateway::PRODUCTION_WSDL_URL, @gateway.send(:wsdl_endpoint)
  # end

  # def test_live_initialize_change_to_sandbox
  #   @gateway = Centralpos::Core::Gateway.new("username", "password", :live)
  #   @gateway.sandbox

  #   assert_equal :sandbox, @gateway.mode
  #   assert_equal Centralpos::Core::Gateway::SANDBOX_WSDL_URL, @gateway.send(:wsdl_endpoint)
  # end

  def test_when_change_mode_client_is_reset
    @gateway = Centralpos::Core::Gateway.new("username", "password", :live)
    @gateway.send(:client)
    refute_nil @gateway.instance_variable_get(:@client)

    @gateway.sandbox
    assert_nil @gateway.instance_variable_get(:@client)
  end

  def test_respond_to_call
    @gateway = Centralpos::Core::Gateway.new("username", "password")

    assert_respond_to @gateway, :call
  end

end
