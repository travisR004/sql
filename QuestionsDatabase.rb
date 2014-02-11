require 'singleton'
require 'sqlite3'
require './question_like.rb'
require './question_follower.rb'
require './reply.rb'
require './user.rb'

class QuestionsDatabase < SQLite3::Database
  include Singleton


  def initialize
    super ("questions.db")

    self.results_as_hash = true

    self.type_translation = true
  end

end


class Question

  attr_reader :id, :title, :body, :author_id

  def self.all
    questions = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    questions.map { |question| Question.new(question) }
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
   SELECT *
   FROM questions
   WHERE questions.id = ?
    SQL
    Question.new(question[0])
  end

  def self.find_by_author_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT *
    FROM
    questions
    WHERE
    author_id = ?
    SQL

    results.map {|question| Question.new(question) }
  end

  def author
    result = QuestionDatabase.instance.execute(<<-SQL, self.author_id)
    SELECT *
    FROM
    users
    WHERE
    users.id = ?
    SQL

    result.map{ |result| User.new(result)}
  end

  def replies
    Reply.find_by_question(self.id)
  end

  def initialize(option = {} )
    @id = option["id"]
    @title = option["title"]
    @body = option["body"]
    @author_id = option["author_id"]
  end

end








