#import "../specification/settings.typ": *

#h1[Type System]

$
  Delta in lr(bb(X) ⇀_"fin" bb(T))
$

$
  frac(
    tau = op("SchemaT")(F)
    quad
    Delta[x ↦ tau] ⊢ e : tau',
    Delta ⊢ op("SchemaDecl")(x, tau, e) : tau',
  )
  quad ("T-Schema")
$

$
  frac(
    tau = op("PacketT")(tau_s, R)
    quad
    Delta[x ↦ tau] ⊢ e : tau',
    Delta ⊢ op("PacketDecl")(x, tau, e) : tau',
  )
  quad ("T-Packet")
$
