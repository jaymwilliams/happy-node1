const pkg = require('../../package');

module.exports = {
  getStatus(req, res) {
    const body = {
      name: pkg.name,
      version: pkg.version,
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
