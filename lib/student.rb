class Student
  attr_accessor :id, :name, :grade

  def initialize(attributes = {})
    attributes.each_pair do |key, val|
      send("#{key}=", val)
    end
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    DB[:conn].execute(sql).map &db_row_to_instances
  end

  def self.all_students_in_grade_X(n)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    DB[:conn].execute(sql, n).map &db_row_to_instances
  end

  def self.all_students_in_grade_9
    all_students_in_grade_X(9)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    row = DB[:conn].execute(sql, name).first
    new_from_db(row)
  end

  def self.first_student_in_grade_10
    all_students_in_grade_X(10).first
  end

  def self.first_X_students_in_grade_10(x)
    all_students_in_grade_X(10).first(x)
  end

  def self.db_row_to_instances
    lambda { |row| new_from_db(row) }
  end

  def self.new_from_db(row)
    id, name, grade = row
    new(id: id, name: name, grade: grade)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL
    DB[:conn].execute(sql).map &db_row_to_instances
  end
end
