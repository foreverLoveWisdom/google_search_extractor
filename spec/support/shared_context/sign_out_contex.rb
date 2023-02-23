# frozen_string_literal: true

RSpec.shared_context 'when user is not signed in' do
  before do
    sign_out user
  end
end
