// server.js

// 1. Setup

const express = require('express');
const cors = require('cors');
const nodemailer = require('nodemailer');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors()); // Allow your Vue frontend to communicate with this server
app.use(express.json()); // Parse incoming JSON requests

// 2. Configure Nodemailer Transporter
// This is your secure connection setup to the Gmail SMTP server.
const transporter = nodemailer.createTransport({
    // Use the Gmail service
    service: 'gmail', 
    auth: {
        // Use environment variables for security!
        user: process.env.GMAIL_USER, 
        pass: process.env.GMAIL_APP_PASSWORD, 
    },
});

// 3. Define the POST Route (The API Endpoint)
app.post('/api/send-email', async (req, res) => {
    // Destructure data sent from the Vue frontend
    const { to, subject, text, html } = req.body;

    if (!subject || !text) {
        return res.status(400).json({ status: 'error', message: 'Subject and message body are required.' });
    }

    // Configure the email message
    const mailOptions = {
        // The sender is the email configured in the transporter (your Gmail account)
        from: process.env.GMAIL_USER, 
        // The recipient is the email sent from the Vue form
        to: to || process.env.GMAIL_USER, // Optional: default to self if 'to' is not provided
        subject: subject,
        text: text,
        html: html || `<p>${text}</p>`, // Use text as a fallback HTML body
    };

    try {
        // Send the email
        const info = await transporter.sendMail(mailOptions);
        console.log('Message sent: %s', info.messageId);
        
        // Respond to the Vue frontend
        res.status(200).json({ 
            status: 'success', 
            message: 'Email sent successfully!', 
            messageId: info.messageId 
        });
    } catch (error) {
        console.error('Nodemailer error:', error);
        res.status(500).json({ 
            status: 'error', 
            message: 'Failed to send email on the server.' 
        });
    }
});

// 4. Start the Server
app.listen(PORT, () => {
    console.log(`Email server running on port ${PORT}`);
});