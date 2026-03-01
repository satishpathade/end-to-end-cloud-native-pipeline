const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: process.env.APP_VERSION || '1.0.0'
  });
});

// Main endpoint
app.get('/', (req, res) => {
  res.send(`
    <html>
      <head>
        <title>End to End DevOps pipeline</title>
        <style>
          body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
          }
          .container {
            text-align: center;
            padding: 50px;
            background: rgba(255,255,255,0.1);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
          }
          h1 { font-size: 3em; margin-bottom: 20px; }
          p { font-size: 1.2em; }
          .badge {
            background: rgba(255,255,255,0.2);
            padding: 10px 20px;
            border-radius: 25px;
            margin: 10px;
            display: inline-block;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>CI/CD Pipeline Success!</h1>
          <p>Your application is running on Kubernetes</p>
          <div class="badge">Version: ${process.env.APP_VERSION || '1.0.0'}</div>
          <div class="badge">Pod: ${process.env.HOSTNAME || 'local'}</div>
          <div class="badge">Environment: ${process.env.NODE_ENV || 'development'}</div>
        </div>
      </body>
    </html>
  `);
});

// API endpoint
app.get('/api/info', (req, res) => {
  res.json({
    app: 'End to End DevOps pipeline',
    version: process.env.APP_VERSION || '1.0.0',
    pod: process.env.HOSTNAME || 'local',
    environment: process.env.NODE_ENV || 'development',
    timestamp: new Date().toISOString()
  });
}); 

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`Version: ${process.env.APP_VERSION || '1.0.0'}`);
});

module.exports = app;