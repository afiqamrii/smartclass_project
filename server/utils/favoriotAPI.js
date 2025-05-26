const axios = require("axios");

const FAVORIOT_BASE = "https://apiv2.favoriot.com/v2";
const FAVORIOT_HEADERS = {
  apiKey: process.env.FAVORIOT_API_KEY,
  "Content-Type": "application/json",
};

exports.createGroup = async (body) => {
  const res = await axios.post(`${FAVORIOT_BASE}/groups`, body, { headers: FAVORIOT_HEADERS });
  return res.data;
};

exports.createDevice = async (body) => {
  const res = await axios.post(`${FAVORIOT_BASE}/devices`, body, { headers: FAVORIOT_HEADERS });
  return res.data;
};
