from __future__ import annotations

from typing import TYPE_CHECKING

from pyk.kdist import kdist
from pyk.kore.parser import KoreParser
from pyk.utils import run_process_2

from .gst_to_kore import gst_to_kore

if TYPE_CHECKING:
    from subprocess import CompletedProcess
    from typing import Any

    from pyk.kore.syntax import Pattern


def interpret(gst_data: Any, schedule: str, mode: str, chainid: int, usegas: bool, file: str, *, check: bool = True) -> Pattern:
    proc_res = _interpret(gst_data, schedule, mode, chainid, usegas, file)

    if check:
        proc_res.check_returncode()

    kore = KoreParser(proc_res.stdout).pattern()
    return kore


def _interpret(gst_data: Any, schedule: str, mode: str, chainid: int, usegas: bool, file: str) -> CompletedProcess:
    interpreter = kdist.get('evm-semantics.llvm') / 'search'
    init_kore = gst_to_kore(gst_data, schedule, mode, chainid, usegas)
    with open(file, "w") as f:
        f.write(init_kore.text)
    proc_res = run_process_2([str(interpreter), file, '-1', '/dev/stdout', '--execute-to-branch'], check=False)
    return proc_res
