require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#convert_bootstrap_flash_type' do
    it 'convert "notice" to "info"' do
      flash[:notice] = 'hoge'
      expect(convert_bootstrap_flash_type).to eq([%w[info hoge]])
    end

    it 'convert "alert" to "denger"' do
      flash[:alert] = 'hoge'
      expect(convert_bootstrap_flash_type).to eq([%w[danger hoge]])
    end
  end
end
