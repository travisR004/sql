require './QuestionsDatabase.rb'

class QuestionLike
  attr_reader :id, :question_id, :user_id

  def self.all
    question_likes = QuestionsDatabase.instance.execute("SELECT * FROM question_likes")
    question_likes.map { |question| QuestionLike.new(question) }
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
   SELECT *
   FROM question_likes
   WHERE question_likes.id = ?
    SQL

    QuestionLike.new(question[0])
  end

  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT users.id, users.fname, users.lname
    FROM users
    JOIN question_likes ON users.id = question_likes.user_id
    WHERE
    question_id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.num_likes_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT COUNT(user_id)
    FROM question_likes
    WHERE
    question_id = ?
    SQL
  end

  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT questions.id, questions.title, questions.body, questions.author_id
    FROM questions
    JOIN question_likes ON questions.id = question_likes.question_id
    WHERE
    question_likes.user_id = ?
    SQL

    results.map { |result| Question.new(result) }
  end

  def most_liked_questions(n)
    results = QuestionsDatabases.instance.execute(<<-SQL, n)
    SELECT questions.id, questions.title, questions.body, questions.author_id
    FROM question_likes
    JOIN questions ON question_likes.question_id = questions.id
    GROUP BY questions.id
    ORDER BY COUNT(question_likes.user_id) DESC
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