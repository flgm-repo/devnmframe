class CreateMarketingAnswers < ActiveRecord::Migration
  def self.up
    create_table :marketing_answers do |t|
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :marketing_answers
  end
end
