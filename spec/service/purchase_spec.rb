describe 'Service::Purchase' do
  describe '#get_by_email' do
    let(:store) { double('store') }
    let(:email) { '123' }
    let(:target_purchase) { { 'email' => email } }
    let(:purchase) { { 'email' => 'irrelevant' } }

    subject { Service::Purchase.get_by_email(email, store) }

      before do
        allow(Service::Purchase).to receive(:get_all)
          .with(store)
          .and_return(store_purchases)
      end

    context 'when there is no a matching purchase' do
      let(:store_purchases) { [ purchase ] }

      it 'returns nothing' do
        expect(subject).to be_empty
      end
    end

    context 'when there is one matching purchase' do
      let(:store_purchases) { [ target_purchase, purchase ] }

      it 'returns the relevant purchase' do
        expect(subject).to eq([target_purchase])
      end
    end

    context 'when there is multiple matching purchase' do
      let(:store_purchases) { [ target_purchase, purchase, target_purchase ] }

      it 'returns the relevant purchases' do
        expect(subject).to eq([target_purchase, target_purchase])
      end
    end
  end
end
