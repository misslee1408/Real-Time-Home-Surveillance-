// controllers/cameraController.js
const { Camera } = require('../models');


/* getAllCameras: Fetches all cameras from the database (the two cameras), if it does not find the cameras
then the error message is displayed */
exports.getAllCameras = async (req, res) => {
  try {
    const cameras = await Camera.findAll();
    res.json(cameras);
  } catch (error) {
    res.status(500).json({ error: 'oops!! Failed to fetch cameras' });
  }
};

/*addCamera: Adds a new camera to the database using data from the request body.
so suppose the kitchen has a new camera so the end user can update the system */
exports.addCamera = async (req, res) => {
  try {
    const camera = await Camera.create(req.body);
    res.status(201).json(camera);
  } catch (error) {
    res.status(500).json({ error: 'oops! Failed to add camera' });
  }
};

// getCameraById: Fetches a single camera by its ID, like the one camera for the front dooor
exports.getCameraById = async (req, res) => {
  try {
    const camera = await Camera.findByPk(req.params.id);
    if (camera) {
      res.json(camera);
    } else {
      res.status(404).json({ error: 'oh oh! Camera not found' });
    }
  } catch (error) {
    res.status(500).json({ error: 'oops Failed to fetch camera' });
  }
};


//updateCamera: Updates a camera's information using data from the request body and its ID.
exports.updateCamera = async (req, res) => {
  try {
    const [updated] = await Camera.update(req.body, {
      where: { id: req.params.id }
    });
    if (updated) {
      const updatedCamera = await Camera.findByPk(req.params.id);
      res.json(updatedCamera);
    } else {
      res.status(404).json({ error: 'oh oh Camera not found' });
    }
  } catch (error) {
    res.status(500).json({ error: 'oops! Failed to update camera' });
  }
};

//deleteCamera: Deletes a camera by its ID.
exports.deleteCamera = async (req, res) => {
  try {
    const deleted = await Camera.destroy({
      where: { id: req.params.id }
    });
    if (deleted) {
      res.status(204).json();
    } else {
      res.status(404).json({ error: 'oh oh Camera not found' });
    }
  } catch (error) {
    res.status(500).json({ error: 'oops! Failed to delete camera' });
  }
};

