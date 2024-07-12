// controllers/userController.js 
const { User } = require('../models');



exports.createUser = async (req, res) => {
    try {
        const users = await user.create(req.body);
        res.json(users);
    } catch (error) {
        res.status(500).json({ error: 'oops failed to create user' });
    }
};

exports.getUserbyId = async (req, res) => {
    try {
        const user = await User.findByPk(req.params.id);
        if (user) {
            res.json(user);
        } else {
            res.status(404).json({ error: 'user not found' });
        }
    }
    catch (error) {
        res.status(500).json({ error: 'failed to fetch user' });
    }
};
