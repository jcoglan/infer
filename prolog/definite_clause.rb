require_relative '../lib/infer'


def run(path, exprs)
  source  = File.read(File.expand_path(path, __FILE__))
  program = Infer::Prolog.program(source)

  exprs.each do |expr|
    Infer::Prolog.execute_and_print(program, expr, :limit => 50)
  end
end


run '../dcg.pl', [
  'np(X, []).',
  's([the, woman, shoots, a, man], []).',
  's([the, woman, shoots, a, man, but, a, man, shoots, the, man], []).',
  's(X, []).',
]


run '../an_bn_cn.pl', [
  's([], []).',
  's([a,b,c], []).',
  's([a,a,b,b,c,c], []).',
  's([a,a,a,b,b,b,c,c,c], []).',
  's([a,a,a,b,b,c,c,c], []).',
]


run '../grammar.pl', [
  's(T, [the, women, shoot, him], []).',
  's(T, [the, women, shoot, he], []).',
  's(T, [a, women, shoot, him], []).',
  's(T, [she, shoots, the, man], []).',
]
