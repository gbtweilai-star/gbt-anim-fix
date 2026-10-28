# anim_fix

**One capability bit from GBT V8, packaged standalone.** No. 10 of 341,
`creation` domain (Creation).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 动画手术（GLB 层面 · **六条自检，不过就不写盘**）：把点名骨头的 rotation 轨道归位到静止姿势（髋骨 LeftUpLeg/RightUpLeg）或写成**量出来的**姿势（手臂组的值来自闭环解算，不许手搓）；平移/缩放通道一律不碰；自检=命中通道/采样形状/四元数模长/写回逐帧复查/**只改这些字节（其余逐一相等）**/网格蒙皮没被动。op=status/plan（纯读）· run（写 dst ⇒ 要票；dry=true 只自检不落盘 ⇒ 免票）

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-anim-fix.git
cd gbt-anim-fix
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_anim_fix info                  # capability card
python -m gbt_anim_fix spec --json           # machine-readable contract
python -m gbt_anim_fix check --payload '{}'
python -m gbt_anim_fix run   --payload '{}'
```

Real `info` output from this machine:

```text
anim_fix  (creation)  v1.0.0
----------------------------------------
动画手术（GLB 层面 · **六条自检，不过就不写盘**）：把点名骨头的 rotation 轨道归位到静止姿势（髋骨 LeftUpLeg/RightUpLeg）或写成**量出来的**姿势（手臂组的值来自闭环解算，不许手搓）；平移/缩放通道一律不碰；自检=命中通道/采样形状/四元数模长/写回逐帧复查/**只改这些字节（其余逐一相等）**/网格蒙皮没被动。op=status/plan（纯读）· run（写 dst ⇒ 要票；dry=true 只自检不落盘 ⇒ 免票）

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : (none)
values     : (multi-op, but the registry does not enumerate them)
```

Wire a real implementation:

```python
from gbt_anim_fix import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表标注 `multi_op: true`，但没有枚举具体取值。**本包不替它编造取值清单——这种缺口应当在注册表源头补，而不是在文档里圆。

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.16s
```

## Provenance

| field | value |
|---|---|
| capability | `anim_fix` |
| domain | `creation` |
| handler | `dh_rig` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [creation/anim_fix](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/creation/anim_fix.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
