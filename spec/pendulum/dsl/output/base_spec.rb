describe Pendulum::DSL::Output::Base do
  let(:dsl) { described_class.new }

  shared_context 'set @username and @password' do
    before(:each) do
      dsl.instance_variable_set(:@username, x)
      dsl.instance_variable_set(:@password, y)
    end
  end

  shared_context 'set @hostname and @port' do
    before(:each) do
      dsl.instance_variable_set(:@hostname, x)
      dsl.instance_variable_set(:@port, y)
    end
  end

  shared_context 'set x and y' do
    let(:x) { 'any' }
    let(:y) { 'thing' }
  end

  shared_context 'set first and second options' do
    let(:first_option) { :username }
    let(:second_option) { :password }
  end

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
    include_context 'set @username and @password'

    context 'when both params x and y truthy' do
      include_context 'set x and y'
      it { is_expected.to eq 'any:thing' }
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

  describe '#username_and_password' do
    include_context 'set @username and @password'
    include_context 'set x and y'

    it 'calls x_and_y' do
      expect(dsl).to receive(:x_and_y).with(x, y).once
      dsl.send(:username_and_password)
    end
  end

  describe '#hostname_and_port' do
    include_context 'set @hostname and @port'
    include_context 'set x and y'

    it 'calls x_and_y' do
      expect(dsl).to receive(:x_and_y).with(x, y).once
      dsl.send(:hostname_and_port)
    end
  end

  describe '#with_options' do
    include_context 'set @username and @password'
    include_context 'set x and y'
    include_context 'set first and second options'

    let(:url) { 'https://pendulum.com' }
    subject { dsl.send(:with_options, url, first_option, second_option) }

    it { is_expected.to eq 'https://pendulum.com?username=any&password=thing' }
  end

  describe '#select_options' do
    subject { dsl.send(:select_options, options) }

    context 'when options are nil' do
      let(:options) { nil }
      it { is_expected.to eq [] }
    end

    context 'when options are truthy' do
      context 'but not defined as instance variable' do
        let(:options) { [:cat, :dog, :bird] }
        it { is_expected.to eq [] }
      end

      context 'defined as instance variable' do
        include_context 'set @username and @password'
        include_context 'set x and y'
        include_context 'set first and second options'
        let(:options) { [first_option, second_option, :hoge] }
        it { is_expected.to eq [:username, :password] }
      end
    end
  end

  describe '#generate_query_parameters' do
    subject { dsl.send(:generate_query_parameters, options) }

    context 'when options are []' do
      let(:options) { [] }
      it { is_expected.to eq '' }
    end

    context 'when options are [:username, :password]' do
      include_context 'set @username and @password'
      include_context 'set x and y'
      include_context 'set first and second options'
      let(:options) { [first_option, second_option] }
      it { is_expected.to eq 'username=any&password=thing' }
    end
  end
end
