const express = require('express');
const controller = require('../../../src/api/v1/token/token-controller');

module.exports = (middlewares) => {
  const router = express.Router();

  if (middlewares) {
    middlewares.forEach((middleware) => router.use(middleware));
  }

  router.get('/', controller.getToken);

  return router;
};