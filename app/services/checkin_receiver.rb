class CheckinReceiver
  def self.call(parms, user)
    new(parms, user).call
  end

  attr_reader :parms, :user

  def initialize(parms, user)
    @parms, @user = parms, user
  end

  def call
    abcs = ("a".."z").to_a
    project_hash = Hash[user.projects.enabled.map {|pr| [abcs.shift, pr]}]
    updated = false
    RatingParser.rated_projects(parms['Body']).each do |letter|
      project = project_hash.delete(letter)
      if project
        checkin = user.project_checkins.where(project: project,
          date: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)

        if checkin
          checkin.update_attribute(:percentage, RatingParser.rating_for(parms['Body'], letter))
          updated = true
        else
          user.project_checkins.create(project: project, date: Time.zone.now,
            percentage: RatingParser.rating_for(parms['Body'], letter))
        end
      end
    end
    updated ? :updated : :created
  end

  private

  module RatingParser
    module_function
    def rated_projects(string)
      string.chars.uniq.map {|n| n.downcase}
    end

    def rating_for(rating, fr)
      h = Hash[rating.chars.group_by {|c| c}.map {|(k, vs)| [k, vs.length]}]
      sum = h.values.sum.to_f
      (((h[fr] / sum).to_f) * 100).to_i
    end
  end

  def rating_hash
    Hash[body_lines.each { |r| r.split(":") }]
  end

  def body_lines
    rere = /(,|\n|;)/
    parms['Body'].split(rere).reject {|s| s =~ rere}
  end
end

