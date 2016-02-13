class RatingString
  attr_reader :rating, :adjustment

  def initialize(str)
    @rating, @adjustment = str.downcase.split(' ', 2)
    @adjustment = AdjustmentString.new(@adjustment)
  end

  def has_adjustment?
    adjustment.present?
  end

  def rated_projects
    rating.chars.uniq
  end

  def rating_for(fr)
    (((rating_hash[fr] / total_ratings).to_f) * 100).to_i
  end

  def rating_hash
    @rating_hash ||= Hash[rating.chars.group_by {|c| c}.map {|(k, vs)| [k, vs.length]}]
  end

  def total_ratings
    @total_ratings ||= rating.chars.count.to_f
  end

  def multiplier
    adjustment.multiplier
  end
end

