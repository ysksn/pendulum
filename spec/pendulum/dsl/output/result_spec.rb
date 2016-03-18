describe Pendulum::DSL::Output::Result do
  describe 'to_url' do
    let(:dsl) { described_class.new('name') }
    subject   { dsl.to_url }
    before    { dsl.table 'table' }

    it { is_expected.to eql('name:table') }
  end
end

