class Student

  attr_accessor :name, :grade
  attr_reader :id
  
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end 

  def self.create_table
    # replace spaces preceeded by pipe with empty string and
    # replace carriage returns and new lines with a space
    sql = <<-END_SQL.gsub(/^\s+\|/, '').gsub("[\r\n]", ' ')
      | CREATE TABLE IF NOT EXISTS students (
      |   id INTEGER PRIMARY KEY,
      |   name TEXT, 
      |   grade TEXT
      | );
    END_SQL
    DB[:conn].execute sql
  end 

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students;"
    DB[:conn].execute sql
  end

  def save
         DB[:conn].execute("INSERT INTO students (name, grade) VALUES(:name, :grade)", "name" => @name, "grade" => @grade)
         @id = DB[:conn].last_insert_row_id
  end

  def self.create(name:, grade:)
    student = self.new(name, grade)   
    student.save
    student
  end
end
