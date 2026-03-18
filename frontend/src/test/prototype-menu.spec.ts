import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'

import { JSDOM, VirtualConsole } from 'jsdom'
import { describe, expect, it } from 'vitest'

const prototypePath = resolve(process.cwd(), '../ai-platform-prototype.html')
const prototypeHtml = readFileSync(prototypePath, 'utf8')

async function loadPrototypePage() {
  const errors: Error[] = []
  const virtualConsole = new VirtualConsole()

  virtualConsole.on('jsdomError', error => {
    errors.push(error)
  })

  const dom = new JSDOM(prototypeHtml, {
    runScripts: 'dangerously',
    url: `file:///${prototypePath.replace(/\\/g, '/')}`,
    virtualConsole,
  })

  await new Promise(resolveTimer => {
    dom.window.setTimeout(resolveTimer, 0)
  })

  return { dom, errors }
}

describe('prototype menu navigation', () => {
  it('loads menu scripts and switches to projects page', async () => {
    const { dom, errors } = await loadPrototypePage()

    expect(errors).toHaveLength(0)
    expect(typeof dom.window.showPage).toBe('function')

    dom.window.showPage('projects')

    expect(dom.window.document.getElementById('page-projects')?.classList.contains('active')).toBe(true)
    expect(dom.window.document.getElementById('topbar-title')?.textContent).toBe('项目空间')
  })
})
