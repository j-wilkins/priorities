class TwilioController < ApplicationController
  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def sms
  	render_twiml TextReceiver.call(params.permit!)
  end

  private

	def set_header
    response.headers["Content-Type"] = "text/xml"
	end

	def render_twiml(response)
    render text: response.text
	end
end
