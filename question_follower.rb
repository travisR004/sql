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

  def self.followed_questions_for_user_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT questions.id, questions.title, questions.body, questions.author_id
    FROM question_followers
    JOIN questions ON question_followers.question_id = questions.id
    WHERE question_followers.user_id = ?
    SQL

    results.map {|result| User.new(result) }
  end

  def self.followers_for_question_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT users.id, users.fname, users.lname
    FROM question_followers
    JOIN users ON question_followers.user_id = users.id
    WHERE question_followers.question_id = ?
    SQL

    results.map {|result| User.new(result) }
  end

  def most_followed_questions(n)
    results = QuestionsDatabases.instance.execute(<<-SQL, n)
    SELECT questions.id, questions.title, questions.body, questions.author_id
    FROM question_followers
    JOIN questions ON question_followers.question_id = questions.id
    GROUP BY questions.id
    ORDER BY COUNT(question_followers.user_id) DESC
    LIMIT ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def initialize(option = {})
    @id = option["id"]
    @question_id = option["question_id"]
    @user_id = option["user_id"]
  end
end
