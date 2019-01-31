const request = require('supertest');
const pkg = require('../../package');

const app = require('../server');


describe('index route', () => {
  const { uptime } = process;

  beforeEach(() => {
    process.uptime = () => 42;
  });

  afterEach(() => {
    process.uptime = uptime;
    app.server.close();
  });

  test('should respond with a 200 and status json', () => request(app)
    .get('/')
    .expect('Content-Type', 'application/json; charset=utf-8')
    .expect(200)
    .then((response) => {
      expect(response.body).toMatchObject({
        name: pkg.name,
        version: pkg.version,
        uptime: process.uptime(),
      });
    }));
});
