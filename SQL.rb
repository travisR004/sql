class Sql

  def save(option = {})

  object = option["object"].dup
  class_type = object.class
  id = object.id
  option.shift

  if id.nil?
    QuestionsDatabase.instance.execute(<<-SQL)
    INSERT INTO
    #{class_type.to_s.downcase.pluralize} (#{option.keys.join(", ")})
    VALUES
   ('#{option.values.join("', '")}')
    SQL
    QuestionsDatabase.instance.last_insert_row_id
  else
    QuestionsDatabase.instance.execute(<<-SQL)
    UPDATE
    #{class_type.to_s.downcase.pluralize}
    SET #{option.map{|key,value| "#{key} = '#{value}'"}.join(', ')}
    WHERE #{class_type.to_s.downcase.pluralize}.id = #{id}
    SQL
    QuestionsDatabase.instance.last_insert_row_id
    end
  end
end

