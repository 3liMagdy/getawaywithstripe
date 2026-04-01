require('dotenv').config();

const express = require("express");
const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

app.post("/create-customer", async (req, res) => {
  try {
    const customer = await stripe.customers.create();

    res.json({
      customerId: customer.id,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post("/ephemeral-key", async (req, res) => {
  try {
    const { customerId } = req.body;

    const ephemeralKey = await stripe.ephemeralKeys.create(
      { customer: customerId },
      { apiVersion: "2023-10-16" }
    );

    res.json(ephemeralKey);
  } catch (error) {
    console.error("Ephemeral Key Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

app.post("/create-payment-intent", async (req, res) => {
  try {

    const amount = 1000; // ثابت (مثال)
    const currency = "usd";
    const { customerId } = req.body;

    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
      customer: customerId,
      payment_method_types: ["card"],
       setup_future_usage: "off_session", 
    });

    res.status(200).json({
      client_secret: paymentIntent.client_secret,
    });
  } catch (error) {
    console.error("Stripe Error:", error.message);
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});