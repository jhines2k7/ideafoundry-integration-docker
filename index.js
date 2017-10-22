var faker = require('faker');

module.exports = () => {
    const data = { 
        orders: {
            data: []
        } 
    }

    function randomString(length, chars) {
        var result = '';
        
        for (var i = length; i > 0; --i) result += chars[Math.floor(Math.random() * chars.length)];
        
        return result;
    }

    function randomDate(start, end) {
        return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime())).toISOString();
    }
    
    for (let i = 0; i < 50; i++) {
        let outstandingBalance = balance = total = subtotal = price = Math.floor(Math.random() * 200).toFixed(1).toString();

        let firstName = faker.name.firstName();
        let lastName = faker.name.lastName();

        let verificationCode = randomString(6, '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');

        let date = randomDate(new Date(2014, 0, 1), new Date());

        data.orders.data.push({ 
            id: i, 
            type: 'orders',
            attributes: {
                'record_id': Math.floor(Math.random() * 1000000) + 1000000,
                'coupon_amount': null,
                'created_at': date,
                'description': faker.commerce.productName(),
                'gift_card_amount': null,
                'outstanding_balance': outstandingBalance,                
                'price': price,
                'quantity': 1,
                'status': 'booked',
                'subtotal': subtotal,
                'tax': '0.0',
                'tax_percentage': '0.0',
                'total': total,
                'updated_at': date,
                'verification_code': verificationCode,
                'balance': balance,
                'customer_email': faker.internet.email(),
                'customer_name': `${firstName} ${lastName}`,
                'customer_first_name': firstName,
                'customer_last_name': lastName,
                'customer_zip': faker.address.zipCode()
            }
        })
    }
    
    return data
}