# frozen_string_literal: true

# Shared helper methods for views
module ApplicationHelper
  def format_date(date)
    date.strftime('%d/%m/%Y')
  end

  def username(user)
    user.email.split('@').first.humanize
  end
end
