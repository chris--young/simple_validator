class SimpleValidation
  def check_hash(hash, constraints)
    raise ArgumentError unless hash.is_a?(Hash)
    check_hash_constraints(constraints)

    unknown = []
    missing = []
    invalid = []

    constraints[:required].each do |constraint|
      if hash.has_key?(constraint[:key])
        if !hash[constraint[:key]].is_a?(constraint[:type])
          invalid << constraint[:key]
        end
      else
        missing << constraint[:key]
      end
    end

    hash.each_key do |key|
      required = constraints[:required].any? { |constraint| key == constraint[:key] }
      optional = constraints[:optional].any? { |constraint| key == constraint[:key] }

      if !required && !optional
        unknown << key
      end
    end

    case
    when !invalid.empty? && !unknown.empty? && !missing.empty?
      { :invalid => invalid, :unknown => unknown, :missing => missing }
    when !invalid.empty? && !unknown.empty?
      { :invalid => invalid, :unknown => unknown }
    when !invalid.empty? && !missing.empty?
      { :invalid => invalid, :missing => missing }
    when !unknown.empty? && !missing.empty?
      { :unknown => unknown, :missing => missing }
    when !unknown.empty?
      { :unknown => unknown }
    when !missing.empty?
      { :missing => missing }
    when !invalid.empty?
      { :invalid => invalid }
    end
  end

  private
  def check_hash_constraints(constraints)
    raise ArgumentError unless constraints.is_a?(Hash)

    allowed = [:required, :optional]

    constraints.each_key do |key|
      raise ArgumentError unless allowed.include?(key)
      raise TypeError unless constraints[key].is_a?(Array)

      constraints[key].each do |constraint|
        raise ArgumentError unless constraint.has_key?(:key) && constraint.has_key?(:type)
        raise TypeError unless constraint[:key].is_a?(Symbol)
        raise TypeError unless constraint[:type].is_a?(Class)
      end
    end

    allowed.each do |constraint|
      if !constraints.has_key?(constraint)
        constraints[constraint] = []
      end
    end
  end
end

