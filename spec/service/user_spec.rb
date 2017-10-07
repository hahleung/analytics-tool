describe 'Service::User' do
  describe '#most_loyal' do
    let(:store) { double('store') }
    let(:most_loyal) { double('most_loyal') }

    subject { Service::User.most_loyal(store) }

    before do
      allow(store).to receive(:get_table)
        .with('purchase')
        .and_return(store_purchases)
    end

    context 'when there is no loyal' do
      let(:store_purchases) { [] }

      it 'returns nothing' do
        expect(subject).to be_empty
      end
    end

    context 'when there is one most loyal' do
      let(:store_purchases) do
        [
          { 'email' => most_loyal },
          { 'email' => most_loyal },
          { 'email' => "rogue" }
        ]
      end

      it 'returns the most loyal email' do
        expect(subject.size).to eq(1)
        expect(subject).to eq([most_loyal])
      end
    end

    context 'when there are two most loyal persons' do
      let(:second_loyal) { "second_most_loyal" } 
      let(:store_purchases) do
        [
          { 'email' => most_loyal },
          { 'email' => second_loyal },
          { 'email' => most_loyal },
          { 'email' => "rogue" },
          { 'email' => second_loyal }
        ]
      end

      it 'returns the 2 most loyal emails' do
        expect(subject.size).to eq(2)
        expect(subject).to eq([most_loyal, second_loyal])
      end
    end
  end
end
