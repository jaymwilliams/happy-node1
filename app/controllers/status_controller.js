const pkg = require('../../package');

module.exports = {
  getStatus(req, res) {
    const body = {
      name: pkg.name,
      version: '2.0',
      uptime: process.uptime(),
    };
    if (process.env.ENVIRONMENT_NAME) {
      res.json(Object.assign({}, body, {
        environment: process.env.ENVIRONMENT_NAME,
      }));
    } else {
      res.json(body);
    }
  },
};
