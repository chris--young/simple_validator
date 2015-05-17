require_relative "validation"
require "test/unit"

$validator = Validation.new

class ValidationTest < Test::Unit::TestCase
  def test0
    hash = { :a => 97 }
    keys = { :required => [{ :key => :a, :type => Integer }] }

    assert_raise(ArgumentError) { $validator.check_hash("foo", "bar") }
    assert_raise(ArgumentError) { $validator.check_hash(hash, "bar") }
    assert_raise(ArgumentError) { $validator.check_hash("foo", keys) }
  end

  def test1
    hash = { :a => 97, :b => 98 }
    keys = { :required => [{ :key => :a, :type => Integer }],
             :protected => [{ :key => :b, :type => Integer }] }

    assert_raise(ArgumentError) { $validator.check_hash(hash, keys) }
  end

  def test2
    hash = { :a => 97 }
    keys = { :required => 97 }

    assert_raise(TypeError) { $validator.check_hash(hash, keys) }
  end

  def test3
    error = { :missing => [:d] }
    hash = { :a => 97, :b => 98, :c => 99 }
    keys = { :required => [{ :key => :a, :type => Integer },
                           { :key => :b, :type => Integer },
                           { :key => :c, :type => Integer },
                           { :key => :d, :type => Integer }] }

    assert_equal(error, $validator.check_hash(hash, keys))
  end

  def test4
    error = { :unknown => [:d] }
    hash = { :a => 97, :b => 98, :c => 99, :d => 100 }
    keys = { :required => [{ :key => :a, :type => Integer }, { :key => :b, :type => Integer }, { :key => :c, :type => Integer }] }

    assert_equal(error, $validator.check_hash(hash, keys))
  end

  def test5
    error = { :unknown => [:d], :missing => [:c] } 
    hash = { :a => 97, :b => 98, :d => 100 }
    keys = { :required => [{ :key => :a, :type => Integer }, { :key => :b, :type => Integer }, { :key => :c, :type => Integer }] }

    assert_equal(error, $validator.check_hash(hash, keys))
  end

  def test6
    error = nil
    hash = { :a => 97, :b => 98 }
    keys = { :required => [{ :key => :a, :type => Integer }, { :key => :b, :type => Integer }],
             :optional => [{ :key => :c, :type => Integer }] }

    assert_equal(error, $validator.check_hash(hash, keys))
  end

  def test7
    error = nil
    hash = { :a => 97, :b => 98, :c => 99 }
    keys = { :required => [{ :key => :a, :type => Integer }, { :key => :b, :type => Integer }],
             :optional => [{ :key => :c, :type => Integer }] }

    assert_equal(error, $validator.check_hash(hash, keys))
  end

  def test8
    error = nil
    hash = { :a => 97 }
    constraints = { :required => [ { :key => :a, :type => Integer } ] }

    assert_equal(nil, $validator.check_hash(hash, constraints))
  end

  def test9
    error = { :unknown => [:b] }
    hash = { :a => 97, :b => 98 }
    constraints = { :required => [ { :key => :a, :type => Integer } ] }

    assert_equal(error, $validator.check_hash(hash, constraints))
  end

  def test10
    error = { :missing => [:b] }
    hash = { :a => 97 }
    constraints = { :required => [{ :key => :a, :type => Integer }, { :key => :b, :type => Integer }] }

    assert_equal(error, $validator.check_hash(hash, constraints))
  end

  def test11
    error = { :invalid => [:b] }
    hash = { :a => 97, :b => 98}
    constraints = { :required => [{ :key => :a, :type => Integer }, { :key => :b, :type => String }] }

    assert_equal(error, $validator.check_hash(hash, constraints))
  end

  def test12
    error = nil
    hash = { :a => 97, :b => "98"}
    constraints = { :required => [{ :key => :a, :type => Integer }, { :key => :b, :type => Integer }] }

    assert_equal(error, $validator.check_hash(hash, constraints, true))
  end
    
end

