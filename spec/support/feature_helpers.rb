# frozen_string_literal: true

# Helper methods for Feature specs
module FeatureHelpers
  def expect_to_be_redirected_to_sign_in_page
    expect(page).to have_current_path(new_user_session_path)
  end
end
