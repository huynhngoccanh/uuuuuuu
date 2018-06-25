class GreatherOrEqualToOtherAttrValidator < ActiveModel::EachValidator
  def validate_each(record, attr_name, value)
    if !value.nil? && value.to_f < record.send(options[:other_attr]).to_f
      record.errors.add(attr_name, :greather_or_equal_to_other_attr,
        options.merge({:other_attr=>record.send(options[:other_attr])}))
    end
  end
end

class LessOrEqualToOtherAttrValidator < ActiveModel::EachValidator
  def validate_each(record, attr_name, value)
    if value.to_f > record.send(options[:other_attr]).to_f
      record.errors.add(attr_name, :less_or_equal_to_other_attr,
        options.merge({:other_attr=>record.send(options[:other_attr])}))
    end
  end
end

module ActiveModel::Validations::HelperMethods
  def validates_greather_or_equal_to_other_attr(attr_name, other_attr)
    validates_with GreatherOrEqualToOtherAttrValidator, :attributes=>[attr_name], :other_attr=>other_attr
  end
  
  def validates_less_or_equal_to_other_attr(attr_name, other_attr)
    validates_with LessOrEqualToOtherAttrValidator, :attributes=>[attr_name], :other_attr=>other_attr
  end
end


