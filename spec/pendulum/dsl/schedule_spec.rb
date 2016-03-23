describe Pendulum::DSL::Schedule do
  let(:dsl) { described_class.new('spec') }

  describe '#to_params' do
    subject { dsl.to_params }

    context 'when object has only variable @name' do
      it { is_expected.to eql(name: 'spec') }
    end

    context 'when object has variables ohter than @name' do
      before(:each) { dsl.instance_variable_set(key, value) }

      context '@cron is set' do
        let(:key) { :@cron }
        let(:value) { '*' }
        it { is_expected.to eql(name: 'spec', cron: '*') }
      end

      context '@priority is set' do
        let(:key) { :@priority }
        let(:value) { 0 }
        it { is_expected.to eql(name: 'spec', priority: 0) }
      end

      context '@result is set' do
        let(:key) { :@result }
        let(:value) { 'url' }
        it { is_expected.to eql(name: 'spec', result: 'url') }
      end
    end
  end

  describe '#cron' do
    before  { dsl.cron cron }
    subject { dsl.to_params[:cron] }

    context 'when pass cron * * * * *' do
      let(:cron) { '* * * * *' }
      it { is_expected.to eql('* * * * *') }
    end

    context 'when pass special option :hourly' do
      let(:cron) { :hourly }
      it { is_expected.to eql('@hourly') }
    end

    context 'when pass special option :daily' do
      let(:cron) { :daily }
      it { is_expected.to eql('@daily') }
    end

    context 'when pass special option :monthly' do
      let(:cron) { :monthly }
      it { is_expected.to eql('@monthly') }
    end
  end

  describe '#priority' do
    before  { dsl.priority priority }
    subject { dsl.to_params[:priority] }

    context 'when pass priority id 1' do
      let(:priority) { 1 }
      it { is_expected.to eql(1) }
    end

    context 'when pass priority name :very_low' do
      let(:priority) { :very_low }
      it { is_expected.to eql(-2) }
    end

    context 'when pass priority name :low' do
      let(:priority) { :low }
      it { is_expected.to eql(-1) }
    end

    context 'when pass priority name :normal' do
      let(:priority) { :normal }
      it { is_expected.to eql(0) }
    end

    context 'when pass priority name :high' do
      let(:priority) { :high }
      it { is_expected.to eql(1) }
    end

    context 'when pass priority name :very_high' do
      let(:priority) { :very_high }
      it { is_expected.to eql(2) }
    end
  end
end

