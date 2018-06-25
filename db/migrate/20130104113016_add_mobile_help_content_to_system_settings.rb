class AddMobileHelpContentToSystemSettings < ActiveRecord::Migration
  class SystemSettings < ActiveRecord::Base
  end
  
  def up
    SystemSettings.create({
      :name=>'mobile_help_content',
      :value=>"
         "
    })
  end

  def down
  end
end
