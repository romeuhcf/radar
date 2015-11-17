require 'rails_helper'
require 'csv_col_sep_sniffer'

describe CsvColSepSniffer do
  describe ".find" do
    subject(:find) { described_class.find(path) }

    let(:path) { fixture_file("products.csv") }

    context "when , delimiter" do
      it "returns separator" do
        expect(find).to eq(',')
      end
    end

    context "when ; delimiter" do
      let(:path) { fixture_file('products_with_semi_colon_seperator.csv') }

      it "returns separator" do
        expect(find).to eq(';')
      end
    end

    context "when | delimiter" do
      let(:path) { fixture_file('products_with_bar_seperator.csv') }

      it "returns separator" do
        expect(find).to eq('|')
      end
    end

    context "when empty file" do
      it "raises error" do
        expect(File).to receive(:open) { [] }
        expect { find }.to raise_error(described_class::EmptyFile)
      end
    end

    context "when no column separator is found" do
      it "raises error" do
        expect(File).to receive(:open) { [''] }
        expect { find }.to raise_error(described_class::NoColumnSeparatorFound)
      end
    end
  end
end
