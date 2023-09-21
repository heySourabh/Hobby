package in.spbhat;

import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

import static in.spbhat.util.Sleeper.sleepFor;
import static java.time.temporal.ChronoUnit.MILLIS;
import static java.time.temporal.ChronoUnit.MINUTES;
import static javax.swing.JOptionPane.WARNING_MESSAGE;

public class ScreenPowerSaver {
    public static void main(String[] args) {
        Map<GraphicsDevice, Duration> screenIdleTime = new HashMap<>(3);
        Map<GraphicsDevice, JWindow> screenCoveringWindows = new HashMap<>(3);
        Duration durationBetweenChecks = Duration.of(500, MILLIS);
        Duration maxIdleDuration = Duration.of(2, MINUTES);
        GraphicsDevice[] screens = GraphicsEnvironment.getLocalGraphicsEnvironment().getScreenDevices();
        if (screens.length == 1) {
            String msg = "ScreenPowerSaver: Exiting as only single screen is connected.";
            System.out.println(msg);
            JOptionPane.showMessageDialog(null, msg, "Only one screen", WARNING_MESSAGE);
            System.exit(0);
        }
        boolean running = true;
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
                screenCoveringWindows.computeIfAbsent(screen, (s) -> {
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
}
