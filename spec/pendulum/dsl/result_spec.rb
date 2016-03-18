describe Pendulum::DSL::Result do
  let(:dsl) { described_class.new(type) }

  describe '#output' do
    subject { dsl.output }

    context 'when pass type :td' do
      let(:type) { :td }
      it { is_expected.to be_an_instance_of(Pendulum::DSL::Output::TreasureData) }
    end

    context 'when pass type :postgresql' do
      let(:type) { :postgresql }
      it { is_expected.to be_an_instance_of(Pendulum::DSL::Output::Postgresql) }
    end

    context 'when pass other type (registered result name)' do
      let(:type) { :other }
      it { is_expected.to be_an_instance_of(Pendulum::DSL::Output::Result) }
    end
  end
end

