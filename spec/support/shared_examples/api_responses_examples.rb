# frozen_string_literal: true

RSpec.shared_examples 'response unprocessable entity status' do
  it 'returns status code 422' do
    expect(response).to have_http_status(:unprocessable_entity)
  end
end

RSpec.shared_examples 'response success status' do
  it 'returns status code 200' do
    expect(response).to have_http_status(:ok)
  end
end

RSpec.shared_examples 'response accepted status' do
  it 'returns status code 202' do
    expect(response).to have_http_status(:accepted)
  end
end
