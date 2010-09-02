# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  #  def link_to_remote(name, options = {}, html_options = nil)
  #    options.merge!(:loading=>"showPopup('#ajax-indicator');")
  #    link_to_function(name, remote_function(options), html_options || options.delete(:html))
  #  end

  def comment(&block)
    #SWALLOW THE BLOCK - for multi-line commetns in rhtml file
  end
  def radio_button_tag_standard(name, value, checked = false, options = {})
    pretty_tag_value = value.to_s.gsub(/\s/, "_").gsub(/(?!-)\W/, "").downcase
    pretty_name = name.to_s.gsub(/\[/, "_").gsub(/\]/, "")
    html_options = { "type" => "radio", "name" => name, "value" => value }.update(options.stringify_keys)
    html_options["checked"] = "checked" if checked
    tag :input, html_options
  end
end

