var faker = require('faker');

module.exports = () => {
    const data = { data: [] }

    function randomString(length, chars) {
        var result = '';
        
        for (var i = length; i > 0; --i) result += chars[Math.floor(Math.random() * chars.length)];
        
        return result;
    }    
    
    for (let i = 0; i < 50; i++) {
        let outstandingBalance = balance = total = subtotal = price = Math.floor(Math.random() * 200).toFixed(1).toString();

        let firstName = faker.name.firstName();
        let lastName = faker.name.lastName();

        var verificationCode = randomString(6, '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');

        data.data.push({ 
            id: i, 
            type: 'orders',
            attributes: {
                'record_id': Math.floor(Math.random() * 1000000) + 1000000,
                'coupon_amount': null,
                'created_at': '2017-10-17T15:12:58.719-04:00',
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
                'updated_at': '2017-10-09T20:14:31.595-04:00',
                'verification_code': verificationCode,
                'balance': balance,
                'customer_email': faker.internet.email(),
                'customer_name': `${firstName} ${lastName}`,
                'customer_first_name': firstName,
                'customer_last_name': lastName
            }
        })
    }
    
    return data
}