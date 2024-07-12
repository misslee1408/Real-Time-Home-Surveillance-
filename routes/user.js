//This file sets up routes for handling HTTP requests related to users.

const express = require('express');
const router = express.Router();
// flonicah
const userController = require('../controllers/userController');

// creating the routes for post and get
router.post('/', userController.createUser);

//router.get('/')this handles GET requests to fetch all users.
router.get('/', userController.getAllUsers);

router.get('/:id', userController.getUserbyId); //getting users using the id

module.exports = router;
