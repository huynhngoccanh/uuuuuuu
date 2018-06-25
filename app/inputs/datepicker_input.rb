class DatepickerInput < SimpleForm::Inputs::Base
  def input
    @builder.text_field(attribute_name,input_html_options.merge(:class=>'datepicker', 
        :value=>object.send(attribute_name).try(:strftime, '%m/%d/%y')))
  end
end
