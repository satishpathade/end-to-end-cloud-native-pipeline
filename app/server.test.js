const request = require('supertest');
const app = require('./server');

describe('Application Tests', () => {
  test('GET /health should return 200', async () => {
    const response = await request(app).get('/health');
    expect(response.statusCode).toBe(200);
    expect(response.body.status).toBe('healthy');
  });

  test('GET / should return HTML', async () => {
    const response = await request(app).get('/');
    expect(response.statusCode).toBe(200);
    expect(response.text).toContain('CI/CD Pipeline Success');
  });

  test('GET /api/info should return JSON', async () => {
    const response = await request(app).get('/api/info');
    expect(response.statusCode).toBe(200);
    expect(response.body.app).toBe('End to End DevOps pipeline');
  });
});