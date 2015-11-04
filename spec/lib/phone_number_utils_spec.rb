require 'rails_helper'
require 'phone_number_utils'


describe PhoneNumberUtils do

  describe "valid_mobile_number?" do
    it { expect(subject.valid_mobile_number?('1')).to be_falsey }
    it { expect(subject.valid_mobile_number?('9')).to be_falsey }
    it { expect(subject.valid_mobile_number?('9a8')).to be_falsey }

    it { expect(subject.valid_mobile_number?('55 9999 8888')).to be_truthy }
    it { expect(subject.valid_mobile_number?('55 9 9999 8888')).to be_falsey }
    it { expect(subject.valid_mobile_number?('11 9 9999 8888')).to be_truthy }
    it { expect(subject.valid_mobile_number?('11960758444')).to be_truthy }

    it { expect(subject.valid_mobile_number?('+5511960758444')).to be_truthy }
    it { expect(subject.valid_mobile_number?('+55 55 9075 8444')).to be_truthy }
    it { expect(subject.valid_mobile_number?('5511960758444')).to be_truthy }
    it { expect(subject.valid_mobile_number?('555590758444')).to be_truthy }
    it { expect(subject.valid_mobile_number?('1134448833')).to be_falsey }
  end

end