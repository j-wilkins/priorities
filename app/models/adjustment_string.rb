class AdjustmentString
  attr_reader :number_string
  def initialize(nmr)
    @number_string = nmr
  end

  def present?
    !number_string.blank?
  end

  def multiplier
    @multiplier ||= begin
      if number_string.include?('.')
        number_string.to_f
      else
        (number_string.to_i * 10) / 100.0
      end
    end
  end
end
