require './QuestionsDatabase.rb'

class Question < Sql

  attr_accessor :title, :body, :author_id
  attr_reader :id
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
    result = QuestionsDatabase.instance.execute(<<-SQL, self.author_id)
    SELECT *
    FROM
    users
    WHERE
    users.id = ?
    SQL

    result.map{ |result| User.new(result)}
  end

  def most_followed(n)
    Question_follower.most_followed_questions(n)
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

  def likers
    QuestionLike.likers_for_question_id(self.id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(self.id)
  end

  def most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def followers
    Question_follower.followers_for_question_id(self.id)
  end

  def save
    @id = super({"object" => self, "title" => self.title, "body" => self.body,
      "author_id" => self.author_id })
  end
end



























