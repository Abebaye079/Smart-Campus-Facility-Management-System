const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
    facilityId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Facility',
        required: [true, 'Facility is required'],
    },
    facilityName: {
        type: String,
        required: [true, 'Facility name is required'],
    },
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: [true, 'User is required'],
    },
    date: {
        type: String,
        required: [true, 'Date is required'],
    },
    timeSlot: {
        type: String,
        required: [true, 'Time slot is required'],
    },
    purpose: {
        type: String,
        required: [true, 'Purpose is required'],
    },
    status: {
        type: String,
        enum: ['booked', 'available'],
        default: 'booked',
    },
}, {
    timestamps: true,
});

module.exports = mongoose.model('Booking', bookingSchema)