require 'rails_helper'

RSpec.describe CommandProcessor do
  let(:user) { User.create(name: 'jake', phone_number: '11')}
  let(:parms) {{'Body' => 'invalid'}}
  subject {CommandProcessor.new(parms, user)}

  context 'stats' do
    context 'no projects' do
      it 'returns a TwimlText' do
        twiml = subject.stats
        expect(twiml).to be_a(CommandProcessor::TwimlText)
        expect(twiml.text).to include("!project")
      end
    end
    context 'projects' do
      before do
        project = Project.create!(name: '1', user: user, enabled: true)
        cd = CheckinDay.create!(date: Date.yesterday, user: user)
        ProjectCheckin.create!(checkin_day: cd, percentage: 70, project: project, user: user)
      end
      it 'returns a TwimlText' do
        twiml = subject.stats
        expect(twiml).to be_a(CommandProcessor::TwimlText)
        expect(twiml.text).to include("Media")
      end
    end
  end
end
