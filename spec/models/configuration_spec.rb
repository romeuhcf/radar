require "rails_helper"

RSpec.describe Configuration, type: :model do
  describe "::get" do
    let!(:existing) { Configuration.create!(key: "a_setting", value: "a_value") }
    context "when existing" do
      it { expect(Configuration.get("a_setting")).to eq "a_value" }
    end

    context "when unexisting" do
      context "when unexisting without default" do
        it { expect(Configuration.get("another_setting")).to be_nil }
      end

      context "when unexisting with default" do
        it do
          expect(Configuration.find_by(key: "another_setting")).to be_falsey
          expect(Configuration.get("another_setting", "a_default_value")).to eq "a_default_value"
          expect(Configuration.find_by(key: "another_setting")).to be_truthy
          expect(Configuration.find_by(key: "another_setting", value: "a_default_value")).to be_truthy
        end
      end
    end
  end
end
