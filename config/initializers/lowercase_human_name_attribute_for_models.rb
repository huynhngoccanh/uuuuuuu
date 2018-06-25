module ActiveModel
  module Translation
    def human_attribute_name_with_lowercase attribute, options = {}
      human_attribute_name_without_lowercase attribute, options.merge( :default => attribute.to_s.humanize.downcase )
    end

    alias_method_chain :human_attribute_name, :lowercase
  end
end