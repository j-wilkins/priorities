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
    checkin_date = CheckinDay.today(user)
    updated = false
    RatingParser.rated_projects(parms['Body']).each do |letter|
      project = project_hash.delete(letter)

      if project
        checkin = user.project_checkins.today_for_project(checkin_date, project)

        if checkin.count == 1
          checkin.first.update_attribute(:percentage, RatingParser.rating_for(parms['Body'], letter))
          updated = true
        else
          user.project_checkins.create(project: project, checkin_day: checkin_date,
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

