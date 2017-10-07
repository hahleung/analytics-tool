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
      let(:store_purchases) { [purchase] }

      it 'returns nothing' do
        expect(subject).to be_empty
      end
    end

    context 'when there is one matching purchase' do
      let(:store_purchases) { [target_purchase, purchase] }

      it 'returns the relevant purchase' do
        expect(subject).to eq([target_purchase])
      end
    end

    context 'when there is multiple matching purchase' do
      let(:store_purchases) { [target_purchase, purchase, target_purchase] }

      it 'returns the relevant purchases' do
        expect(subject).to eq([target_purchase, target_purchase])
      end
    end
  end

  describe '#get_most_sold' do
    let(:store) { double('store') }
    let(:most_sold_item) { double('most_sold_item') }

    subject { Service::Purchase.get_most_sold(store) }

    before do
      allow(Service::Purchase).to receive(:get_all)
        .with(store)
        .and_return(store_purchases)
    end

    context 'when there is no most sold item' do
      let(:store_purchases) { [] }

      it 'returns nothing' do
        expect(subject).to be_empty
      end
    end

    context 'when there is one most sold item' do
      let(:store_purchases) do
        [
          { 'item' => most_sold_item },
          { 'item' => most_sold_item },
          { 'item' => most_sold_item },
          { 'item' => 'insignificant item' },
        ]
      end

      it 'returns the relevant item' do
        expect(subject.size).to eq(1)
        expect(subject).to eq([most_sold_item])
      end
    end

    context 'when there is multiple most sold items' do
      let(:second_item) { double('second_item') }
      let(:store_purchases) do
        [
          { 'item' => most_sold_item },
          { 'item' => second_item },
          { 'item' => most_sold_item },
          { 'item' => second_item },
          { 'item' => 'insignificant item' }
        ]
      end

      it 'returns the relevant items' do
        expect(subject.size).to eq(2)
        expect(subject).to eq([most_sold_item, second_item])
      end
    end
  end
end
