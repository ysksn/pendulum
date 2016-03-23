describe Pendulum::DSL::Output::Base do
  let(:dsl) { described_class.new }

  describe '::initialize' do
    subject { dsl.instance_variables }

    context 'when block is given' do
      let(:dsl) { described_class.new { @hoge = 100 } }
      it { is_expected.to include(:@hoge) }
    end

    context 'when no block is given' do
      it { is_expected.to be_empty }
    end
  end

  describe '#to_url' do
    subject { dsl.to_url }

    it 'raise NotImplementedError' do
      expect { subject }.to raise_error(
        NotImplementedError,
        'You must implement Pendulum::DSL::Output::Base#to_url')
    end
  end

  describe '#x_and_y' do
    subject { dsl.send(:x_and_y, x, y) }

    before(:each) do
      dsl.instance_variable_set(:@username, x)
      dsl.instance_variable_set(:@password, y)
    end

    context 'when both params x and y truthy' do
      let(:x) { 'jordan' }
      let(:y) { 'MJ2345' }
      it { is_expected.to eq 'jordan:MJ2345' }
    end

    context 'when only param x is truthy' do
      let(:x) { 'jordan' }
      let(:y) { nil }
      it { is_expected.to eq 'jordan' }
    end

    context 'when only param y is truthy' do
      let(:x) { nil }
      let(:y) { 'MJ2345' }
      it { is_expected.to eq ':MJ2345' }
    end
  end
end
