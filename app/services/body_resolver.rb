module BodyResolver
  CHECKIN_REGEX = /^[a-zA-Z]{1,}( [0-9]|)$/
  ADJ_REGEX = /^[0-9]{1,2}(\.[0-9]|)$/

  def self.resolve(body, user)
    if body.first == "!" || body.first == "/"
      :command
    elsif CHECKIN_REGEX.match(body)
      count = user.projects.enabled.count - 1
      vals = ("a".."z").to_a[0..count]
      ps = body.split(' ', 2).first
      if ps.chars.map {|c| vals.include?(c)}.all?
        :checkin
      else
        :invalid
      end
    elsif ADJ_REGEX.match(body)
      :checkin_adjustment
    else
      :invalid
    end
  end
end

