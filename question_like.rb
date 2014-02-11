require './QuestionsDatabase.rb'

class Question_like
  attr_reader :id, :question_id, :user_id

  def self.all
    question_likes = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    question_likes.map { |question| Question_like.new(question) }
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
   SELECT *
   FROM question_likes
   WHERE question_likes.id = ?
    SQL

    Question_like.new(question[0])
  end

  def initialize(option = {})
    @id = option["id"]
    @question_id = option["question_id"]
    @user_id = option["user_id"]
  end


end