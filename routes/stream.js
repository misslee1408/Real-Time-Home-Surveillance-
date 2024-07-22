const express = require('express');
const router = express.Router();
const axios = require('axios');
const fs = require('fs');
const { Camera, Footage } = require('../models'); // Adjust the path as necessary

// Endpoint to capture and save the stream by camera ID
router.post('/capture/:id', async (req, res) => {
    const cameraId = req.params.id;

    try {
        const camera = await Camera.findByPk(cameraId);

        if (!camera) {
            return res.status(404).json({ error: 'Camera not found' });
        }

        const response = await axios({
            url: camera.url,
            method: 'GET',
            responseType: 'stream'
        });

        const outputFilePath = `footage_${cameraId}_${Date.now()}.mp4`;
        const outputStream = fs.createWriteStream(outputFilePath);

        response.data.pipe(outputStream);

        outputStream.on('finish', async () => {
            console.log('Stream captured successfully.');

            // Save the footage metadata to the database
            const footage = await Footage.create({
                cameraId: camera.id,
                path: outputFilePath,
                timestamp: new Date(),
            });

            res.status(200).json({
                message: 'Stream captured successfully.',
                footage,
            });
        });

        outputStream.on('error', (error) => {
            console.error('Error capturing stream:', error);
            res.status(500).json({ error: 'Error capturing stream.' });
        });

    } catch (error) {
        console.error('Error capturing stream:', error.message);
        res.status(500).json({ error: 'Error capturing stream.' });
    }
});

module.exports = router;
