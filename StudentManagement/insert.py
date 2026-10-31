from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")

db = client["CollegeDB"]

students = db["students"]

data = [
    {
        "student_id": 101,
        "name": "Rahul",
        "age": 21,
        "gender": "Male",
        "department": "MCA",
        "marks": 85
    },
    {
        "student_id": 102,
        "name": "Priya",
        "age": 22,
        "gender": "Female",
        "department": "BCA",
        "marks": 78
    },
    {
        "student_id": 103,
        "name": "Aman",
        "age": 20,
        "gender": "Male",
        "department": "MCA",
        "marks": 65
    },
    {
        "student_id": 104,
        "name": "Neha",
        "age": 23,
        "gender": "Female",
        "department": "BBA",
        "marks": 90
    },
    {
        "student_id": 105,
        "name": "Rohit",
        "age": 21,
        "gender": "Male",
        "department": "BCA",
        "marks": 72
    }
]

students.insert_many(data)

print("Database created successfully")
print("5 student records inserted successfully")

client.close()