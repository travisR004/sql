require './QuestionsDatabase'
require './SQL.rb'

class Tag < Sql
  attr_reader :id
  attr_accessor :name


  def self.all
    users = QuestionsDatabase.instance.execute("SELECT * FROM tags")
    users.map { |user| Tag.new(user) }
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
   SELECT *
   FROM tags
   WHERE tags.id = ?
    SQL
    Tag.new(question[0])
  end

  def self.most_popular(n)
   QuestionsDatabase.instance.execute(<<-SQL,n)
      SELECT *
      FROM tags
      JOIN question_tags as qt ON qt.tag_id  = tags.id
      JOIN question_likes ON question_likes.question_id = qt.question_id
      GROUP BY tags.id
      ORDER BY COUNT(question_likes.user_id) DESC
      LIMIT ?
      SQL

  end

  def initialize(option = {})
    @id = option["id"]
    @name = option["name"]
  end

  def most_popular_questions(n)
    result = QuestionsDatabase.instance.execute(<<-SQL, self.id, n)
      SELECT
      questions.id, questions.title, questions.body, questions.author_id
      FROM
      questions JOIN question_likes ON questions.id = question_likes.question_id
      WHERE
      questions.id IN (SELECT question_tags.question_id
      FROM
      tags JOIN question_tags ON tags.id = question_tags.tag_id
      WHERE
      tag_id = ?)
      GROUP BY questions.id
      ORDER BY COUNT(question_likes.user_id) DESC
      LIMIT ?
      SQL

    result.map{ |result| Question.new(result)}
  end

  def save
    @id = super({"object" => self, "name" => self.name})
  end

end