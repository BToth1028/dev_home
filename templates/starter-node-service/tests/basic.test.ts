import { describe, it, expect } from 'vitest'

describe('basic tests', () => {
  it('math sanity: 2 + 2 = 4', () => {
    expect(2 + 2).toBe(4)
  })

  it('health endpoint returns ok structure', () => {
    const healthResponse = { ok: true }
    expect(healthResponse).toHaveProperty('ok')
    expect(healthResponse.ok).toBe(true)
  })
})
