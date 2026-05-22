const express = require('express');
const router = express.Router();
const Facility = require('../models/facility.model');
const { protect, adminOnly } = require('../middleware/auth.middleware');

router.get('/', protect, async (req, res) => {
  try {
    const facilities = await Facility.find();
    res.json(facilities);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

router.get('/:id', protect, async (req, res) => {
  try {
    const facility = await Facility.findById(req.params.id);
    if (!facility) {
      return res.status(404).json({ message: 'Facility not found' });
    }
    res.json(facility);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

router.post('/', protect, adminOnly, async (req, res) => {
  try {
    const { name, capacity, description, type } = req.body;
    const facility = await Facility.create({
      name,
      capacity,
      description,
      type,
    });
    res.status(201).json(facility);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

router.put('/:id', protect, adminOnly, async (req, res) => {
  try {
    const { name, capacity, description, type } = req.body;
    const facility = await Facility.findByIdAndUpdate(
      req.params.id,
      { name, capacity, description, type },
      { new: true, runValidators: true }
    );
    if (!facility) {
      return res.status(404).json({ message: 'Facility not found' });
    }
    res.json(facility);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

router.delete('/:id', protect, adminOnly, async (req, res) => {
  try {
    const facility = await Facility.findByIdAndDelete(req.params.id);
    if (!facility) {
      return res.status(404).json({ message: 'Facility not found' });
    }
    res.json({ message: 'Facility deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

router.get('/:id/availability', protect, async (req, res) => {
  try {
    const { date } = req.query;
    const Booking = require('../models/booking.model');

    // Get all bookings for this facility on this date
    const bookings = await Booking.find({
      facilityId: req.params.id,
      date: date,
    });

    const allSlots = [
      '8:00 AM - 9:00 AM',
      '9:00 AM - 10:00 AM',
      '10:00 AM - 11:00 AM',
      '11:00 AM - 12:00 PM',
      '1:00 PM - 2:00 PM',
      '2:00 PM - 3:00 PM',
      '3:00 PM - 4:00 PM',
      '4:00 PM - 5:00 PM',
    ];

    const slots = allSlots.map((slot) => ({
      time: slot,
      available: !bookings.some((b) => b.timeSlot === slot),
    }));

    res.json(slots);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;