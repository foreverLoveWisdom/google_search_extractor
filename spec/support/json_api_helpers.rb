# frozen_string_literal: true

# Helper methods for JSON API specs
module JsonApiHelpers
  def json
    JSON.parse(response.body)
  end

  def json_data
    json['data']
  end

  def json_attributes
    json_data.is_a?(Array) ? json_data.pluck('attributes') : json_data['attributes']
  end

  def json_errors
    json['errors']
  end
end
