class Value
 include DataMapper::Resource

  property :id,     Serial
  property :name,   String
  property :amount, Decimal
end

