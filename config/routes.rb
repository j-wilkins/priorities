Rails.application.routes.draw do
  post 'twilio/checkin/:id' => 'twilio#sms'
end
