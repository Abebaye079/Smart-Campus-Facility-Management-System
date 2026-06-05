const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const User = require('../models/user.model');
const { protect } = require('../middleware/auth.middleware');

const generateToken = (id) => {
    return jwt.sign({ id }, process.env.JWT_SECRET || 'fallback_secret', {
        expiresIn: process.env.JWT_EXPIRES_IN || '30d',
    });
};

router.post('/register', async (req, res) => {
    try {
        const { name, email, password } = req.body;

        if (!name || !email || !password) {
            return res.status(400).json({ message: 'Please fill in all fields' });
        }

        const sanitizedEmail = email.trim().toLowerCase();

        const userExists = await User.findOne({ email: sanitizedEmail });
        if (userExists) {
            return res.status(400).json({ message: 'User already exists' });
        }

        const user = await User.create({ 
            name: name.trim(), 
            email: sanitizedEmail, 
            password: password.trim() 
        });

        res.status(201).json({
            id: user._id,
            name: user.name,
            email: user.email,
            role: user.role,
            token: generateToken(user._id),
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ message: 'Please provide email and password' });
        }

        const sanitizedEmail = email.trim().toLowerCase();
        const user = await User.findOne({ email: sanitizedEmail });

        if (!user || !(await user.matchPassword(password.trim()))) {
            return res.status(401).json({ message: 'Invalid email or password' });
        }

        res.json({
            id: user._id,
            name: user.name,
            email: user.email,
            role: user.role,
            token: generateToken(user._id),
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.post('/logout', protect, async (req, res) => {
    try {
        res.json({ message: 'Logged out successfully' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.delete('/account', protect, async (req, res) => {
    try {
        await User.findByIdAndDelete(req.user._id);
        res.json({ message: 'Account deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;
