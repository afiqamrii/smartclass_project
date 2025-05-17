const express = require('express');
const { GoogleAuth } = require('google-auth-library');
const router = express.Router();

let credentials;
let auth;

// Immediately invoked function to initialize GoogleAuth with credentials
(async () => {
    try {
        // Parse the JSON credentials string from the environment variable
        if (process.env.GOOGLE_APPLICATION_CREDENTIALS_JSON) {
            credentials = JSON.parse(process.env.GOOGLE_APPLICATION_CREDENTIALS_JSON);

            // Fix formatting of private_key by replacing escaped newlines
            if (credentials.private_key) {
                credentials.private_key = credentials.private_key.replace(/\\n/g, '\n');
            }

            // Initialize the GoogleAuth instance with required scope
            auth = new GoogleAuth({
                scopes: ['https://www.googleapis.com/auth/devstorage.read_write'],
            });

            // Load the credentials into the auth instance
            await auth.fromJSON(credentials);
        } else {
            console.error("GOOGLE_APPLICATION_CREDENTIALS_JSON environment variable is missing.");
        }
    } catch (error) {
        console.error("Failed to initialize GoogleAuth with provided credentials:", error);
    }
})();

// Route: GET /gcs-token
// Description: Returns an access token for Google Cloud Storage
router.get("/gcs-token", async (req, res) => {
    try {
        // Ensure auth has been initialized
        if (!auth) {
            return res.status(500).json({ error: 'GoogleAuth is not initialized.' });
        }

        // Get the authenticated client
        const client = await auth.getClient();

        // Retrieve the access token
        const accessTokenResponse = await client.getAccessToken();

        // Handle error if token is not available
        if (!accessTokenResponse || !accessTokenResponse.token) {
            return res.status(500).json({ error: 'Failed to get access token' });
        }

        // Return token and expiry (3600 seconds = 1 hour)
        res.json({
            token: accessTokenResponse.token,
            expires_in: 3600,
        });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error', details: error.message });
    }
});

module.exports = router;
