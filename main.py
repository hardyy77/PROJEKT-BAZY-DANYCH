import random

trailer_types = ['1', '2', '3','4','5', '6', '7']

for i in range(1, 101):
    trailer_id = i
    id = i

    typ = random.choice(trailer_types)


    query = f"UPDATE orders SET Track_ID='{id}' WHERE order_ID={trailer_id};"
    print(query)