module ActiveRecord
  class Base
    def self.mass_insert(fields, values)
      return if values.empty?
      field_names = fields.join(', ')
      bind_vars = values.map { "(#{fields.map{ '?' }.join(', ')})" }.join(',')
      ActiveRecord::Base.connection.execute(
        self.send(:sanitize_sql_array, 
                  (["INSERT INTO #{self.table_name} (#{field_names}) VALUES #{bind_vars}"] + values.flatten)))

    end
  end
end
