require './QuestionsDatabase.rb'
require './SQL.rb'


class User < Sql
  attr_accessor :fname, :lname
  attr_reader :id

  def self.all
    users = QuestionsDatabase.instance.execute("SELECT * FROM users")
    users.map { |user| User.new(user) }
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
   SELECT *
   FROM users
   WHERE users.id = ?
    SQL

    User.new(question[0])
  end

  def self.find_by_name(fname, lname)
    result = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT *
      FROM
      users
      WHERE
      fname = ? AND lname = ?
      SQL
    User.new(result[0])
  end

  # def self.find_by(hash)
 #
 #  end
 #
 #  User.find_by(:name => "Buck", :age => 19)

  def initialize(option = {})
    @id = option["id"]
    @fname = option["fname"]
    @lname = option["lname"]
  end

  def authored_questions
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end

  def followed_questions
    Question_follower.followed_questions_for_user_id(self.id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma
    result = QuestionsDatabase.instance.execute(<<-SQL, self.id)
    SELECT (COUNT(question_likes.question_id) / COUNT(DISTINCT questions.id)) avg_karma
    FROM questions
    JOIN question_likes ON question_likes.question_id = questions.id
    WHERE questions.author_id = ?
    SQL

    result.first["avg_karma"]
  end

  def save
    @id = super({"object" => self, "fname" => self.fname, "lname" => self.lname })
  end


end














