# frozen_string_literal: true

module ApiMacro
  def parsed_body
    @parsed_body ||= JSON.parse(response.body, symbolize_names: true)
  end
end
