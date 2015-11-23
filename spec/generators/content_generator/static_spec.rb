require 'rails_helper'
describe ContentGenerator::Static do
  subject { described_class.new("foo") }

  describe "#generate" do
    it {expect(subject.generate('bar')).to eq 'foo' }
  end
end
