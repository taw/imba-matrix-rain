let def random_int(min, max)
  min + Math.floor( Math.random() * (max - min + 1) )

let def random_katakana
  String.fromCharCode(random_int(0x30A0, 0x30FF))

let def random_symbols
  for i in [0..random_int(5, 30)]
    { v: random_katakana() }

tag Stream
  def render
    <self css:top=data:y css:left=data:x>
      for symbol, index in data:symbols
        <div.symbol .first=(index==0)>
          symbol:v

tag App
  def setup
    @streams = []
    let x = 10
    while x + 30 < window:inner-width
      @streams.push({
        x: x,
        y: Math.random() * window:inner-height,
        speed: 10 + Math.random() * 20,
        symbols: random_symbols()
      })
      x += 30

  def mount
    setInterval(&,10) do
      for stream in @streams
        stream:y += stream:speed
        if stream:y > window:inner-height + stream:symbols:length * 20
          stream:symbols = random_symbols()
          stream:speed = 10 + Math.random() * 20
          stream:y = - stream:symbols:length * 20
        for symbol in stream:symbols
          if Math.random() < 0.01
            symbol:v = random_katakana()
      Imba.commit

  def render
    <self>
      for stream in @streams
        <Stream[stream]>

Imba.mount <App>
