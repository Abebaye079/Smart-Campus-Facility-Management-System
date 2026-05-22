const express = require('express');
const router = express.Router();
const Booking = require('../models/booking.model');
const Facility = require('../models/facility.model');
const { protect } = require('../middleware/auth.middleware');

router.get('/', protect, async (req, res) => {
  try {
    const bookings = await Booking.find({
      userId: req.user._id,
    });

    res.json(bookings);
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
});

router.post('/', protect, async (req, res) => {
  try {
    const { facilityId, date, timeSlot, purpose } = req.body;

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

    res.status(201).json(booking);

  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
});

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

    if (
      newDate !== booking.date ||
      newTimeSlot !== booking.timeSlot
    ) {
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
    res.status(500).json({
      message: error.message,
    });
  }
});

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
    res.status(500).json({
      message: error.message,
    });
  }
});

module.exports = router;