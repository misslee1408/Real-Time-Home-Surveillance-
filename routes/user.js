//This file sets up routes for handling HTTP requests related to users.
const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// Authentication routes
router.post('/register', userController.registerUser);
router.post('/login', userController.loginUser);

// Existing user routes
router.get('/', userController.getAllUsers);
router.post('/', userController.createUser);
router.get('/:id', userController.getUserbyId);
router.delete('/:id', userController.deleteUser);

module.exports = router;
