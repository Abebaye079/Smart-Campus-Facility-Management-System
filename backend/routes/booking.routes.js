const express = require('express');
const router = express.Router();
const Booking = require('../models/booking.model');
const { protect } = require('../middleware/auth.middleware');

// GET ALL BOOKINGS FOR LOGGED IN USER ONLY 
router.get('/', protect, async (req, res) => {
  try {
    const bookings = await Booking.find({ userId: req.user.id });
    res.json(bookings);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

router.get('/:id', protect, async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id);
    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }
    
    // Security Guard: Prevent other users from reading someone else's document
    if (booking.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized to access this booking record' });
    }
    
    res.json(booking);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

//  CREATE NEW BOOKING RECORD 
router.post('/', protect, async (req, res) => {
  try {
    const { facilityId, facilityName, date, timeSlot, purpose } = req.body;
    
    const booking = await Booking.create({
      userId: req.user.id, 
      facilityId,
      facilityName,
      date,
      timeSlot,
      purpose,
      status: 'booked',
    });
    
    res.status(201).json(booking);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// UPDATE AN EXISTING BOOKING 
router.put('/:id', protect, async (req, res) => {
  try {
    const { date, timeSlot, purpose, status } = req.body;
    let booking = await Booking.findById(req.params.id);

    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }

    if (booking.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized to modify this booking record' });
    }

    booking = await Booking.findByIdAndUpdate(
      req.params.id,
      { date, timeSlot, purpose, status },
      { new: true, runValidators: true }
    );

    res.json(booking);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

//  CANCEL A BOOKING 
router.delete('/:id', protect, async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id);

    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }

    if (booking.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized to cancel this booking record' });
    }

    await booking.deleteOne();
    res.json({ message: 'Booking cancelled successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;