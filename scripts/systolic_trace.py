"""Cycle-by-cycle reference for the 1D systolic array in Ch04_Systolic1D.lean.

Mirrors the Lean model exactly:
  feed(t, i)        = X[t - i][i] if i <= t else 0      (input skewing)
  xreg_{t+1}[i]     = feed(t, i)                         (input register)
  psum_{t+1}[i]     = (0 if i == 0 else psum_t[i-1]) + w[i] * xreg_t[i]

Cycle 0 is the reset state. Row r leaves the last PE at cycle r + N + 1.
"""

W = [2, 3, 5]
X = [[1, 2, 3], [4, 0, 1]]
N = len(W)
CYCLES = 8


def x_at(r, i):
    return X[r][i] if r < len(X) and i < len(X[r]) else 0


def feed(t, i):
    return x_at(t - i, i) if i <= t else 0


def main():
    xreg = [0] * N
    psum = [0] * N
    print("cycle | " + " | ".join(f"PE{i} xreg psum" for i in range(N)))
    for t in range(CYCLES):
        print(f"{t:5} | " + " | ".join(f"{xreg[i]:9} {psum[i]:4}" for i in range(N)))
        new_psum = [(0 if i == 0 else psum[i - 1]) + W[i] * xreg[i] for i in range(N)]
        xreg = [feed(t, i) for i in range(N)]
        psum = new_psum
    for r in range(len(X)):
        print(f"row {r}: dot = {sum(W[i] * x_at(r, i) for i in range(N))}, "
              f"expected at PE{N-1} on cycle {r + N + 1}")


if __name__ == "__main__":
    main()
