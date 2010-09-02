module HtmlHelpers
  def radio_button_tag_standard(name, value, checked = false, options = {})
          pretty_tag_value = value.to_s.gsub(/\s/, "_").gsub(/(?!-)\W/, "").downcase
          pretty_name = name.to_s.gsub(/\[/, "_").gsub(/\]/, "")
          html_options = { "type" => "radio", "name" => name, "value" => value }.update(options.stringify_keys)
          html_options["checked"] = "checked" if checked
          tag :input, html_options
  end
end

