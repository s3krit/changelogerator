# This is a test

Our changelog has 218 commits.



## Native runtimes

⚠️ Need a hash of runtime/version

## Rust version

This release was tested against the following versions of `rustc`. Other versions may work.

- Rust Stable: 1.53.0
- Rust Nightly: 1.57.0


## Changes

- C1-low 📌:  companion for substrate#9788
- C1-low 📌:  Don't try to connect to ourselves.
- C1-low 📌:  Dispute distribution improvements
- C1-low 📌:  approval-voting: processed wakeups can also update approval state
- C1-low 📌:  improve approval tracing
- C1-low 📌:  Fix spelling
- C1-low 📌:  Raised nits on #3813
- C1-low 📌:  Add build with docker info to README
- C1-low 📌:  add dispute metrics, some chores
- C1-low 📌:  Bump tracing from 0.1.26 to 0.1.27
- C1-low 📌:  Companion for #9764 (Force Unreserve)
- C1-low 📌:  Fix Complaints in CI
- C1-low 📌:  Better error messages.
- C1-low 📌:  Substrate Companion for #9552
- C1-low 📌:  Bump parity-scale-codec from 2.2.0 to 2.3.0
- C1-low 📌:  Companion for Generate storage info for pallet babe #9760
- C1-low 📌:  Substrate Companion #9737
- C1-low 📌:  dockerfiles: upgrade to ubuntu:20.04; some chore
- C1-low 📌:  Add logging for worker spawn failures
- C1-low 📌:  Add Canvas to trusted chains in Rococo
- C1-low 📌:  Bump tokio from 1.10.1 to 1.11.0
- C1-low 📌:  make polkadot-runtime optional feature
- C1-low 📌:  Add words to the dictionnary
- C1-low 📌:  XCM Benchmarks for Asset Transactor w/ Fungible Asset
- C1-low 📌:  Add vault secrets to publish-rustdoc job
- C1-low 📌:  add parachains pallets to Polkadot runtime
- C1-low 📌:  Put all authorities of a session into `SessionInfo`.
- C1-low 📌:  Fix flaky availability-recovery test
- C1-low 📌:  Bump slotmap from 1.0.5 to 1.0.6
- C1-low 📌:  Ensure that `para_head` hash matches the actual head
- C1-low 📌:  Substrate Companion for rust 1.54
- C1-low 📌:  Fix buildah issue 3500
- C1-low 📌:  Introduce XCM Weight Traits
- C1-low 📌:  Companion for substrate#9711
- C1-low 📌:  participate in disputes only if haven't voted already
- C1-low 📌:  Make parts of the xcm-executor public
- C1-low 📌:  Bump syn from 1.0.75 to 1.0.76
- C1-low 📌:  bump substrate and beefy
- C1-low 📌:  set `DisputesHandler` in initializer on Rococo
- C1-low 📌:  Convert rococo chainspec to raw chainspec
- C7-high ❗️:  Don't drop UMP queue items if weight exhausted
- C1-low 📌:  allow config NextFreeParaId in genesis
- C1-low 📌:  comment out bridges runtime modules (broken) and update Rococo chain-spec
- C1-low 📌:  feat/overseer: introduce closure init
- C1-low 📌:  Bump structopt from 0.3.22 to 0.3.23
- C1-low 📌:  Bump serde_json from 1.0.66 to 1.0.67
- C1-low 📌:  Enable disputes on rococo
- C1-low 📌:  chore: test helper arbitrary ordering for 2
- C1-low 📌:  dependabot: ignore yet another git dep
- C1-low 📌:  Companion for #9648
- C1-low 📌:  Fixes/improvements for disputes
- C1-low 📌:  Allow staking miner to use different election algorithms
- C1-low 📌:  disputes: fix relay chain selection sanity check
- C1-low 📌:  Companion for Generate storage info for pallet im_online #9654
- C1-low 📌:  Bump futures from 0.3.16 to 0.3.17
- C1-low 📌:  Bump serde from 1.0.127 to 1.0.130
- C1-low 📌:  XCM: Automatic Version Negotiation
- C1-low 📌:  Add VoteLocking config
- C1-low 📌:  node/service: Update finality target to fix disputes tests
- C1-low 📌:  Remove migration done by runtime version 9090
- C1-low 📌:  Return a Result in invert_location
- C1-low 📌:  XCM: Allow reclaim of assets dropped from holding
- C1-low 📌:  Bump libc from 0.2.100 to 0.2.101
- C1-low 📌:  Fix Try-Runtime 
- C1-low 📌:  allow some overhead in MERKLE_NODE_MAX_SIZE
- C1-low 📌:  Change pipeline to use Vault
- C1-low 📌:  Bump async-trait from 0.1.50 to 0.1.51
- C1-low 📌:  Bump itertools from 0.10.0 to 0.10.1
- C1-low 📌:  Bump tokio from 1.10.0 to 1.10.1
- C1-low 📌:  Add tests and modify as_vec implementation
- C1-low 📌:  Bump trybuild from 1.0.43 to 1.0.45
- C1-low 📌:  Companion for 9619 (Private Events)
- C1-low 📌:  Further improved availability recovery
- C1-low 📌:  Bump syn from 1.0.74 to 1.0.75
- C1-low 📌:  Don't err on deactivated leaf during valiation.
- C1-low 📌:  Update Slot Range Expect Proof
- C1-low 📌:  Substrate Companion for #9566
- C1-low 📌:  Bump libc from 0.2.99 to 0.2.100
- C1-low 📌:  Substrate Companion #9575
- C1-low 📌:  XCM: Introduce versioning to dispatchables' params
- C1-low 📌:  Improve MultiLocation conversion functions in xcm-procedural
- C1-low 📌:  remove dead_code from chain selection test
- C1-low 📌:  properly gate sanity check
- C1-low 📌:  New Proxy for Auctions + Crowdloans + Registrar + Slots
- C1-low 📌:  staking-miner: docker images
- C1-low 📌:  Fill up request slots via `launch_parallel_requests`
- C1-low 📌:  staking-miner: remove need of a file to pass the seed
- C3-medium 📣:  Bypass chain-selection subsystem until disputes are enabled.
- C1-low 📌:  demote warnings due to disconnected dispute coordinator
- C1-low 📌:  Bump serde_json from 1.0.64 to 1.0.66
- C1-low 📌:  Replace `()` filter with `Nothing`
- C1-low 📌:  Companion for https://github.com/paritytech/substrate/pull/9569
- C3-medium 📣:  Provide dummy dispute coordinator by default.
- C3-medium 📣:  Removed unneeded deps
- C1-low 📌:  Fix xcm tests
- C1-low 📌:  Remove check_web_wasm job
- C1-low 📌:  Companion PR for 'Remove substrate-in-the-browser #9541'
- C1-low 📌:  Better logs
- C1-low 📌:  Bump pin-project from 1.0.7 to 1.0.8
- C1-low 📌:  Simnet v8 move tests
- C1-low 📌:  Companion PR for 'Simplify `NativeExecutionDispatch` and remove the `native_executor_instance!`' (9562)
- C1-low 📌:  Bump libc from 0.2.98 to 0.2.99
- C1-low 📌:  Remove BuyExecution::orders
- C1-low 📌:  Replace cumulus with polkadot in license headers
- C1-low 📌:  Use proc macros to generate conversion functions for MultiLocation
- C1-low 📌:  Companion for Substrate#9547
- C1-low 📌:  XCM v2: Scripting, Query responses, Exception handling and Error reporting
- C1-low 📌:  check runtime version in staking miner
- C1-low 📌:  Make most XCM APIs accept an Into<MultiLocation> where MultiLocation is accepted
- C1-low 📌:  backing-availability-audit: Move ErasureChunk Proof to BoundedVec
- C1-low 📌:  CI: fix rustdoc publishing
- C1-low 📌:  Remove request multiplexer
- C1-low 📌:  More standard staking miner deposits
- C1-low 📌:  New Github Workflow to check extrinsic ordering
- C1-low 📌:  Fix kusama local chain name
- C1-low 📌:  Make xcm-simulator async with more tests
- C1-low 📌:  Make RelayedFrom typesafe
- C1-low 📌:  Companion PR for 'Make choosing an executor an explicit part of service construction' (#9525)
- C3-medium 📣:  CI: rustdoc
- C1-low 📌:  collect better memory stats
- C1-low 📌:  use WEIGHT_PER_SECOND in FixedRateOfFungible
- C1-low 📌:  Remove stale migrations
- C1-low 📌:  Bump env_logger from 0.8.4 to 0.9.0
- C1-low 📌:  Introduce metrics into PVF validation host
- C1-low 📌:  Minor fix to encoding for XCM v1
- C1-low 📌:  Impl WeightTrader for tuple
- C1-low 📌:  Companion for #9517 (Custom BenchmarkError)
- C1-low 📌:  Fix Polkadot Build
- C1-low 📌:  Fix Backwards Compatability with v0 Response
- C1-low 📌:  Add logging to PVF and other related parts
- C1-low 📌:  Companion for substrate/pull/9442
- C1-low 📌:  Bump thiserror from 1.0.24 to 1.0.26
- C1-low 📌:  Companion to #9514 (Remove Filter and use Contains instead)
- C1-low 📌:  companion pr for substrate:auto_db
- C1-low 📌:  Companion for #9512 (Support test-runner to submit unsigned_extrinsic)
- C1-low 📌:  Bump hex-literal from 0.3.1 to 0.3.3
- C1-low 📌:  Bump nix from 0.19.1 to 0.20.0
- C1-low 📌:  Harden XCM v1 for Recursions
- C1-low 📌:  Bump hex from 0.4.2 to 0.4.3
- C1-low 📌:  Bump lru from 0.6.5 to 0.6.6
- C1-low 📌:  UMP: Support Overweight messages
- C1-low 📌:  Do not expire HRMP open channel requests
- C1-low 📌:  add integration tests to xcm-builder
- C1-low 📌:  companion: for call usage https://github.com/paritytech/substrate/pull/9418
- C1-low 📌:  Companion for Generate storage info for pallet authority_discovery #9428
- C1-low 📌:  technical committee is using the weight of council, but should have its own generated weight instead
- C1-low 📌:  Companion for substrate #9371
- C1-low 📌:  Companion for Store voters in unsorted bags to get good stake iteration properties
- C3-medium 📣:  substrate #9202 companion: Multiple vesting schedules
- C1-low 📌:  Ensure MultiLocation always has a canonical representation
- C1-low 📌:  Bump strum from 0.20.0 to 0.21.0
- C1-low 📌:  Companion for #8615: enrich metadata with type information
- C1-low 📌:  Companion for substrate#9115
- C1-low 📌:  Companion for substrate#9080
- C1-low 📌:  Store the database in a role specific subdirectory
- C1-low 📌:  XCM v1

## Client


## Runtime


