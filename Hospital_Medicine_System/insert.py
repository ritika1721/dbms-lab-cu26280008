from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")

db = client["HospitalDB"]
medicines = db["medicines"]

medicines.delete_many({})

data = [
    {
        "medicine_id": "M101",
        "name": "Paracetamol",
        "category": "Tablet",
        "price": 25,
        "stock": 100,
        "manufacturer": "Cipla"
    },
    {
        "medicine_id": "M102",
        "name": "Dolo 650",
        "category": "Tablet",
        "price": 35,
        "stock": 80,
        "manufacturer": "Micro Labs"
    },
    {
        "medicine_id": "M103",
        "name": "Cough Syrup",
        "category": "Syrup",
        "price": 120,
        "stock": 20,
        "manufacturer": "Himalaya"
    },
    {
        "medicine_id": "M104",
        "name": "Vitamin C",
        "category": "Supplement",
        "price": 60,
        "stock": 50,
        "manufacturer": "Cipla"
    },
    {
        "medicine_id": "M105",
        "name": "Amoxicillin",
        "category": "Capsule",
        "price": 90,
        "stock": 15,
        "manufacturer": "Sun Pharma"
    },
    {
        "medicine_id": "M106",
        "name": "Cetirizine",
        "category": "Tablet",
        "price": 15,
        "stock": 60,
        "manufacturer": "Dr Reddy"
    },
    {
        "medicine_id": "M107",
        "name": "Antacid",
        "category": "Syrup",
        "price": 85,
        "stock": 25,
        "manufacturer": "Abbott"
    },
    {
        "medicine_id": "M108",
        "name": "Pain Relief Gel",
        "category": "Gel",
        "price": 150,
        "stock": 40,
        "manufacturer": "Volini"
    }
]

medicines.insert_many(data)

print("Database created successfully!")
print("8 Medicines inserted successfully!")

for medicine in medicines.find():
    print(medicine)

client.close()