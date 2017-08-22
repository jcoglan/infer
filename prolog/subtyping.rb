require_relative '../lib/infer'

source  = File.read(File.expand_path('../subtyping.pl', __FILE__))
program = Infer::Prolog.program(source)

query, vars = Infer::Prolog.query <<-Q
  type([], app(λ(f, arrow(rcd([[x, nat]]), rcd([])), app(f, rec([[x, 0]]))), λ(r, rcd([]), rec([[y, true]]))), T).
Q

states = program.derive(query)
Infer::Prolog.print_results(states, vars)
