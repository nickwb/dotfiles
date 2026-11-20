import type { AgentInfo, Register } from 'claude-code'

// Replaces the engine's subagent row body with:
//   ● name · Opus·high 1M · <progress summary> · ▁▃▇▅ 15k 7%
// Segments are dropped or cut from the middle outwards when the row is narrow:
// first the summary is shortened, then the sparkline goes, then the summary.

const ESC = '\x1b['
const RESET = `${ESC}0m`
const col = (code: string, s: string) => `${ESC}${code}m${s}${RESET}`
const dim = (s: string) => col('2', s)
const SEP = ' · '
const BARS = '▁▂▃▄▅▆▇█'

/** Width in terminal cells, counting each code point as one cell. */
const width = (s: string) => [...s].length

const cut = (s: string, room: number) =>
  width(s) <= room ? s : [...s].slice(0, Math.max(0, room - 1)).join('') + '…'

/** 1234 -> "1.2k", 15000 -> "15k", 0 -> "". */
export const humanize = (n: number) =>
  !n ? '' : n >= 1000 ? `${Math.floor(n / 100) / 10}k` : String(n)

export const modelInfo = (id: string | undefined) => {
  const l = (id ?? '').toLowerCase()
  if (!l) return { n: '?', c: '90' }
  if (l.includes('opus')) return { n: 'Opus', c: '35' }
  if (l.includes('sonnet')) return { n: 'Sonnet', c: '36' }
  if (l.includes('haiku')) return { n: 'Haiku', c: '32' }
  if (l.includes('fable')) return { n: 'Fable', c: '34' }
  return { n: (id ?? '').replace(/^claude-/, '').replace(/-\d{6,8}$/, ''), c: '37' }
}

const statusColour = (s: AgentInfo['status']) => {
  switch (s) {
    case 'running':
    case 'pending':
    case 'waiting':
      return '33'
    case 'completed':
      return '32'
    case 'failed':
    case 'killed':
      return '31'
    default:
      return '90'
  }
}

/**
 * Tokens added between consecutive readings (about 5s apart), so the line shows
 * bursts of activity rather than a steadily rising total. Empty until there are
 * at least two readings with some activity between them.
 */
export const sparkline = (samples: number[]) => {
  const deltas = samples.slice(1).map((v, i) => Math.max(0, v - (samples[i] ?? v)))
  const max = Math.max(0, ...deltas)
  if (deltas.length < 2 || max === 0) return ''
  return deltas.map(d => BARS[Math.round((d / max) * (BARS.length - 1))]).join('')
}

export const body = (a: AgentInfo, columns: number) => {
  const mi = modelInfo(a.model)
  const eff = a.effort == null ? '' : `·${a.effort}`
  const big = (a.contextWindowSize ?? 0) >= 1_000_000 ? ' 1M' : ''
  const modelPlain = mi.n + eff + big
  const modelPretty = col(mi.c, mi.n) + (eff && dim(eff)) + (big && dim(big))

  const tok = humanize(a.tokenCount)
  const pct =
    tok && a.contextWindowSize
      ? ` ${Math.floor((a.tokenCount / a.contextWindowSize) * 100)}%`
      : ''
  const name = a.name ?? a.type ?? 'agent'
  const label = (a.label || a.description || '').replace(/\s+/g, ' ').trim()
  let spark = sparkline(a.tokenSamples ?? [])

  // Fixed parts: "● " + name + " · " + model, plus " · " + tokens when they fit.
  const head = 2 + width(name) + SEP.length + width(modelPlain)
  const tokens = head + SEP.length + width(tok + pct) <= columns ? tok + pct : ''
  const fixed = head + (tokens ? SEP.length + width(tokens) : 0)
  const MIN_LABEL = 12
  const sparkCost = (s: string) => (s ? width(s) + (tokens ? 1 : SEP.length) : 0)

  let room = columns - fixed - SEP.length
  if (room - sparkCost(spark) < MIN_LABEL) spark = ''
  room -= sparkCost(spark)
  const labelT = room < 8 ? '' : cut(label, room)

  const tail = spark
    ? dim(SEP) + col('36', spark) + (tokens ? ' ' + tokens : '')
    : tokens && dim(SEP) + tokens

  return (
    col(statusColour(a.status), '●') +
    ' ' +
    name +
    dim(SEP) +
    modelPretty +
    (labelT && dim(SEP) + labelT) +
    tail
  )
}

export const register: Register = on => {
  on('ui.render', { component: 'AgentRow' }, ($, e, next) => {
    const p = e.props
    return next({
      ...e,
      props: {
        ...p,
        // A finished subagent has nothing left to watch; failed or killed ones stay.
        isHidden: p.isHidden || p.taskStatus === 'completed',
        body: body(p, p.columns ?? 80),
      },
    })
  })
}
