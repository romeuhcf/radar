require 'rails_helper'

RSpec.describe RouteProvider, type: :model do
  it { expect(build(:route_provider)).to be_valid }
  it { expect(build(:route_provider, provider_klass: nil)).to_not be_valid }
  it { expect(build(:route_provider, provider_klass: 'Wakka')).to_not be_valid }
  it { expect(build(:route_provider, provider_klass: String)).to be_valid }
end
