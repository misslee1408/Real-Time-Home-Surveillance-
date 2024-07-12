//This file sets up routes for handling HTTP requests related to users.

const express = require('express');
const router = express.Router();
// flonicah
const userController = require('../controllers/userController');

router.post('/', userController.createUser);

router.get('/:id', userController.getUserbyId);


module.exports = router;
