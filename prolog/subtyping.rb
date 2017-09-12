require_relative '../lib/infer'

source  = File.read(File.expand_path('../subtyping.pl', __FILE__))
program = Infer::Prolog.program(source)

exprs = <<-Q
  type([], λ(x, bool, λ(y, bool, λ(x, nat, x))), T).
  type([], app(λ(f, arrow(rcd([[x, nat]]), rcd([])), app(f, rec([[x, 0]]))), λ(r, rcd([]), rec([[y, true]]))), T).
  type([], if(true, λ(r, rcd([[x,nat], [y,nat]]), proj(r,x)), λ(s, rcd([[y,top], [z,nat]]), proj(s,z))), T).
  join(rcd([[x,bool], [y,bool]]), rcd([[y,nat], [z,nat]]), J).
Q

exprs.lines.each do |expr|
  next if expr =~ /\A\s*\z/
  Infer::Prolog.execute_and_print(program, expr)
end
