const mongoose = require('mongoose');

const facilitySchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, 'Facility name is required'],
        trim: true,
    },
    capacity: {
        type: Number,
        required: [true, 'Capacity is required'],
    },
    description: {
        type: String,
        required: [true, 'Description is required'],
        trim: true,
    },
    type: {
        type: String,
        required: [true, 'Type is required'],
        trim: true,
    },
}, {
    timestamps: true,
});

module.exports = mongoose.model('Facility', facilitySchema);