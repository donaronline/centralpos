require 'test_helper'

class Centralpos::UtilsTest < Minitest::Test
  def setup
    @test_obj = Object.new
    @test_obj.extend(Centralpos::Utils)
  end

  def test_inspect_of_empty_attr_inspect
    assert_equal "#<Object >", @test_obj.inspect
  end

  def test_inspect_with_attr_inspect
    class << @test_obj
      def value1
        "hello"
      end
      def value2
        "bye"
      end
      def attr_inspect
        [ :value1, :value2 ]
      end
    end

    assert_equal "#<Object value1: \"hello\", value2: \"bye\">", @test_obj.inspect
  end

  def test_ensure_array_with_string
    assert_equal ["string"], @test_obj.ensure_array("string")
  end

  def test_ensure_array_with_numeric
    assert_equal [3], @test_obj.ensure_array(3)
  end

  def test_ensure_array_with_hash
    assert_equal [{ key1: 1, key2: 2}], @test_obj.ensure_array({ key1: 1, key2: 2})
  end

  def test_ensure_array_with_array
    assert_equal ["value1", "value2"], @test_obj.ensure_array(["value1", "value2"])
  end

  def test_ensure_array_with_array_of_hashes
    assert_equal [{ key1: 1, key2: 2}, { key3: 3, key4: 4}], @test_obj.ensure_array([{ key1: 1, key2: 2}, { key3: 3, key4: 4}])
  end
end
