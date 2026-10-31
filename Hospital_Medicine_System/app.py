from flask import Flask, render_template, request, redirect, url_for
from pymongo import MongoClient

app = Flask(__name__)

client = MongoClient("mongodb://localhost:27017/")

db = client["HospitalDB"]
medicines = db["medicines"]

# Home Page
@app.route('/')
def home():
    return render_template('index.html')


# Q5 - Add Medicine
@app.route('/add', methods=['GET', 'POST'])
def add():
    if request.method == 'POST':

        data = {
            "medicine_id": request.form['medicine_id'],
            "name": request.form['name'],
            "category": request.form['category'],
            "price": float(request.form['price']),
            "stock": int(request.form['stock']),
            "manufacturer": request.form['manufacturer']
        }

        if medicines.find_one({"medicine_id": data["medicine_id"]}):
            return "Medicine ID already exists!"

        medicines.insert_one(data)

        return redirect(url_for('view'))

    return render_template('add.html')


# Q6 - View Medicines
@app.route('/view')
def view():
    data = list(medicines.find())
    return render_template('view.html', medicines=data)


# Q7 - Search Medicine
@app.route('/search', methods=['GET', 'POST'])
def search():

    result = None
    message = ""

    if request.method == 'POST':

        keyword = request.form['keyword']

        result = medicines.find_one({
            "$or": [
                {"medicine_id": keyword},
                {"name": {"$regex": keyword, "$options": "i"}}
            ]
        })

        if result is None:
            message = "Medicine not found!"

    return render_template(
        'search.html',
        medicine=result,
        message=message
    )


# Q8 - Update Stock
@app.route('/update', methods=['GET', 'POST'])
def update():

    message = ""

    if request.method == 'POST':

        medicine_id = request.form['medicine_id']
        stock = int(request.form['stock'])

        result = medicines.update_one(
            {"medicine_id": medicine_id},
            {"$set": {"stock": stock}}
        )

        if result.matched_count > 0:
            message = "Stock updated successfully!"
        else:
            message = "Medicine not found!"

    return render_template('update.html', message=message)


# Q9 - Delete Medicine
@app.route('/delete', methods=['GET', 'POST'])
def delete():

    message = ""

    if request.method == 'POST':

        medicine_id = request.form['medicine_id']

        result = medicines.delete_one(
            {"medicine_id": medicine_id}
        )

        if result.deleted_count > 0:
            message = "Medicine deleted successfully!"
        else:
            message = "Medicine not found!"

    return render_template('delete.html', message=message)


# Low Stock Medicines
@app.route('/low-stock')
def low_stock():

    data = list(medicines.find({"stock": {"$lt": 30}}))

    return render_template('low_stock.html', medicines=data)


# Q11 - Embedded Supplier Information
@app.route('/supplier', methods=['GET', 'POST'])
def supplier():

    message = ""

    if request.method == 'POST':

        data = {
            "medicine_id": request.form['medicine_id'],
            "name": request.form['name'],
            "category": request.form['category'],
            "price": float(request.form['price']),
            "stock": int(request.form['stock']),
            "manufacturer": request.form['manufacturer'],

            "supplier": {
                "name": request.form['supplier_name'],
                "phone": request.form['phone'],
                "city": request.form['city']
            }
        }

        if medicines.find_one({"medicine_id": data["medicine_id"]}):
            message = "Medicine ID already exists!"
        else:
            medicines.insert_one(data)
            message = "Medicine with supplier added successfully!"

    data = list(medicines.find({"supplier": {"$exists": True}}))

    return render_template(
        'supplier.html',
        medicines=data,
        message=message
    )


# Q12 - Inventory Report
@app.route('/report')
def report():

    total_medicines = medicines.count_documents({})

    result = list(medicines.aggregate([
        {
            "$group": {
                "_id": None,
                "total_stock": {"$sum": "$stock"}
            }
        }
    ]))

    total_stock = result[0]['total_stock'] if result else 0

    low_stock_count = medicines.count_documents(
        {"stock": {"$lt": 30}}
    )

    expensive = medicines.find_one(
        sort=[("price", -1)]
    )

    cheapest = medicines.find_one(
        sort=[("price", 1)]
    )

    return render_template(
        'report.html',
        total_medicines=total_medicines,
        total_stock=total_stock,
        low_stock_count=low_stock_count,
        expensive=expensive,
        cheapest=cheapest
    )


# Run Application
if __name__ == '__main__':
    try:
        client.admin.command('ping')
        print("MongoDB Connected Successfully!")
        app.run(debug=True)
    except Exception as e:
        print("MongoDB Connection Error:", e)