{
  sources ? import ../npins,
  pkgs ? import sources.nixpkgs {},
  config,
}:
{
  imports = [
    (import "${sources.noctalia-shell}/nix/home-module.nix")
  ];

  home.packages = with pkgs; [
    niri
    xwayland-satellite
    gpu-screen-recorder
    xdg-desktop-portal
    xdg-desktop-portal-wlr
  ];
  services.polkit-gnome.enable = true;
  services.playerctld.enable = true;

  # niri config (symlink to wait less)
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/point/niri/config.kdl";

  # noctalia-shell
  programs.noctalia-shell = {
    enable = true;
    package = (pkgs.noctalia-shell.override { calendarSupport = true; });
    settings = {
      settingsVersion = 41;
      bar = {
        barType = "simple";
        position = "top";
        monitors = [ ];
        density = "compact";
        exclusive = true;
        showOutline = false;
        showCapsule = true;
        capsuleOpacity = 1;
        capsuleColorKey = "none";
        widgetSpacing = 6;
        backgroundOpacity = 0.93;
        useSeparateOpacity = false;
        floating = false;
        marginVertical = 4;
        marginHorizontal = 4;
        frameThickness = 8;
        frameRadius = 12;
        outerCorners = true;
        hideOnOverview = false;
        displayMode = "always_visible";
        autoHideDelay = 500;
        autoShowDelay = 150;
        showOnWorkspaceSwitch = true;
        widgets = {
          left = [
                {
                    characterCount = 2;
                    colorizeIcons = false;
                    enableScrollWheel = true;
                    followFocusedScreen = false;
                    groupedBorderOpacity = 1;
                    hideUnoccupied = false;
                    iconScale = 0.8;
                    id = "Workspace";
                    labelMode = "none";
                    showApplications = false;
                    showLabelsOnlyWhenOccupied = true;
                    unfocusedIconsOpacity = 1;
                }
                {
                    customFont = "";
                    formatHorizontal = "dddd yyyy-MM-dd HH:mm:ss";
                    formatVertical = "HH mm - dd MM";
                    id = "Clock";
                    tooltipFormat = "HH:mm ddd, MMM dd";
                    useCustomFont = false;
                    usePrimaryColor = false;
                }
                {
                    colorizeIcons = true;
                    hideMode = "hidden";
                    id = "ActiveWindow";
                    maxWidth = 400;
                    scrollingMode = "hover";
                    showIcon = true;
                    useFixedWidth = false;
                }
                {
                    colorizeIcons = false;
                    hideMode = "hidden";
                    iconScale = 0.8;
                    id = "Taskbar";
                    maxTaskbarWidth = 40;
                    onlyActiveWorkspaces = true;
                    onlySameOutput = true;
                    showPinnedApps = true;
                    showTitle = false;
                    smartWidth = true;
                    titleWidth = 50;
                }
          ];
          center = [];
          right = [
                {
                    compactMode = false;
                    compactShowAlbumArt = true;
                    compactShowVisualizer = false;
                    hideMode = "idle";
                    hideWhenIdle = false;
                    id = "MediaMini";
                    maxWidth = 200;
                    panelShowAlbumArt = true;
                    panelShowVisualizer = true;
                    scrollingMode = "hover";
                    showAlbumArt = true;
                    showArtistFirst = false;
                    showProgressRing = false;
                    showVisualizer = false;
                    useFixedWidth = false;
                    visualizerType = "linear";
                }
                {
                    blacklist = [];
                    colorizeIcons = false;
                    drawerEnabled = false;
                    hidePassive = false;
                    id = "Tray";
                    pinned = [];
                }
                {
                    id = "plugin:network-manager-vpn";
                }
                {
                    compactMode = false;
                    diskPath = "/";
                    id = "SystemMonitor";
                    showCpuTemp = true;
                    showCpuUsage = true;
                    showDiskUsage = true;
                    showGpuTemp = false;
                    showLoadAverage = true;
                    showMemoryAsPercent = false;
                    showMemoryUsage = true;
                    showNetworkStats = true;
                    useMonospaceFont = true;
                    usePrimaryColor = false;
                }
                {
                    hideWhenZero = false;
                    hideWhenZeroUnread = false;
                    id = "NotificationHistory";
                    showUnreadBadge = true;
                }
                {
                    deviceNativePath = "";
                    displayMode = "onhover";
                    hideIfNotDetected = true;
                    id = "Battery";
                    showNoctaliaPerformance = false;
                    showPowerProfiles = false;
                    warningThreshold = 30;
                }
                {
                    displayMode = "alwaysShow";
                    id = "Volume";
                    middleClickCommand = "pwvucontrol || pavucontrol";
                }
                {
                    displayMode = "onhover";
                    id = "Brightness";
                }
                {
                    # TODO: is it required?
                    # defaultSettings = {
                    #     audioCodec = "opus";
                    #     audioSource = "default_output";
                    #     colorRange = "limited";
                    #     copyToClipboard = false;
                    #     directory = "";
                    #     filenamePattern = "recording_yyyyMMdd_HHmmss";
                    #     frameRate = 60;
                    #     hideInactive = false;
                    #     iconColor = "none";
                    #     quality = "very_high";
                    #     resolution = "original";
                    #     showCursor = true;
                    #     videoCodec = "h264";
                    #     videoSource = "portal";
                    # };
                    id = "plugin:screen-recorder";
                }
                {
                    displayMode = "forceOpen";
                    id = "KeyboardLayout";
                    showIcon = true;
                }
                {
                    colorizeDistroLogo = false;
                    colorizeSystemIcon = "primary";
                    customIconPath = "";
                    enableColorization = false;
                    icon = "noctalia";
                    id = "ControlCenter";
                    useDistroLogo = true;
                }
                {
                    colorName = "error";
                    id = "SessionMenu";
                }
          ];
        };
        screenOverrides = [ ];
      };
      general = {
        avatarImage = "${config.home.homeDirectory}/.face";
        dimmerOpacity = 0.2;
        showScreenCorners = false;
        forceBlackScreenCorners = false;
        scaleRatio = 1;
        radiusRatio = 1;
        iRadiusRatio = 1;
        boxRadiusRatio = 1;
        screenRadiusRatio = 1;
        animationSpeed = 1.43;
        animationDisabled = false;
        compactLockScreen = false;
        lockScreenAnimations = false;
        lockOnSuspend = true;
        showSessionButtonsOnLockScreen = false;
        showHibernateOnLockScreen = false;
        enableShadows = true;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        language = "";
        allowPanelsOnScreenWithoutBar = true;
        showChangelogOnStartup = true;
        telemetryEnabled = true;
        enableLockScreenCountdown = true;
        lockScreenCountdownDuration = 10000;
        autoStartAuth = false;
        allowPasswordWithFprintd = false;
        clockStyle = "custom";
        clockFormat = "hh\nmm";
        passwordChars = false;
        lockScreenMonitors = [ ];
        lockScreenBlur = 0;
        lockScreenTint = 0;
        keybinds = {
          keyUp = [
            "Up"
          ];
          keyDown = [
            "Down"
          ];
          keyLeft = [
            "Left"
          ];
          keyRight = [
            "Right"
          ];
          keyEnter = [
            "Return"
          ];
          keyEscape = [
            "Esc"
          ];
          keyRemove = [
            "Del"
          ];
        };
        reverseScroll = false;
      };
      ui = {
        fontDefault = "JetBrainsMono Nerd Font";
        fontFixed = "JetBrainsMono Nerd Font";
        fontDefaultScale = 1;
        fontFixedScale = 1;
        tooltipsEnabled = true;
        panelBackgroundOpacity = 0.4;
        panelsAttachedToBar = true;
        settingsPanelMode = "window";
        wifiDetailsViewMode = "grid";
        bluetoothDetailsViewMode = "grid";
        networkPanelView = "wifi";
        bluetoothHideUnnamedDevices = false;
        boxBorderEnabled = false;
      };
      location = {
        name = "Paris, France";
        weatherEnabled = false;
        weatherShowEffects = true;
        useFahrenheit = false;
        use12hourFormat = false;
        showWeekNumberInCalendar = true;
        showCalendarEvents = true;
        showCalendarWeather = false;
        analogClockInCalendar = false;
        firstDayOfWeek = 1;
        hideWeatherTimezone = false;
        hideWeatherCityName = false;
      };
      calendar = {
        cards = [
          {
            enabled = true;
            id = "calendar-header-card";
          }
          {
            enabled = true;
            id = "calendar-month-card";
          }
          {
            enabled = false;
            id = "weather-card";
          }
        ];
      };
      wallpaper = {
        enabled = true;
        overviewEnabled = true;
        directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
        monitorDirectories = [ ];
        enableMultiMonitorDirectories = false;
        showHiddenFiles = false;
        viewMode = "single";
        setWallpaperOnAllMonitors = true;
        fillMode = "crop";
        fillColor = "#000000";
        useSolidColor = false;
        solidColor = "#1a1a2e";
        automationEnabled = true;
        wallpaperChangeMode = "random";
        randomIntervalSec = 3600;
        transitionDuration = 5000;
        transitionType = "random";
        skipStartupTransition = false;
        transitionEdgeSmoothness = 0.2;
        panelPosition = "follow_bar";
        hideWallpaperFilenames = false;
        overviewBlur = 0.4;
        overviewTint = 0.6;
        useWallhaven = false;
        wallhavenQuery = "";
        wallhavenSorting = "relevance";
        wallhavenOrder = "desc";
        wallhavenCategories = "111";
        wallhavenPurity = "100";
        wallhavenRatios = "";
        wallhavenApiKey = "";
        wallhavenResolutionMode = "atleast";
        wallhavenResolutionWidth = "";
        wallhavenResolutionHeight = "";
        sortOrder = "name";
        favorites = [ ];
      };
      appLauncher = {
        enableClipboardHistory = false;
        autoPasteClipboard = false;
        enableClipPreview = true;
        clipboardWrapText = true;
        # clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        # clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        position = "center";
        pinnedApps = [ ];
        useApp2Unit = false;
        sortByMostUsed = true;
        terminalCommand = "ghostty -e";
        customLaunchPrefixEnabled = false;
        customLaunchPrefix = "";
        viewMode = "grid";
        showCategories = false;
        iconMode = "tabler";
        showIconBackground = false;
        enableSettingsSearch = true;
        enableWindowsSearch = true;
        enableSessionSearch = true;
        ignoreMouseInput = false;
        screenshotAnnotationTool = "";
        overviewLayer = false;
        density = "default";
      };
      controlCenter = {
        position = "close_to_bar_button";
        diskPath = "/";
        shortcuts = {
          left = [
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "plugin:screen-recorder";
            }
          ];
          right = [
            {
              id = "Notifications";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
        };
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = false;
            id = "brightness-card";
          }
          {
            enabled = false;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
      };
      systemMonitor = {
        cpuWarningThreshold = 80;
        cpuCriticalThreshold = 90;
        tempWarningThreshold = 80;
        tempCriticalThreshold = 90;
        gpuWarningThreshold = 80;
        gpuCriticalThreshold = 90;
        memWarningThreshold = 80;
        memCriticalThreshold = 90;
        swapWarningThreshold = 80;
        swapCriticalThreshold = 90;
        diskWarningThreshold = 80;
        diskCriticalThreshold = 90;
        diskAvailWarningThreshold = 20;
        diskAvailCriticalThreshold = 10;
        batteryWarningThreshold = 20;
        batteryCriticalThreshold = 5;
        enableDgpuMonitoring = true;
        useCustomColors = false;
        warningColor = "";
        criticalColor = "";
        externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
      };
      dock = {
        enabled = false;
      };
      network = {
        wifiEnabled = true;
        airplaneModeEnabled = false;
        bluetoothRssiPollingEnabled = false;
        bluetoothRssiPollIntervalMs = 60000;
        wifiDetailsViewMode = "grid";
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        disableDiscoverability = false;
      };
      sessionMenu = {
        enableCountdown = true;
        countdownDuration = 10000;
        position = "center";
        showHeader = false;
        showKeybinds = false;
        largeButtonsStyle = false;
        largeButtonsLayout = "single-row";
        powerOptions = [
          {
            action = "lock";
            enabled = true;
          }
          {
            action = "suspend";
            enabled = true;
          }
          {
            action = "hibernate";
            enabled = true;
          }
          {
            action = "reboot";
            enabled = true;
          }
          {
            action = "logout";
            enabled = true;
          }
          {
            action = "shutdown";
            enabled = true;
          }
        ];
      };
      notifications = {
        enabled = true;
        enableMarkdown = false;
        density = "default";
        monitors = [ ];
        location = "top_right";
        overlayLayer = true;
        backgroundOpacity = 1;
        respectExpireTimeout = true;
        lowUrgencyDuration = 3;
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
        clearDismissed = true;
        saveToHistory = {
          low = true;
          normal = true;
          critical = true;
        };
        sounds = {
          enabled = false;
          volume = 0.5;
          separateSounds = false;
          criticalSoundFile = "";
          normalSoundFile = "";
          lowSoundFile = "";
          excludedApps = "discord,firefox,chrome,chromium,edge";
        };
        enableMediaToast = false;
        enableKeyboardLayoutToast = true;
        enableBatteryToast = true;
      };
      osd = {
        enabled = true;
        location = "top_right";
        autoHideMs = 3000;
        overlayLayer = true;
        backgroundOpacity = 1;
        enabledTypes = [
          0
          1
          2
          3
        ];
        monitors = [ ];
      };
      audio = {
        volumeStep = 5;
        volumeOverdrive = false;
        cavaFrameRate = 60;
        visualizerType = "linear";
        mprisBlacklist = [ ];
        preferredPlayer = "";
        volumeFeedback = false;
      };
      brightness = {
        brightnessStep = 5;
        enforceMinimum = true;
        enableDdcSupport = true;
      };
      colorSchemes = {
        useWallpaperColors = true;
        predefinedScheme = "Catppuccin";
        darkMode = false;
        schedulingMode = "manual";
        manualSunrise = "09:00";
        manualSunset = "18:00";
        generationMethod = "tonal-spot";
        monitorForColors = "";
        matugenSchemeType = "scheme-fruit-salad";
      };
      templates = {
        activeTemplates = [
            {
                enabled = true;
                id = "niri";
            }
        ];
        enableUserTheming = false;
      };
      nightLight = {
        enabled = false;
        forced = false;
        autoSchedule = true;
        nightTemp = "4000";
        dayTemp = "6500";
        manualSunrise = "09:00";
        manualSunset = "18:00";
      };
      hooks = {
        enabled = false;
        wallpaperChange = "";
        darkModeChange = "";
        screenLock = "";
        screenUnlock = "";
        performanceModeEnabled = "";
        performanceModeDisabled = "";
        startup = "";
        session = "";
      };
      plugins = {
        autoUpdate = false;
      };
      desktopWidgets = {
        enabled = false;
        gridSnap = false;
        monitorWidgets = [ ];
      };
    };
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        screen-recorder = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        network-manager-vpn = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 1;
    };
    pluginSettings = {
      screen-recorder = {
        audioCodec = "opus";
        audioSource = "none";
        colorRange = "limited";
        copyToClipboard = false;
        directory = "${config.home.homeDirectory}/Videos";
        filenamePattern = "recording_yyyyMMdd_HHmmss";
        frameRate = 100;
        hideInactive = false;
        iconColor = "none";
        quality = "very_high";
        resolution = "1920x1080";
        showCursor = true;
        videoCodec = "h264";
        videoSource = "portal";
      };
    };
  };

  # cursors
  gtk.enable = true;
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
}
