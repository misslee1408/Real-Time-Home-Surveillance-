const express = require('express');
const router = express.Router();  // Create a new router instance
const userController = require('../controllers/userController');
const ensureAuthenticated = require('../middleware/auth');

// Authentication routes
router.post('/register', userController.registerUser);
router.post('/login', userController.loginUser);

// Protected route
router.get('/protected', ensureAuthenticated, (req, res) => {
  res.json({ message: 'You are authenticated' });
});

// Other user routes
router.get('/', userController.getAllUsers);        // Ensure getAllUsers is defined
router.post('/', userController.createUser);        // Ensure createUser is defined
router.get('/:id', userController.getUserbyId);     // Ensure getUserbyId is defined
router.delete('/:id', userController.deleteUser);   // Ensure deleteUser is defined

module.exports = router;  // Export the router
