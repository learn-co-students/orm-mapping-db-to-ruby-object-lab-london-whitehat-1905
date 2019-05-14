class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    pupil = Student.new
    pupil.id = row[0]
    pupil.name = row[1]
    pupil.grade = row[2]
    pupil
  end

  def self.all
    sql = "SELECT * FROM students;"
    data = DB[:conn].execute(sql)
    arr = []
    data.each do |row|
      s = self.new_from_db(row)
      arr << s
    end
    arr
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = '#{name}' LIMIT 1;"
    row = DB[:conn].execute(sql)
    self.new_from_db(row[0])
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
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

  def self.all_students_in_grade_9
    sql = "SELECT name FROM students WHERE grade = 9;"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT name FROM students WHERE grade < 12;"
    data = DB[:conn].execute(sql)
    #print data[0][0]
    [self.find_by_name(data[0][0])]
  end

  def self.first_X_students_in_grade_10(param)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT #{param};"
    data = DB[:conn].execute(sql)
    puts data
    arr = []
    data.each do |row|
      arr << self.find_by_name(row[1])
    end
    arr
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 ORDER BY id ASC LIMIT 1;"
    data = DB[:conn].execute(sql)
    self.find_by_name(data[0][1])
  end

  def self.all_students_in_grade_X(param)
    sql = "SELECT * FROM students WHERE grade = #{param};"
    data = DB[:conn].execute(sql)
    arr = []
    data.each do |row|
      arr << self.find_by_name(row[1])
    end
    arr
  end
end