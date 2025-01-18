const mqtt = require('mqtt');

const mqttClient = mqtt.connect('mqtt://mqtt.favoriot.com', {
  username: 'afQI0FOKCBEvmdgGfDb2JqC6UnNOc6GM',
  password: 'afQI0FOKCBEvmdgGfDb2JqC6UnNOc6GM',
  deviceid: 'ESP32@afiqamri03'
});

const username = 'afQI0FOKCBEvmdgGfDb2JqC6UnNOc6GM';
const device_developer_id = 'ESP32@afiqamri03';
const topic = `${username}/v2/streams`;

mqttClient.on('connect', () => {
  console.log('Connected to MQTT broker');
});

const express = require('express');
const router = express.Router();

router.use(express.json());
router.use(express.urlencoded({ extended: true }));

router.post('/send-command', (req, res) => {
  const command = req.body.command;
  const payload = '{"device_developer_id":"' + device_developer_id + '","data":{"command":"' + command + '"}}';
  mqttClient.publish(topic, payload, (err) => {
    if (err) {
      console.error('Error publishing to MQTT:', err);
      res.status(500).send({
        Status_Code: 500,
        Message: 'Failed to send command'
      });
    } else {
      console.log('Command sent successfully');
      res.status(200).send({
        Status_Code: 200,
        Message: 'Command sent successfully'
      });
    }
  });
});

module.exports = router;

