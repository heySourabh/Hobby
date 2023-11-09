package in.spbhat;

import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.time.Duration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static in.spbhat.util.Sleeper.sleepFor;
import static java.time.temporal.ChronoUnit.*;
import static javax.swing.JOptionPane.WARNING_MESSAGE;

public class ScreenPowerSaver {
    private static boolean running = true;

    public static void main(String[] args) throws Exception {
        Map<GraphicsDevice, Duration> screenIdleTime = new HashMap<>(3);
        Map<GraphicsDevice, JWindow> screenCoveringWindows = new HashMap<>(3);

        Duration durationBetweenChecks = Duration.of(500, MILLIS);
        Duration maxIdleDuration = Duration.of(2, MINUTES);

        List<GraphicsDevice> screens = getCurrentScreenDevices();
        exitOnSingleScreen(screens);

        while (running) {
            sleepFor(durationBetweenChecks);
            Point mouseLocation = MouseInfo.getPointerInfo().getLocation();
            for (GraphicsDevice screen : screens) {
                Rectangle screenBounds = screen.getDefaultConfiguration().getBounds();
                if (screenBounds.contains(mouseLocation)) {
                    System.out.println("Active screen: " + screen);
                    screenIdleTime.put(screen, Duration.ZERO);
                } else {
                    screenIdleTime.computeIfPresent(screen, (s, t) -> t.plus(durationBetweenChecks));
                    screenIdleTime.putIfAbsent(screen, Duration.ZERO);
                }
                screenCoveringWindows.computeIfAbsent(screen, s -> {
                    JWindow window = new JWindow(s.getDefaultConfiguration());
                    window.getContentPane().setBackground(Color.BLACK);
                    window.setIconImage(new BufferedImage(16, 16, BufferedImage.TYPE_INT_ARGB));
                    return window;
                });
            }

            for (var screenWindowEntry : screenCoveringWindows.entrySet()) {
                GraphicsDevice screen = screenWindowEntry.getKey();
                JWindow window = screenWindowEntry.getValue();
                if (maxIdleDuration.compareTo(screenIdleTime.get(screen)) < 0) {
                    showBlank(window, screen);
                } else {
                    hideBlank(window, screen);
                }
            }
        }
    }

    private static List<GraphicsDevice> getCurrentScreenDevices() {
        return List.of(GraphicsEnvironment.getLocalGraphicsEnvironment().getScreenDevices());
    }

    private static void hideBlank(Window window, GraphicsDevice screen) {
        if (!window.isVisible()) {
            return;
        }
        new Thread(() -> {
            window.setAlwaysOnTop(false);
            screen.setFullScreenWindow(null);
            window.setBounds(screen.getDefaultConfiguration().getBounds());
            float stepsSize = 0.1f;
            for (float opacity = 1.0f; opacity > 0.0f; opacity -= stepsSize) {
                window.setOpacity(opacity);
                sleepFor(Duration.of(20, MILLIS));
            }
            window.setOpacity(0.0f);
            window.setVisible(false);
        }).start();
    }

    private static void showBlank(Window window, GraphicsDevice screen) {
        if (window.isVisible()) {
            return;
        }
        new Thread(() -> {
            if (window.isAlwaysOnTopSupported()) {
                window.setAlwaysOnTop(true);
            }
            window.setBounds(screen.getDefaultConfiguration().getBounds());
            window.setOpacity(0.0f);
            window.setVisible(true);
            float stepSize = 0.1f;
            for (float opacity = 0.0f; opacity < 1.0f; opacity += stepSize) {
                window.setOpacity(opacity);
                sleepFor(Duration.of(50, MILLIS));
            }
            window.setOpacity(1.0f);
            if (screen.isFullScreenSupported()) {
                screen.setFullScreenWindow(window);
            }
        }).start();
    }

    private static void exitOnSingleScreen(List<GraphicsDevice> screens) {
        if (screens.size() == 1) {
            String msg = "ScreenPowerSaver: Closing as only single screen is connected.";
            System.out.println(msg);
            JOptionPane.showMessageDialog(null, msg, "Only one screen", WARNING_MESSAGE);
            normalExit();
        }

        Thread.startVirtualThread(() -> {
            while (running) {
                sleepFor(Duration.of(10, SECONDS));
                List<GraphicsDevice> currentScreens = getCurrentScreenDevices();
                if (currentScreens.size() <= 1) {
                    normalExit();
                }
            }
        });
    }

    private static void normalExit() {
        System.out.println("Stopping the program.");
        running = false;
        System.exit(0);
    }
}
