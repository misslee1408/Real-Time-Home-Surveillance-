//This file sets up routes for handling HTTP requests related to users.

const express = require('express');
const router = express.Router();
// flonicah
const userController = require('../controllers/userController');


router.get('/', userController.getAllUsers);

router.post('/', userController.createUser);

router.get('/:id', userController.getUserbyId);

router.delete('/:id', userController.deleteUser);


module.exports = router;
