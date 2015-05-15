class SimpleValidation
  def check_hash_keys(hash, keys)
    raise ArgumentError unless hash.is_a?(Hash)
    check_keys(keys)

    unknown = []
    missing = []

    hash.each_key do |key|
      if !keys[:required].include?(key) && !keys[:optional].include?(key)
        unknown << key
      end
    end

    keys[:required].each do |key|
      if !hash.include?(key)
        missing << key
      end
    end

    if !unknown.empty? && !missing.empty?
      { :unknown => unknown, :missing => missing }
    elsif !unknown.empty?
      { :unknown => unknown }
    elsif !missing.empty?
      { :missing => missing }
    end
  end

  private
  def check_keys(keys)
    raise ArgumentError unless keys.is_a?(Hash)

    constraints = [:required, :optional]

    keys.each_key do |key|
      raise ArgumentError unless constraints.include?(key)
      raise TypeError unless keys[key].is_a?(Array)
    end

    constraints.each do |constraint|
      if !keys.has_key?(constraint)
        keys[constraint] = []
      end
    end
  end
end

