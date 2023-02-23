# frozen_string_literal: true

# Shared helper methods for views
module ApplicationHelper
  def format_date(date)
    date.strftime('%d/%m/%Y')
  end
end
