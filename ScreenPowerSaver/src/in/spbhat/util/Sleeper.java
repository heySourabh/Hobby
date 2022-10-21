package in.spbhat.util;

import java.time.Duration;
import java.util.concurrent.locks.LockSupport;

public class Sleeper {
    public static void sleepFor(Duration amount) {
        LockSupport.parkNanos(amount.toNanos());
    }
}
