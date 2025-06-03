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

router.post('/send-command/:classId', (req, res) => {
  const command = req.body.command;
  const { classId } = req.body;

  // Debug print to check the received data
  console.log("Received command:", command);
  console.log("Received classId:", classId);

  const payload = '{"device_developer_id":"' + device_developer_id + '","data":{"command":"' + command + '","classId":"' + classId + '"}}';
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

// 🆕 POST /mqtt/send
router.post('/controlUtility', (req, res) => {
  const { message , device_id } = req.body;
  const messageToSend = message.toLowerCase().trim();

  //Merge the device_id with the message to be e.g {device_id}_{message} = 'lamp1_on'
  const payloadMessage = device_id + '_' + messageToSend;

  //Debug print to check the received message
  // console.log("Received message:", message , messageToSend);

  // Validate the message
  if (!message || typeof message !== 'string' || message.trim() === '') {
    return res.status(400).send({
      Status_Code: 400,
      Message: 'Invalid or missing "message" in request body',
    });
  }

  if (!message) {
    return res.status(400).send({
      Status_Code: 400,
      Message: 'Missing "message" in request body',
    });
  }
  
  //Payload to send to MQTT
  const payload = JSON.stringify({
    data: {
      message: payloadMessage
    }
  });

  // Debug print to check the payload
  // console.log("Payload to MQTT:", payload);

  mqttClient.publish(topic, payload, (err) => {
    if (err) {
      console.error('❌ Error publishing to MQTT:', err);
      return res.status(500).send({
        Status_Code: 500,
        Message: 'Failed to send message',
      });
    }

    console.log('✅ MQTT message published:', payload);
    return res.status(200).send({
      Status_Code: 200,
      Message: 'Message sent successfully',
      Published: payload
    });
  });
});

module.exports = router;