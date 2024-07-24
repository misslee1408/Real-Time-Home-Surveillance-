const bcrypt = require('bcrypt');
const { User } = require('../models'); // Adjust the path as needed

const saltRounds = 10; // Number of salt rounds for hashing passwords

// Register a new user
const registerUser = async (req, res) => {
  const { username, email, password } = req.body;

  console.log('Request body:', req.body); // Log the request body

  // Validate request body
  if (!username || !email || !password) {
    return res.status(400).json({ message: 'Username, email, and password are required' });
  }

  try {
    // Check if the user already exists
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      console.log('User already exists:', existingUser); // Log existing user
      return res.status(400).json({ message: 'User already exists' });
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    // Create the new user
    const newUser = await User.create({
      username,
      email,
      password: hashedPassword,
      isActive: true,
    });

    console.log('New user created:', newUser); // Log the new user

    res.status(201).json({ message: 'User registered successfully', user: newUser });
  } catch (error) {
    console.error('Error during user registration:', error); // Log the error for debugging
    res.status(500).json({ message: 'Server error', error: error.message }); // Send the error message
  }
};

// Login a user
const loginUser = async (req, res) => {
  const { email, password } = req.body;

  console.log('Request body:', req.body); // Log the request body

  // Validate request body
  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required' });
  }

  try {
    // Find the user by email
    const user = await User.findOne({ where: { email } });
    if (!user) {
      console.log('User not found:', email); // Log if user not found
      return res.status(400).json({ message: 'Invalid email or password' });
    }

    // Compare the password
    const match = await bcrypt.compare(password, user.password);
    if (!match) {
      console.log('Password mismatch for user:', user); // Log password mismatch
      return res.status(400).json({ message: 'Invalid email or password' });
    }

    req.session.user = {
      id: user.id,
      username: user.username,
      email: user.email,
    };

    console.log('User logged in:', req.session.user); // Log successful login

    res.status(200).json({ message: 'Login successful' });
  } catch (error) {
    console.error('Error during user login:', error); // Log the error for debugging
    res.status(500).json({ message: 'Server error', error: error.message }); // Send the error message
  }
};

const getAllUsers = async (req, res) => {
  try {
    const users = await User.findAll();
    res.json(users);
  } catch (error) {
    console.error('Error fetching users:', error); // Log the error for debugging
    res.status(500).json({ message: 'Error fetching users', error: error.message }); // Send the error message
  }
};

// Create a user
const createUser = async (req, res) => {
  const { username, email, password, isActive } = req.body;

  try {
    const hashedPassword = await bcrypt.hash(password, saltRounds);
    const newUser = await User.create({
      username,
      email,
      password: hashedPassword,
      isActive,
    });
    res.status(201).json({ message: 'User created successfully', user: newUser });
  } catch (error) {
    console.error('Error creating user:', error); // Log the error for debugging
    res.status500.json({ message: 'Server error', error: error.message }); // Send the error message
  }
};

// Get a user by ID
const getUserById = async (req, res) => {
  const { id } = req.params;

  try {
    const user = await User.findByPk(id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.status(200).json(user);
  } catch (error) {
    console.error('Error fetching user by ID:', error); // Log the error for debugging
    res.status(500).json({ message: 'Server error', error: error.message }); // Send the error message
  }
};

// Delete a user
const deleteUser = async (req, res) => {
  const { id } = req.params;

  try {
    const result = await User.destroy({ where: { id } });
    if (!result) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.status(200).json({ message: 'User deleted successfully' });
  } catch (error) {
    console.error('Error deleting user:', error); // Log the error for debugging
    res.status(500).json({ message: 'Server error', error: error.message }); // Send the error message
  }
};

module.exports = {
  registerUser,
  loginUser,
  getAllUsers,
  createUser,
  getUserById,
  deleteUser,
};
