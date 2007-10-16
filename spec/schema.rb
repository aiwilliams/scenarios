ActiveRecord::Schema.define do
  create_table "people", :force => true do |t|
    t.column "first_name", :string
    t.column "last_name", :string
  end
  
  create_table "things", :force => true do |t|
    t.column "name", :string
    t.column "description", :string
  end
end
  