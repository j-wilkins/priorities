require 'rails_helper'

RSpec.describe StatsGraph do
  it 'builds a url' do
    expect(StatsGraph.build({key: :value})).to be_a(String)
  end
end
