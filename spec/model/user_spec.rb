describe 'Model::User' do
  describe '.get_total_spend' do
    let(:email) { double('email') }
    let(:store) { double('store') }

    subject { Model::User.get_total_spend(email, store) }

    before do
      allow(Service::Purchase).to receive(:get_by_email)
        .with(email, store)
        .and_return(purchases)
    end

    context 'when there is no purchase' do
      let(:purchases) { [] }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when there are some purchases' do
      let(:purchases) { [{ 'spend' => 14 }, { 'spend' => 5.5 }] }

      it 'returns the total' do
        expect(subject).to eq(19.5)
      end
    end
  end

  describe '.get_average_spend' do
    let(:email) { double('email') }
    let(:store) { double('store') }

    subject { Model::User.get_average_spend(email, store) }

    before do
      allow(Service::Purchase).to receive(:get_by_email)
        .with(email, store)
        .and_return(purchases)
    end

    context 'when there is no purchase' do
      let(:purchases) { [] }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when there are some purchases' do
      let(:purchases) { [{ 'spend' => 9 }, { 'spend' => 0 }] }

      it 'returns the average' do
        expect(subject).to eq(4.5)
      end
    end
  end
end
