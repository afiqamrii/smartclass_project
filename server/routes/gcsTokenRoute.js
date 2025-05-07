const express = require('express');
const { GoogleAuth } = require('google-auth-library');
const router = express.Router();

const auth = new GoogleAuth({
  keyFile: 'gcs-service-account.json',
  scopes: ['https://www.googleapis.com/auth/devstorage.read_write'],
});

router.get("/gcs-token", async (req, res) => {
  try {
    const client = await auth.getClient();
    const accessTokenResponse = await client.getAccessToken();

    if (!accessTokenResponse || !accessTokenResponse.token) {
      return res.status(500).json({ error: 'Failed to get access token' });
    }

    res.json({
      token: accessTokenResponse.token,
      expires_in: 3600,
    });

    console.log("GCS token:", accessTokenResponse.token);
  } catch (error) {
    console.error("GCS token error:", error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

module.exports = router;
