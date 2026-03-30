require('dotenv').config();

console.log("KEY:", process.env.STRIPE_SECRET_KEY);

const express = require("express");
const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);
const cors = require("cors");

const app = express();
const stripeInstance = require("stripe")(process.env.STRIPE_SECRET_KEY);

// Middleware
app.use(cors()); // Allow requests from Flutter app (even during local testing)
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

/**
 * Route: POST /create-payment-intent
 * Purpose: Creates a payment intent with the given amount and currency.
 * The client_secret returned here will be used in the Flutter app to finalize the payment.
 */
app.post("/create-payment-intent", async (req, res) => {
  const { amount, currency } = req.body;

  // 1. Validation: Ensure amount is a positive number and currency exists
  if (!amount || amount <= 0) {
    return res.status(400).json({ error: "Amount must be a positive integer (in cents)." });
  }
  if (!currency) {
    return res.status(400).json({ error: "Currency is required (e.g., 'usd')." });
  }

  try {
    // 2. Create Payment Intent via Stripe SDK
    // The 'amount' must be in the smallest currency unit (e.g., cents for USD)
    const paymentIntent = await stripeInstance.paymentIntents.create({
      amount: amount,
      currency: currency,
      // Optional: Add metadata for your own records
      metadata: {
        integration_check: "accept_a_payment",
      },
      payment_method_types: ["card"], // Only cards for now
    });
    console.log("PaymentIntent:", paymentIntent);
    // 3. Return the client_secret to the Flutter mobile app
    res.status(200).json({
      client_secret: paymentIntent.client_secret,
    });
  } catch (error) {

    console.error("Stripe Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

// Start Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log('----------------------------------------------------');
  console.log(`✅ Backend Server is RUNNING`);
  console.log(`🏠 Local:   http://localhost:${PORT}`);
  console.log(`📱 Network: http://192.168.1.6:${PORT}`);
  console.log(`🚀 For Android Emulator, use: http://10.0.2.2:${PORT}`);
  console.log('----------------------------------------------------');
  console.log(`Ensure your phone is on the same Wi-Fi: 192.168.1.x`);
});
