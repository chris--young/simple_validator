require_relative "simple_validation"
require "test/unit"

$validator = SimpleValidation.new

class SimpleValidationTest < Test::Unit::TestCase
  def test
    hash = { :a => 97 }
    keys = { :required => [{ :key => :a }] }

    assert_raise(ArgumentError) { $validator.check_hash_keys("foo", "bar") }
    assert_raise(ArgumentError) { $validator.check_hash_keys(hash, "bar") }
    assert_raise(ArgumentError) { $validator.check_hash_keys("foo", keys) }

    hash = { :a => 97, :b => 98 }
    keys = { :required => [:a], :protected => [:b] }

    assert_raise(ArgumentError) { $validator.check_hash_keys(hash, keys) }

    hash = { :a => 97 }
    keys = { :required => 97 }

    assert_raise(TypeError) { $validator.check_hash_keys(hash, keys) }

    hash = { :a => 97, :b => 98, :c => 99 }
    keys = { :required => [:a, :b, :c, :d] }
    error = { :missing => [:d] }

    assert_equal(error, $validator.check_hash_keys(hash, keys))

    hash = { :a => 97, :b => 98, :c => 99, :d => 100 }
    keys = { :required => [:a, :b, :c] }
    error = { :unknown => [:d] }

    assert_equal(error, $validator.check_hash_keys(hash, keys)) 

    hash = { :a => 97, :b => 98, :d => 100 }
    keys = { :required => [:a, :b, :c] }
    error = { :unknown => [:d], :missing => [:c] } 

    assert_equal(error, $validator.check_hash_keys(hash, keys))

    hash = { :a => 97, :b => 98 }
    keys = { :required => [:a, :b], :optional => [:c] }
    error = nil

    assert_equal(error, $validator.check_hash_keys(hash, keys))

    hash = { :a => 97, :b => 98, :c => 99 }
    keys = { :required => [:a, :b], :optional => [:c] }
    error = nil

    assert_equal(error, $validator.check_hash_keys(hash, keys))
  end
end

