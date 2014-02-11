require './QuestionsDatabase.rb'

class Reply
  attr_reader :id, :question_id, :reply_user_id, :reply_id, :body

  def self.all
    replies = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    replies.map { |reply| Reply.new(reply) }
  end


  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
   SELECT *
   FROM replies
   WHERE replies.id = ?
    SQL

    Reply.new(question[0])
  end

  def self.find_by_user_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT *
    FROM
    replies
    WHERE
    reply_user_id = ?
    SQL

    results.map {|result| Reply.new(result) }
  end

  def self.find_by_question(id)
    results = QuestionsDatabse.instance.excute(<<-SQL, id)
    SELECT *
    FROM
    replies
    WHERE
    question_id = ?
    SQL

    results.map { |result| Reply.new(result)}
  end

  def author
    User.find_by_id(self.reply_user_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def initialize(option = {})
    @id = option["id"]
    @question_id = option["question_id"]
    @reply_user_id = option["reply_user_id"]
    @reply_id= option["reply_id"]
    @body = option["body"]
  end

end