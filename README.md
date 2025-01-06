# Little Lemon Database Project

This repository contains the database schema, stored procedures, and data analysis steps for the Little Lemon booking system.

## Overview
- **Objective**: Create a MySQL database for managing restaurant bookings, orders, and menu items.
- **Data Model**: Includes tables such as `customers`, `booking`, `staff`, `menu`, `orders`, and `order_items`.
- **Stored Procedures**: Implements logic for adding, managing, updating, and canceling bookings, as well as retrieving maximum item quantity.

## Contents
1. **`little_lemon_schema.sql`**  
   - Creates the `little_lemon` database and all necessary tables.  
   - Inserts sample data.  
   - Defines stored procedures (`addbooking`, `managebooking`, `updatebooking`, `cancelbooking`, `getmaxquantity`).

2. **`ER_diagram.png`**  
   - Shows the entity-relationship diagram for the Little Lemon database.

3. **`LittleLemon_Analysis.twb`**  
   - Tableau workbook containing worksheets and dashboards for data analysis (booking trends, menu sales, staff distribution).
   - Covers booking trends, menu sales, staff distribution, etc.

4. **`little_lemon.ipynb`**  
   - Demonstrates how to connect to the `little_lemon` database  
   - Shows examples of calling stored procedures (e.g., `addbooking`, `managebooking`)  
   - Can be extended for additional data handling or logic

5**`README.md`**  
   - Project description, setup instructions, and usage details (this file).

## How to Use
1. **MySQL Setup**  
   - Run `little_lemon_schema.sql` in MySQL Workbench or via the command line:
     ```bash
     mysql -u root -p < little_lemon_schema.sql
     ```
   - Confirm tables and procedures were created successfully in the `little_lemon` database.

   2. **Stored Procedures**  
      - Call procedures directly in MySQL:
        ```sql
        CALL addbooking(1, '2025-05-10', '19:00:00', 5);
        ```
      - Or use a Python client to connect and execute:
        ```python
        cursor.callproc('addbooking', [1, '2025-05-10', '19:00:00', 5])
        connection.commit()
        ```

3. **Tableau Visualization**  
   - Open `LittleLemon_Analysis.twbx` in Tableau.  
   - Explore worksheets and dashboards on bookings, menu items, and more.

## License
Feel free to use or modify this project for educational purposes. Refer to the repository for any specific license details.

**Enjoy exploring the Little Lemon booking system!**
