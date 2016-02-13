require 'rails_helper'

RSpec.describe CheckinReceiver, type: :model do
  let(:phash) { {'a' => Project.new(name: 'a'), 'b' => Project.new(name: 'b')}}
  let(:user) { OpenStruct.new(enabled_project_rateable_hash: phash)}
  let(:rating_string) { OpenStruct.new(rated_projects: ['a', 'b'])}

  it 'processes each rated_project in rating_string' do
    receiver = CheckinReceiver.new(user, rating_string, :date)

    expect(receiver).to receive(:process).twice
    out = receiver.call
    expect(out).to be_a(CheckinReceiver::Receipt)
  end

  it 'processes each rated_project in rating_string' do
    rs = OpenStruct.new(rated_projects: %w|a b|, has_adjustment?: true)
    receiver = CheckinReceiver.new(user, rs, :date)

    allow(CheckinAdjustmentReceiver).to receive(:new).and_return(Proc.new {})
    expect(CheckinAdjustmentReceiver).to receive(:new).with(rs, user, :date)
    expect(receiver.receipt).to receive(:set_adjusted)
    expect(receiver).to receive(:process).twice
    out = receiver.call
    expect(out).to be_a(CheckinReceiver::Receipt)
  end

  context 'process' do
    subject { CheckinReceiver.new(user, rating_string, :date) }

    context 'with existing_checkins' do
      it 'calls update when existing_checkins returns an array' do
        allow(subject).to receive(:existing_checkins_for).and_return([1])
        expect(subject).to receive(:update).with('a', [1])

        subject.process('a')
      end
    end

    context 'without existing_checkins' do
      it 'calls update when existing_checkins returns an array' do
        allow(subject).to receive(:existing_checkins_for).and_return([])
        expect(subject).to receive(:create).with(phash['a'], 'a')

        subject.process('a')
      end
    end
  end

  context 'receipt' do
    let(:day) { :day}
    let(:creation) { :created}
    let(:adj) {:adj}

    subject { CheckinReceiver::Receipt.new(day, creation, adj) }

    it 'sets adjusted' do
      expect(subject).to respond_to(:set_adjusted)
    end
    it 'sets updated' do
      expect(subject).to respond_to(:set_updated)
    end
    it 'has a message' do
      expect(subject.message).to be_a(String)
    end
  end

end
