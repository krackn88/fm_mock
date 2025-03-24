const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.json());

// Load mock client data
const clientsPath = path.join(__dirname, 'clients.json');
let clients = JSON.parse(fs.readFileSync(clientsPath, 'utf-8'));

// Fetch client information
app.get('/client/:id', (req, res) => {
    const clientId = parseInt(req.params.id, 10);
    const client = clients.find(c => c.id === clientId);
    if (client) {
        res.json(client);
    } else {
        res.status(404).json({ error: 'Client not found' });
    }
});

// Update or insert client information
app.post('/client', (req, res) => {
    const client = req.body;
    const existingClientIndex = clients.findIndex(c => c.id === client.id);
    if (existingClientIndex !== -1) {
        clients[existingClientIndex] = client;
    } else {
        clients.push(client);
    }
    fs.writeFileSync(clientsPath, JSON.stringify(clients, null, 2));
    res.json({ success: true, id: client.id });
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});