describe 'Orchestration::Maestro' do
  describe '.call' do

    context 'when inputs are invalid' do
      subject { Orchestrator::Maestro.call(inputs) }
      let(:logger) { double('logger') }
      before { allow(Logger).to receive(:new).with(STDOUT).and_return(logger) }
      before { allow(logger).to receive(:warn) }
      
      describe 'when there are too much arguments' do
        let(:inputs) { ['', '', ''] }

        it 'raises an error' do
          expect { subject }.to raise_error(RuntimeError, 'Unexpected number of inputs')
        end
      end

      describe 'when there is no argument' do
        let(:inputs) { [] }

        it 'raises an error' do
          expect { subject }.to raise_error(RuntimeError, 'Unexpected number of inputs')
        end
      end

      context "when there is one argument and it's expecting second one" do
        describe 'when the second one is not here' do
          let(:inputs) { ['total_spend'] }

          it 'raises an error' do
            expect { subject }.to raise_error(RuntimeError, 'Invalid command')
          end
        end
      end
    end
  end
end