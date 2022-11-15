/*
 * express-transaction-id
 * Licensed under Apache-2.0 License
 */

'use strcit';

const uuid = require('uuid');

/**
 * Express unique identifier value that is attached to requests.
 * @param {Object} [options]
 * @param {Boolean} options.header - Configure the name header to be attached in requests.
 * @return {VoidFunction}
 */
module.exports = (options = {}) => {
  const transactionId = options.custom_header || 'x-transaction-id';

  return (req, res, next) => {
    const getId = (transactionId) => {
      return () => {
        return transactionId;
      };
    };

    if (
      !req.headers[transactionId] ||
      (req.headers[transactionId] && req.headers[transactionId].trim() === '')
    ) {
      const id = uuid.v1();
      res.setHeader(transactionId, id);
      req.getId = getId(id);
      next();
    } else {
      res.setHeader(transactionId, req.headers[transactionId]);
      req.getId = getId(req.headers[transactionId]);
      next();
    }
  };
};
