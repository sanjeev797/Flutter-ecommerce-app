const express = require('express');
const router = express.Router();
const Product = require('../models/Product');

// GET all products
router.get('/', async (req, res) => {
  try {
    const products = await Product.find();
    res.json(products);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// GET single product
router.get('/:id', async (req, res) => {
  console.log('requested');
  try {
    const product = await Product.findById(req.params.id);
    console.log(product);
    res.json(product);
  } catch (err) {
    res.status(404).json({ message: 'Product not found' });
  }
});

// POST a product
router.post('/', async (req, res) => {
  // Expecting the image URL in the request body
  const { name, description, price, imageUrl } = req.body;

  // Create a new product with the data from the request
  const product = new Product({
    name,
    description,
    price,
    imageUrl, // Save the image URL along with other product details
  });

  console.log(product);

  try {
    await product.save();
    res.status(201).json(product);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// PUT update product
router.put('/:id', async (req, res) => {
  // Expecting updated product details, including imageUrl
  const { name, description, price, imageUrl } = req.body;

  try {
    const updated = await Product.findByIdAndUpdate(
      req.params.id,
      { name, description, price, imageUrl },
      { new: true } // This returns the updated document
    );
    res.json(updated);
  } catch (err) {
    res.status(400).json({ message: 'Failed to update product' });
  }
});

// DELETE product
router.delete('/:id', async (req, res) => {
  try {
    await Product.findByIdAndDelete(req.params.id);
    res.json({ message: 'Product deleted' });
  } catch (err) {
    res.status(500).json({ message: 'Failed to delete product' });
  }
});

module.exports = router;
