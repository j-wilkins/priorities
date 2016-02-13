require 'rails_helper'

RSpec.describe BodyResolver do
  let(:pcount) { 2 }
  let(:user) {
    OpenStruct.new(projects: OpenStruct.new(enabled: OpenStruct.new(count: pcount)))
  }
  it 'resolves commands' do
    expect(subject.resolve('!wut', user)).to be(:command)
    expect(subject.resolve('/wut', user)).to be(:command)
    expect(subject.resolve('!wut adf', user)).to be(:command)
    expect(subject.resolve('/wut asdf fdd', user)).to be(:command)
  end

  it 'resolves checkins' do
    expect(subject.resolve('a', user)).to be(:checkin)
    expect(subject.resolve('ab', user)).to be(:checkin)
    expect(subject.resolve('ab 7', user)).to be(:checkin)
    #expect(subject.resolve('ab:7', user)).to be(:checkin)
  end
  it 'marks checkins with invalid letters invalid' do
    expect(subject.resolve('abc', user)).to be(:invalid)
  end

  it 'resolves adjustments' do
    expect(subject.resolve('0', user)).to be(:checkin_adjustment)
    expect(subject.resolve('0.9', user)).to be(:checkin_adjustment)
    expect(subject.resolve('9', user)).to be(:checkin_adjustment)
    expect(subject.resolve('19', user)).to be(:checkin_adjustment)
    expect(subject.resolve('1.9', user)).to be(:checkin_adjustment)
  end
end
