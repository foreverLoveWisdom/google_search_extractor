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
    json_data['attributes']
  end

  def json_attribute_for(attribute)
    json_attributes[attribute.to_s]
  end

  def json_errors
    json['errors']
  end
end
