import os

mips = input("name of mips file (for eg. a.s): ")
tc = []

files = ["small.txt", "mid.txt", "big.txt"]

for x in files:
    f = open(x)
    tc += f.readlines()
    f.close()


def run(arr):
    s = len(arr)
    inp = '\n'.join((str(x) for x in [s] + arr))

    output = os.popen(f"printf '{inp}' | spim -file {mips}").read().splitlines()
    return [int(x) for x in output if x.isdigit()][0]

for i in range(0, len(tc), 2):
    arr = [int(x) for x in tc[i].split(',')]
    out = int(tc[i+1])

    output = run(arr)

    if output != out:
        print(f"failed for arr {arr}, got {output} expected {out}")
        exit()
    os.system("clear")
    print(f"Testcase {i // 2 + 1}/{len(tc) // 2} passed")

print("All testcases passed")