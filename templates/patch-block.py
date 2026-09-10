import io, os, re
p = os.environ["PMOS_TARGET"]
blk = os.environ["PMOS_BLOCK"].strip()
s = io.open(p, encoding="utf-8").read()
new = re.sub(r"<!-- pm-os:start -->.*?<!-- pm-os:end -->", lambda m: blk, s, flags=re.S)
io.open(p, "w", encoding="utf-8").write(new)

