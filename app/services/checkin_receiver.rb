class CheckinReceiver
  def self.call(parms, user)
    new(user, RatingString.new(parms['Body']), CheckinDay.today(user)).call
  end

  class Receipt
    attr_reader :creation, :day, :adjusted
    private :creation, :day, :adjusted

    def initialize(d, c = :created, a = false)
      c = :created unless %i|created updated|.include?(c)
      @creation, @day, @adjusted = c, d, a
    end

    def set_updated; @creation = :updated; end
    def set_adjusted; @adjusted = true; end

    def message(modifier = nil)
      case
        when created? && adjusted? && modifier == :yesterday
          'Yesterdays checkin received and adjusted for a non-standard day. Go to bed already!!'
        when created? && adjusted?
          'Checkin received and adjusted for a non-standard day. Enjoy your evening!'
        when updated? && adjusted? && modifier == :yesterday
          "New Checkin received, updated yesterday's records."
        when updated? && modifier == :yesterday
          "Updated yesterday's records. To apply an adjustment, use '!yesterday <rating> <modifier>'."
        when updated?
          "New Checkin received, updated today's records."
        when created? && modifier == :yesterday
          'Checkin received for yesterday. To apply an adjustment, use "!yesterday <rating> <modifier>".'
        when created?
          "Checkin Received. If today was not a full day,"\
            " respond with a modifier (1-9). Otherwise, enjoy your evening!"
        else
          "Something definitely happened, but I have no idea what."
      end
    end

    private
    def created?; creation == :created; end
    def updated?; creation == :updated; end
    def adjusted?; adjusted; end
  end

  attr_reader :user, :rating_string, :checkin_day, :receipt, :project_hash

  def initialize(user, rs, cd)
    @user, @rating_string, @checkin_day = user, rs, cd
    @receipt = Receipt.new(checkin_day)
    @project_hash = user.enabled_project_rateable_hash
  end

  def call
    rating_string.rated_projects.each { |letter| process(letter) }

    if rating_string.has_adjustment?
      CheckinAdjustmentReceiver.new(rating_string, user, checkin_day).call
      receipt.set_adjusted
    end

    receipt
  end

  def process(letter)
    project = project_hash.delete(letter)

    checkins = existing_checkins_for(checkin_day, project)

    checkins.count == 1 ? update(letter, checkins) : create(project, letter)
  end

  def update(letter, checkins)
    checkins.first.update_attribute(:percentage, rating_string.rating_for(letter))
    receipt.set_updated
  end

  def create(project, letter)
    user.project_checkins.create(project: project, checkin_day: checkin_day,
      percentage: rating_string.rating_for(letter))
  end

  def existing_checkins_for(date, project)
    user.project_checkins.for_project_and_date(project, date)
  end

end

