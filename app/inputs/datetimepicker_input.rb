class DatetimepickerInput < SimpleForm::Inputs::Base
  def input
    @builder.text_field(attribute_name,input_html_options.merge(:class=>'datetimepicker',
        :value=>object.send(attribute_name).try(:strftime, '%m/%d/%y at %I:%M %p')))
  end
end
