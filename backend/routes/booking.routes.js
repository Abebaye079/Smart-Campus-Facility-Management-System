const express = require('express');
const router = express.Router();

const Booking = require('../models/booking.model');
const Facility = require('../models/facility.model');
const { protect } = require('../middleware/auth.middleware');


// =====================================
// GET BOOKINGS
// =====================================
router.get('/', protect, async (req, res) => {
  try {
    const bookings = await Booking.find({
      userId: req.user._id,
    });

    console.log('FETCHED BOOKINGS:', bookings);

    res.json(bookings);

  } catch (error) {
    console.log('GET BOOKINGS ERROR:', error);

    res.status(500).json({
      message: error.message,
    });
  }
});


// =====================================
// GET AVAILABILITY  ⭐ FIX ADDED HERE
// =====================================
router.get('/availability', protect, async (req, res) => {
  try {
    const { facilityId, date } = req.query;

    console.log('AVAILABILITY REQUEST:', req.query);

    if (!facilityId || !date) {
      return res.status(400).json({
        message: 'facilityId and date required',
      });
    }

    const ALL_SLOTS = [
      "8:30 AM - 10:30 AM",
      "10:30 AM - 12:30 PM",
      "1:30 PM - 3:30 PM",
      "3:30 PM - 5:30 PM",
    ];

    const bookings = await Booking.find({ facilityId, date });

    const bookedSlots = bookings.map(b => b.timeSlot);

    const availability = ALL_SLOTS.map(slot => ({
      time: slot,
      available: !bookedSlots.includes(slot),
    }));

    console.log('AVAILABILITY RESPONSE:', availability);

    res.json(availability);

  } catch (error) {
    console.log('AVAILABILITY ERROR:', error);

    res.status(500).json({
      message: error.message,
    });
  }
});


// =====================================
// CREATE BOOKING
// =====================================
router.post('/', protect, async (req, res) => {
  try {
    console.log('BOOKING REQUEST BODY:', req.body);

    const { facilityId, date, timeSlot, purpose } = req.body;

    if (!facilityId || !date || !timeSlot || !purpose) {
      return res.status(400).json({
        message: 'Missing required fields',
      });
    }

    if (!facilityId.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({
        message: 'Invalid facilityId format',
      });
    }

    const facility = await Facility.findById(facilityId);

    if (!facility) {
      return res.status(404).json({
        message: 'Facility not found',
      });
    }

    const existingBooking = await Booking.findOne({
      facilityId,
      date,
      timeSlot,
    });

    if (existingBooking) {
      return res.status(400).json({
        message: 'This time slot is already booked',
      });
    }

    const booking = await Booking.create({
      facilityId,
      facilityName: facility.name,
      userId: req.user._id,
      date,
      timeSlot,
      purpose,
      status: 'booked',
    });

    console.log('BOOKING CREATED:', booking);

    return res.status(201).json(booking);

  } catch (error) {
    console.log('CREATE BOOKING ERROR:', error);

    return res.status(500).json({
      message: error.message,
    });
  }
});


// =====================================
// UPDATE BOOKING
// =====================================
router.put('/:id', protect, async (req, res) => {
  try {
    const { date, timeSlot, purpose } = req.body;

    const booking = await Booking.findOne({
      _id: req.params.id,
      userId: req.user._id,
    });

    if (!booking) {
      return res.status(404).json({
        message: 'Booking not found',
      });
    }

    const newDate = date || booking.date;
    const newTimeSlot = timeSlot || booking.timeSlot;

    if (newDate !== booking.date || newTimeSlot !== booking.timeSlot) {
      const existingBooking = await Booking.findOne({
        facilityId: booking.facilityId,
        date: newDate,
        timeSlot: newTimeSlot,
        _id: { $ne: req.params.id },
      });

      if (existingBooking) {
        return res.status(400).json({
          message: 'This time slot is already booked',
        });
      }
    }

    booking.date = newDate;
    booking.timeSlot = newTimeSlot;
    booking.purpose = purpose || booking.purpose;

    await booking.save();

    res.json(booking);

  } catch (error) {
    console.log('UPDATE BOOKING ERROR:', error);

    res.status(500).json({
      message: error.message,
    });
  }
});


// =====================================
// DELETE BOOKING
// =====================================
router.delete('/:id', protect, async (req, res) => {
  try {
    const booking = await Booking.findOne({
      _id: req.params.id,
      userId: req.user._id,
    });

    if (!booking) {
      return res.status(404).json({
        message: 'Booking not found',
      });
    }

    await Booking.findByIdAndDelete(req.params.id);

    res.json({
      message: 'Booking cancelled successfully',
    });

  } catch (error) {
    console.log('DELETE BOOKING ERROR:', error);

    res.status(500).json({
      message: error.message,
    });
  }
});

module.exports = router;