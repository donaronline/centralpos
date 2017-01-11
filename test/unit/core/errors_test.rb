require "test_helper"

class Centralpos::Core::ErrorsTest < Minitest::Test

  def test_client_error_class_exists_and_inherits_from_centralpos_error
    assert_equal "constant", defined?(Centralpos::Core::ClientError)
    assert Centralpos::Core::ClientError.is_a?(Class)
    assert_equal Centralpos::Core::ClientError.superclass, Centralpos::Error
  end

end
