const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router();
const middlewares = jsonServer.defaults();

let mockData = require('./index');

// Add custom routes before JSON Server router
server.get('/echo', (req, res) => {
    res.jsonp(mockData().orders)
});

server.use(middlewares);
server.use(router);
server.listen(3000, () => {
    console.log('JSON Server is running')
});