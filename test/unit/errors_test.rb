require "test_helper"

class Centralpos::ErrorsTest < Minitest::Test

  def test_error_class_exists
    assert_equal "constant", defined?(Centralpos::Error)
    assert Centralpos::Error.is_a?(Class)
    assert_equal Centralpos::Error.superclass, StandardError
  end

  def test_account_error_class_exists_and_inherits_from_centralpos_error
    assert_equal "constant", defined?(Centralpos::AccountError)
    assert Centralpos::AccountError.is_a?(Class)
    assert_equal Centralpos::AccountError.superclass, Centralpos::Error
  end
end
