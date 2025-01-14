from __future__ import annotations

from pathlib import Path
from typing import TYPE_CHECKING
import os

from pyk.kdist import kdist
from pyk.kore.parser import KoreParser
from pyk.utils import run_process_2

from .gst_to_kore import gst_to_kore

if TYPE_CHECKING:
    from subprocess import CompletedProcess
    from typing import Any

    from pyk.kore.syntax import Pattern


def interpret(gst_data: Any, schedule: str, mode: str, chainid: int, usegas: bool, *, check: bool = True, test_name=None) -> Pattern:
    proc_res = _interpret(gst_data, schedule, mode, chainid, usegas, test_name)

    if check:
        proc_res.check_returncode()

    kore = KoreParser(proc_res.stdout).pattern()
    return kore


SCRIPT_HEADER='SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )'
TEST_OUT_DIR=None

def _interpret(gst_data: Any, schedule: str, mode: str, chainid: int, usegas: bool, test_name=None) -> CompletedProcess:
    global TEST_OUT_DIR
    if TEST_OUT_DIR == None and test_name != None:
        if 'TEST_OUT_DIR' not in os.environ:
            raise ValueError("TEST_OUT_DIR should be set before executing the tests")
        TEST_OUT_DIR = Path(os.environ['TEST_OUT_DIR'])
        if TEST_OUT_DIR.exists():
            if not TEST_OUT_DIR.is_dir():
                raise ValueError("TEST_OUT_DIR env var does not point to a directory")
        else:
            TEST_OUT_DIR.mkdir(parents=True)
    interpreter = kdist.get('evm-semantics.llvm') / 'interpreter'
    init_kore = gst_to_kore(gst_data, schedule, mode, chainid, usegas)
    if test_name:
        # write test input
        test_path = TEST_OUT_DIR / test_name
        test_path.write_text(init_kore.text)
        # write test path
        test_path_cmd = (TEST_OUT_DIR / test_name).with_suffix('.sh')
        test_path_cmd.write_text('{}\n{} "$SCRIPT_DIR/{}" {} {}'.format(SCRIPT_HEADER, str(interpreter), str(test_path.name), '-1', '/dev/stdout'))
        # execute test
        proc_res = run_process_2([str(interpreter), str(test_path), '-1', '/dev/stdout'], check=False)
    else:
        # execute test
        proc_res = run_process_2([str(interpreter), '/dev/stdin', '-1', '/dev/stdout'], input=init_kore.text, check=False)
    return proc_res
