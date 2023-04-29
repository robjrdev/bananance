require 'rails_helper'

RSpec.describe FlashMessageHelper, type: :helper do
  describe '#render_flash_messages' do
    let(:css_class) { 'bg-green-500 text-white p-4 rounded-lg shadow-lg' }

    it 'returns an empty string if flash message is not present' do
      expect(helper.render_flash_messages(:success, css_class)).to be_nil
    end

    it 'returns an HTML string with flash message content if flash message is present' do
      flash[:success] = ['Success message']
      result = helper.render_flash_messages(:success, css_class)

      expected_html =
        '<ul class="fixed top-[20px] right-[50%] translate-x-[50%] text-center flex flex-col items-center gap-4 cursor-none fade">' \
          '<li class="bg-green-500 text-white p-4 rounded-lg shadow-lg">Success message</li></ul>'

      expect(result).to eq(expected_html)
    end

    it 'returns an HTML string with multiple flash message contents if multiple flash messages are present' do
      flash[:success] = ['Success message 1', 'Success message 2']
      result = helper.render_flash_messages(:success, css_class)

      expected_html =
        '<ul class="fixed top-[20px] right-[50%] translate-x-[50%] text-center flex flex-col items-center gap-4 cursor-none fade">' \
          '<li class="bg-green-500 text-white p-4 rounded-lg shadow-lg">Success message 1</li>' \
          '<li class="bg-green-500 text-white p-4 rounded-lg shadow-lg">Success message 2</li></ul>'

      expect(result).to eq(expected_html)
    end
  end
end
