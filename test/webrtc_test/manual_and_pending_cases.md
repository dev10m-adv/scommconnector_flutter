Manual real-device cases:

- Test 20: desktop to desktop on same network, different networks, Wi-Fi off/on, and app restart on one side.
- Test 21: desktop to Android with background/foreground, Wi-Fi to mobile-data switch, screen off/on, and reopen after kill.
- Test 22: long-running idle session for 30 to 60 minutes with occasional messages, then disconnect and reconnect.

These should remain manual because they depend on the real flutter_webrtc runtime, device power state, and operating-system networking behavior.

Pending higher-level signaling/session cases:

- Test 8: both peers create offer at the same time.
- Test 10: stale answer arrives late after a new session starts.
- Test 23: delayed signaling.
- Test 24: duplicated signaling messages.
- Test 25: out-of-order signaling.


These are not covered by the current unit harness because this package-level suite exercises WebRTC service and controller logic without a real signaling/session coordinator. To test them honestly, add a higher-level harness with session/version identifiers and crossed signaling delivery.