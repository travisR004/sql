require './QuestionsDatabase.rb'

class Question_follower
  attr_reader :id, :question_id, :user_id

  def self.all
    questions_fol = QuestionsDatabase.instance.execute("SELECT * FROM question_followers")
    questions_fol.map { |question| Question_follower.new(question) }
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
   SELECT *
   FROM question_followers
   WHERE question_followers.id = ?
    SQL

    Question_follower.new(question[0])
  end
  def initialize(option = {})
    @id = option["id"]
    @question_id = option["question_id"]
    @user_id = option["user_id"]
  end
end
