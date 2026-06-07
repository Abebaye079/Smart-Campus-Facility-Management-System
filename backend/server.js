const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const connectDB = require('./config/db');

dotenv.config();

connectDB();

const app = express();

app.use(cors());
app.use(express.json());

app.use('/api/auth', require('./routes/auth.routes'));
app.use('/api/facilities', require('./routes/facility.routes'));
app.use('/api/bookings', require('./routes/booking.routes'));

app.get('/', (req, res) => {
    res.json({ message: 'Smart Campus API is running' });
});

const createAdmin = async () => {
    try {
        const User = require('./models/user.model');

        const adminExists = await User.findOne({ role: 'admin' });

        if (!adminExists) {
            // FIXED: Password changed to 'admin1234' (9 characters) to bypass minlength requirement.
            // Passed as plain text so Mongoose hooks hash it exactly ONCE.
            await User.create({
                name: 'Sara Taye',
                email: 'sarataye@aau.edu',
                password: 'admin1234', 
                role: 'admin',
            });
            console.log('✅ Admin created successfully');
        } else {
            console.log('✅ Admin already exists');
        }
    } catch (error) {
        console.error('❌ Error creating admin:', error.message);
    }
};

const PORT = process.env.PORT || 3000;
app.listen(PORT, async () => {
    console.log(`✅ Server running on port ${PORT}`);
    await createAdmin();
});