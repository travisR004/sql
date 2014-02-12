require 'singleton'
require 'sqlite3'
require './question_like.rb'
require './question_follower.rb'
require './reply.rb'
require './user.rb'
require './question.rb'
require './tag.rb'
require 'active_support/inflector'
require './SQL.rb'

class QuestionsDatabase < SQLite3::Database
  include Singleton


  def initialize
    super ("questions.db")

    self.results_as_hash = true

    self.type_translation = true
  end

  def save_db(option = {})

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











