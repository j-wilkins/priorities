require 'rails_helper'

RSpec.describe RatingString, type: :model do
  let(:strings) {{
    'ab' => {'a' => 50, 'b' => 50},
    'aabb' => {'a' => 50, 'b' => 50},
    'aab' => {'a' => 66, 'b' => 33},
    'aaab' => {'a' => 75, 'b' => 25},
    'aaabc' => {'a' => 60, 'b' => 20, 'c' => 20},
    'abc' => {'a' => 33, 'b' => 33, 'c' => 33},
    'abccc' => {'a' => 20, 'b' => 20, 'c' => 60}
  }}

  shared_context 'correct proportions' do
    it 'has correct proportions' do
      strings.each do |string, exps|
        str = RatingString.new(string)
        exps.each do |ltr, value|
          rating = str.rating_for(ltr)
          expect(rating).to eq(value), "expected ltr '#{ltr}' to rate #{value} for string '#{string}',\n got #{rating}"
        end
      end
    end
  end

  include_context 'correct proportions'

  context 'with adjustment string apended' do
    let(:strings) {{
      'ab 5' => {'a' => 50, 'b' => 50},
      'aabb 0.4' => {'a' => 50, 'b' => 50},
      'aab 9' => {'a' => 66, 'b' => 33},
      'aaab 8' => {'a' => 75, 'b' => 25},
      'aaabc 3' => {'a' => 60, 'b' => 20, 'c' => 20},
      'abc 2' => {'a' => 33, 'b' => 33, 'c' => 33},
      'abccc 5' => {'a' => 20, 'b' => 20, 'c' => 60}
    }}

    include_context 'correct proportions'
  end

end
