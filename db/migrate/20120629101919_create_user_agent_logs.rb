class CreateUserAgentLogs < ActiveRecord::Migration
  def change
    create_table :user_agent_logs do |t|
      t.integer :user_id
      t.string :user_agent
      t.string :browser_name
      t.string :browser_major_version

      t.timestamps
    end
  end
end
