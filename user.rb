require './QuestionsDatabase.rb'

class User
  attr_reader :id, :fname, :lname

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

end