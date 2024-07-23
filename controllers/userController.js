const bcrypt = require('bcrypt');
const User = require('../models/User'); // Adjust the path to your User model

const saltRounds = 10; // Number of salt rounds for hashing passwords

// Register a new user
const registerUser = async (req, res) => {
  const { username, email, password } = req.body;

  try {
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists' });
    }

    const hashedPassword = await bcrypt.hash(password, saltRounds);

    const newUser = await User.create({
      username,
      email,
      password: hashedPassword,
      isActive: true,
    });

    res.status(201).json({ message: 'User registered successfully', user: newUser });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Login a user
const loginUser = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }

    const match = await bcrypt.compare(password, user.password);
    if (!match) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }

    req.session.user = {
      id: user.id,
      username: user.username,
      email: user.email,
    };

    res.status(200).json({ message: 'Login successful' });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Additional user controller functions (make sure these are defined)
const getAllUsers = async (req, res) => { /* ... */ };
const createUser = async (req, res) => { /* ... */ };
const getUserbyId = async (req, res) => { /* ... */ };
const deleteUser = async (req, res) => { /* ... */ };

module.exports = {
  registerUser,
  loginUser,
  getAllUsers,  // Ensure this is defined and exported
  createUser,   // Ensure this is defined and exported
  getUserbyId,  // Ensure this is defined and exported
  deleteUser,   // Ensure this is defined and exported
};
