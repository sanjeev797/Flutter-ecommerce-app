const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: String,
  description: String,
  price: Number,
  imageUrl: String,  // Add the image URL field here
});

module.exports = mongoose.model('Product', productSchema);
