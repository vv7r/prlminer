# prlminer

A GPU miner for **Pearl (PRL)** on NVIDIA cards, for Windows, Linux and HiveOS.

It works with any Pearl stratum pool (Kryptex, HeroMiners, 2Miners, AlphaPool, Luckypool, …) and includes a fixed **0.5% developer fee** — see [Dev fee](#dev-fee).

## Requirements

- An NVIDIA GPU: Ampere, Ada or Blackwell (RTX 30/40/50 series; comparable CMP and data-center cards also work).
- A Pearl payout address, starting with `prl1p…`.
- The NVIDIA **driver**. No CUDA toolkit is needed to run the miner.

## Download

Get the latest build from the **[releases page](https://github.com/vv7r/prlminer/releases/latest)**:

| Platform | File | Contents |
|---|---|---|
| Windows | `prlminer-0.1.0-windows.zip` | `prlminer.exe` + `start.bat` |
| Linux | `prlminer-0.1.0-linux.tar.gz` | `prlminer` + `start.sh` |
| HiveOS | `prlminer-0.1.0-hiveos.tar.gz` | `prlminer` + `h-config.sh` + `h-run.sh` |

## Windows

1. Unzip `prlminer-0.1.0-windows.zip` into a folder.
2. Open `start.bat` in Notepad and fill in your details:
   ```
   set WALLET=YOUR_WALLET
   set WORKER=worker
   set POOL=YOUR_POOL
   ```
   - `WALLET` — your Pearl payout address (`prl1p…`). On Kryptex, your `krx…` login works too.
   - `POOL` — the full pool URL **with its scheme**, e.g. `stratum+ssl://prl-eu.kryptex.network:8048`.
3. Save, then double-click `start.bat`.

`start.bat` restarts the miner if it crashes; `Ctrl-C` stops it for good.

Or run the miner directly:
```
prlminer.exe -o stratum+ssl://prl-eu.kryptex.network:8048 -u YOUR_WALLET -w worker
```

## Linux

1. Extract the archive:
   ```
   tar -xzf prlminer-0.1.0-linux.tar.gz
   cd prlminer-0.1.0
   ```
2. Edit `start.sh` and fill in `WALLET`, `WORKER` and `POOL` (same as above).
3. Run it with `bash` (the executable bit is not guaranteed to survive every download):
   ```
   bash start.sh
   ```

Or run the miner directly:
```
./prlminer -o stratum+ssl://prl-eu.kryptex.network:8048 -u YOUR_WALLET -w worker
```

`start.sh` restarts the miner if it crashes; `Ctrl-C` stops it for good.

## HiveOS

1. In HiveOS, open **Miners → Custom** and install from this URL:
   ```
   https://github.com/vv7r/prlminer/releases/latest/download/prlminer-0.1.0-hiveos.tar.gz
   ```
2. Create a **flight sheet**:

   | Field | Value |
   |---|---|
   | Coin | `PRL` |
   | Pool URL | your pool, e.g. `stratum+ssl://prl-eu.kryptex.network:8048` |
   | Wallet and worker template | your wallet (`prl1p…`), or `wallet.worker` |
   | Password | pool password, e.g. `x` |

3. Apply it. The rig name comes from HiveOS automatically.

`h-run.sh` starts the miner with `--no-tui` (there is no terminal on a rig) and merges `stderr` into `stdout` so HiveOS captures everything. If the wallet template already carries a worker (`wallet.worker`), the rig name is not appended again.

## Options

| Option | Default | Description |
|---|---|---|
| `-o, --url` | `stratum+ssl://prl-eu.kryptex.network:8048` | Pool URL (`stratum+tcp://…` is also supported) |
| `-u, --wallet` | — | Payout address (`prl1…`); prefix `solo:` for Kryptex solo mode |
| `-w, --worker` | `rig` | Worker name shown on the pool |
| `-p, --pass` | `x` | Pool password; `d=4194304` for a fixed difficulty |
| `-d, --devices` | all | GPUs to use, e.g. `0,1` |
| `--stats` | 30 | Seconds between hashrate reports (plain-log mode) |
| `--check [MIN]` | off | GPU stability check every MIN minutes (10 if omitted) |
| `--no-tui` | — | Plain scrolling log instead of the full-screen dashboard |
| `--log-file` | — | Also append the log to a file |

## Dashboard and keys

By default the miner shows a full-screen dashboard (hashrate, pool, shares, GPU status). Press `l` to hand the terminal back — the log is printed and normal scrolling returns — then `l` followed by Enter to switch back. `Ctrl-C` quits cleanly.

## Merge mining (NACRE)

On a pool that supports it (e.g. AlphaPool), every Pearl share you submit also merge-mines **NACRE (NACR)** — same hashrate, no extra power. Just add your NACR address to your Pearl address:

```
prlminer.exe -o stratum+tcp://us1.alphapool.tech:5571 -u "prl1pYOUR_PRL+nacr1pYOUR_NACR.worker" -p "x;d=524288"
```

- Put the worker **either** after the dot in `-u` **or** in `-w` — not both.
- Port `5571` at AlphaPool; `-p "x;d=N"` pins a static difficulty (`x` alone lets the pool adjust it).
- Without a NACR address you still mine Pearl normally, you are simply not credited in NACR.

## Dev fee

The miner includes a fixed **0.5% developer fee**. It cannot be changed — there is no command-line option or environment variable — and nothing is written to disk.

The fee is taken from the work your pool accepts, not from wall-clock time. While a fee slice runs, the miner mines for the developer pool, and every such line is tagged `dev fee` in the log, so you can always see when it happens.

## Windows Defender

Defender may flag `prlminer.exe` as `Trojan:Win32/Bearfoos.B!ml`. This is a false positive: the `!ml` suffix marks a machine-learning heuristic, and Defender files unsigned GPU miners this way (SRBMiner, rgminer, … get the same). Add an exclusion for the miner's folder, or report the file to Microsoft.

## Third-party notices

The miner embeds source code from the Pearl project (`zk-pow`, `pearl-blake3`, `plonky2`). Their licences are reproduced in [THIRD-PARTY-LICENSES.txt](THIRD-PARTY-LICENSES.txt).
