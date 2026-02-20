import { Hono } from 'hono'
import { swaggerUI } from '@hono/swagger-ui'

const app = new Hono()

// Serve Swagger UI tại root, trỏ vào file tĩnh
app.get('/', swaggerUI({ url: '/openapi.yaml' }))

export default app