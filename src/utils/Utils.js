// Tailwind CSS 颜色转换工具
export const tailwindConfig = () => {
  return {
    theme: {
      colors: {
        indigo: {
          500: '#6366f1',
          600: '#4f46e5',
        },
        blue: {
          500: '#3b82f6',
        },
        slate: {
          500: '#64748b',
        },
        green: {
          500: '#10b981',
        },
        yellow: {
          500: '#f59e0b',
        },
        red: {
          500: '#ef4444',
        },
        purple: {
          500: '#8b5cf6',
        },
        pink: {
          500: '#ec4899',
        },
      },
    },
  }
}

// 十六进制颜色转RGB
export const hexToRGB = (h) => {
  let r = 0
  let g = 0
  let b = 0
  if (h.length === 4) {
    r = parseInt(h[1] + h[1], 16)
    g = parseInt(h[2] + h[2], 16)
    b = parseInt(h[3] + h[3], 16)
  } else if (h.length === 7) {
    r = parseInt(h[1] + h[2], 16)
    g = parseInt(h[3] + h[4], 16)
    b = parseInt(h[5] + h[6], 16)
  }
  return `${r}, ${g}, ${b}`
}

// 格式化数字
export const formatValue = (value) => {
  if (value >= 1000000) {
    return (value / 1000000).toFixed(1) + 'M'
  } else if (value >= 1000) {
    return (value / 1000).toFixed(1) + 'K'
  }
  return value.toString()
}

// 生成随机数据
export const generateRandomData = (length, min = 0, max = 1000) => {
  return Array.from({ length }, () => Math.floor(Math.random() * (max - min + 1)) + min)
}

// 生成日期标签
export const generateDateLabels = (months = 12) => {
  const labels = []
  const now = new Date()
  for (let i = months - 1; i >= 0; i--) {
    const date = new Date(now.getFullYear(), now.getMonth() - i, 1)
    labels.push(date.toLocaleDateString('zh-CN', { year: 'numeric', month: '2-digit' }))
  }
  return labels
}