import { expect, test } from 'claude-code/testing'

import type { AgentInfo } from 'claude-code'

import { body, humanize, sparkline } from './register'

const strip = (s: string) => s.replace(/\x1b\[[0-9;]*m/g, '')

const agent: AgentInfo = {
  id: 'a1',
  description: 'Find the handler',
  type: 'Explore',
  status: 'running',
  kind: 'local_agent',
  taskStatus: 'running',
  label: 'Reading src/auth/middleware.ts\nto find the token check',
  startTime: 0,
  cwd: '/',
  model: 'claude-sonnet-5-5',
  effort: 'high',
  contextWindowSize: 200_000,
  tokenCount: 15_000,
  tokenSamples: [1000, 3000, 3000, 9000, 15000],
  hasRow: true,
}

test('humanize and sparkline', () => {
  expect(humanize(0)).toBe('')
  expect(humanize(1234)).toBe('1.2k')
  expect(humanize(15000)).toBe('15k')
  expect(sparkline([1000, 3000, 3000, 9000, 15000])).toBe('▃▁██')
  expect(sparkline([5, 5, 5])).toBe('')
  expect(sparkline([5])).toBe('')
})

test('a wide row shows every segment on one line', () => {
  expect(strip(body(agent, 120))).toBe(
    '● Explore · Sonnet·high · Reading src/auth/middleware.ts to find the token check · ▃▁██ 15k 7%',
  )
})

test('a narrow row cuts the summary, then drops the sparkline', () => {
  expect(strip(body(agent, 60))).toBe(
    '● Explore · Sonnet·high · Reading src/auth/mi… · ▃▁██ 15k 7%',
  )
  const narrow = strip(body(agent, 44))
  expect(narrow).toBe('● Explore · Sonnet·high · Reading … · 15k 7%')
  for (const cols of [120, 60, 44, 30]) {
    expect([...strip(body(agent, cols))].length <= cols).toBe(true)
  }
})

test('the hook sets the body and hides a completed agent', async ($, on) => {
  const seen: { body?: string; isHidden: boolean }[] = []
  on('ui.render', { component: 'AgentRow' }, (_, e, next) => {
    seen.push({ body: e.props.body, isHidden: e.props.isHidden })
    return next(e)
  })

  for (const taskStatus of ['running', 'completed'] as const) {
    const ui = await $.ui.mount({
      plugin: 'agent-row',
      surface: 'terminal',
      component: 'AgentRow',
      requestId: 'a1',
      props: { ...agent, taskStatus, rowIds: ['a1'], columns: 120, isHidden: false },
    })
    await ui.unmount()
  }

  expect(seen.map(s => s.isHidden)).toEqual([false, true])
  expect(strip(seen[0]?.body ?? '')).toContain('Sonnet·high')
})
