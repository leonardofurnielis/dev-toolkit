"use strict";

const jwt = require("jsonwebtoken");
const RSA = require("node-rsa");

const getToken = async (req, res, next) => {
  try {
    const payload = {
      /*
       * Even if this is an unauthenticated user, add a userID in the sub claim that can be used
       * for billing purposes.
       * This ID will help us keep track "unique users". For unauthenticated users, drop a
       * cookie in the browser so you can make sure the user is counted uniquely across visits.
       */
      sub: "00001", // Required
      iss: "yourdomain.com", // Required
    };

    const privateKEY = process.env.JWT_PRIVATE_KEY;
    const rsaKey = new RSA(process.env.IBM_PUBLIC_KEY);

    payload.user_payload = rsaKey.encrypt(
      JSON.stringify({ gov_id: "999.999.999-99" }),
      "base64"
    );

    const token = jwt.sign(payload, privateKEY, {
      algorithm: "RS256",
      expiresIn: "1m",
    });

    return res.status(200).send(token);
  } catch (err) {
    next(err);
  }
};

module.exports = {
  getToken,
};
