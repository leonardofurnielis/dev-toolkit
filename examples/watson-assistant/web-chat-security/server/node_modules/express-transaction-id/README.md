# express-transaction-id

![npm](https://img.shields.io/npm/v/express-transaction-id)
![workflow](https://github.com/leonardofurnielis/express-transaction-id/actions/workflows/build-test.yml/badge.svg)
[![codecov](https://codecov.io/gh/leonardofurnielis/express-transaction-id/branch/master/graph/badge.svg)](https://codecov.io/gh/leonardofurnielis/express-transaction-id)
![GitHub](https://img.shields.io/github/license/leonardofurnielis/express-transaction-id.svg)
![npm](https://img.shields.io/npm/dm/express-transaction-id.svg)

Express middleware to set a transaction id, unique identifier value that is attached to requests.

## Installation 

```bash
npm install express-transaction-id --save
```

## Usage

In an [express](https://www.npmjs.com/package/express) based application:

```js

const  express = require('express');
const  transactionId = require('express-transaction-id');
  
const  app = express();

app.use(transactionId({ header: 'x-global-transaction-id' }));

// Setup your routes
app.get('/foo', (req, res, next) => {
   return res.status(200).json({ transaction_id: req.getId() });
});

```

## Options

| Option | Type | Default | Description  |
| ------ |------|---------| ------------ |
| header | String | `x-transaction-id`| The name of the inbound header to check for a transaction id. |

## Methods

### getId()

This methods is added to the incoming request by `express-transaction-id`, and will allow you to get `transaction_id` of current request.

```js
req.getId(); // 1c204313-6526-4f36-b32f-a36a410c4ed8
```

## License

[Apache-2.0](LICENSE)
