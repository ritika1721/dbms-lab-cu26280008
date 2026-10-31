from flask import Flask, render_template, request, redirect, url_for
from pymongo import MongoClient

app = Flask(__name__)

# MongoDB Connection
client = MongoClient("mongodb://localhost:27017/")

db = client["CollegeDB"]

students = db["students"]

# Home Page
@app.route('/')
def home():
    client.admin.command('ping')
    return render_template("index.html")


# Add Student
@app.route('/add', methods=['POST'])
def add_student():

    sid = int(request.form['student_id'])

    if students.find_one({"student_id": sid}):
        return "Student ID already exists!"

    data = {
        "student_id": sid,
        "name": request.form['name'],
        "age": int(request.form['age']),
        "gender": request.form['gender'],
        "department": request.form['department'],
        "marks": int(request.form['marks'])
    }

    students.insert_one(data)

    return redirect(url_for('view_students'))


# View All Students
@app.route('/view')
def view_students():

    data = list(students.find())

    return render_template("students.html", students=data)


# Search Student
@app.route('/search', methods=['GET', 'POST'])
def search_student():

    student = None
    message = ""

    if request.method == 'POST':

        sid = int(request.form['student_id'])

        student = students.find_one({"student_id": sid})

        if student is None:
            message = "Student not found!"

    return render_template(
        "search.html",
        student=student,
        message=message
    )


# Update Student
@app.route('/update', methods=['GET', 'POST'])
def update_student():

    message = ""

    if request.method == 'POST':

        sid = int(request.form['student_id'])

        result = students.update_one(
            {"student_id": sid},
            {
                "$set": {
                    "name": request.form['name'],
                    "age": int(request.form['age']),
                    "department": request.form['department'],
                    "marks": int(request.form['marks'])
                }
            }
        )

        if result.matched_count > 0:
            message = "Student updated successfully!"
        else:
            message = "Student not found!"

    return render_template("update.html", message=message)


# Delete Student
@app.route('/delete', methods=['GET', 'POST'])
def delete_student():

    message = ""

    if request.method == 'POST':

        sid = int(request.form['student_id'])

        result = students.delete_one({"student_id": sid})

        if result.deleted_count > 0:
            message = "Student deleted successfully!"
        else:
            message = "Student not found!"

    return render_template("delete.html", message=message)


# MongoDB Filtering
@app.route('/filter', methods=['GET', 'POST'])
def filter_students():

    data = []
    message = ""

    if request.method == 'POST':

        choice = request.form['choice']

        if choice == 'department':

            department = request.form['department']

            data = list(students.find({
                "department": department
            }))

        elif choice == 'greater':

            data = list(students.find({
                "marks": {"$gt": 75}
            }))

        elif choice == 'range':

            data = list(students.find({
                "marks": {"$gte": 50, "$lte": 80}
            }))

        elif choice == 'age':

            data = list(students.find({
                "age": {"$gt": 20}
            }))

        if len(data) == 0:
            message = "No matching students found!"

    return render_template(
        "filter.html",
        students=data,
        message=message
    )


# Run Application
if __name__ == '__main__':
    app.run(debug=True)