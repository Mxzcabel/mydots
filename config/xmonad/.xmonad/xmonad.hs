  {-# OPTIONS_GHC -Wno-deprecations #-}
    -- Base
import XMonad
import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

   -- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

   -- ColorScheme module (SET ONLY ONE!)
      -- Possible choice are:
      -- DoomOne
      -- DoomOne2 (Custom with Nord border colors)
      -- Dracula
      -- GruvboxDark
      -- MonokaiPro
      -- Nord
      -- OceanicNext
      -- Palenight
      -- SolarizedDark
      -- SolarizedLight
      -- TomorrowNight
import Colors.GruvboxDark

myFont :: String
myFont = "xft:agave Nerd Font Complete Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "alacritty"    -- Sets default terminal

myBrowser :: String
myBrowser = "firefox-developer-edition"  -- Sets qutebrowser as browser

myEmacs :: String
myEmacs = "emacsclient -c -a 'emacs' "  -- Makes emacs keybindings easier to type

myEditor :: String
myEditor = "emacsclient -c -a 'emacs' "  -- Sets emacs as editor
-- myEditor = myTerminal ++ " -e vim "    -- Sets vim as editor

myBorderWidth :: Dimension
myBorderWidth = 0           -- Sets border width for windows

myNormColor :: String       -- Border color of normal windows
myNormColor   = colorBack   -- This variable is imported from Colors.THEME

myFocusColor :: String      -- Border color of focused windows
myFocusColor  = color15     -- This variable is imported from Colors.THEME

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
    --spawnOnce "conky -c $HOME/.config/bspwm/conky.config &"
    spawnOnce "polybar &"
    spawnOnce "xsetroot -cursor_name left_ptr &" -- set mouse style
    --spawnOnce "/home/archie/.xmonad/scripts/autostart.sh &"
    --spawnOnce "nm-applet &"
    --spawnOnce "volumeicon &"
    spawnOnce "tint2 &" -- bottom applications bar
    spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
    spawnOnce "trayer --edge top --align right --widthtype request --padding 7 --SetDockType true --SetPartialStrut true --expand true --monitor 2 --transparent true --alpha 0 --tint 0x282c34  --height 20 &"
    --spawnOnce "xargs xwallpaper --stretch < ~/.xwallpaper"  -- set last saved with xwallpaper
    --spawnOnce "/home/arctech/.xmonad/scripts/polkit.sh &"  -- start Policykit in Background
    --spawnOnce "xfce4-power-manager &"  -- set PowerManager in Background
    --spawnOnce "nitrogen --restore &"   -- if you prefer nitrogen to feh
    spawnOnce "pcmanfm --desktop &" -- for wallpaper management from pcmanfm and desktop icons
    spawnOnce "picom -f -b" -- set compositor
    setWMName "Xmonad"


myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

myAppGrid = [ ("Audacity", "audacity")
                 , ("Deadbeef", "deadbeef")
                 , ("Emacs", "emacsclient -c -a emacs")
                 , ("Firefox", "firefox")
                 , ("Firefox Developer Edition", "firefox-developer-edition")
                 , ("Geary", "geany")
                 , ("Gimp", "gimp")
                 , ("Kdenlive", "kdenlive")
                 , ("LibreOffice Impress", "loimpress")
                 , ("LibreOffice Writer", "lowriter")
                 , ("OBS", "obs")
                 , ("PCManFM", "pcmanfm")
                 ]

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mocp" spawnMocp findMocp manageMocp
                , NS "calculator" spawnCalc findCalc manageCalc
                ]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMocp  = myTerminal ++ " -t mocp -e mocp"
    findMocp   = title =? "mocp"
    manageMocp = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnCalc  = "qalculate-gtk"
    findCalc   = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
mymagnify  = renamed [Replace "magnify"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ magnifier
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme
tallAccordion  = renamed [Replace "tallAccordion"]
           $ Accordion
wideAccordion  = renamed [Replace "wideAccordion"]
           $ Mirror Accordion

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = color15
                 , inactiveColor       = color08
                 , activeBorderColor   = color15
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = color16
                 }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout =     withBorder myBorderWidth tall
                                 ||| mymagnify
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| noBorders tabs
                                 ||| grid
                                 ||| spirals
                                 ||| threeCol
                                 ||| threeRow
                                 ||| tallAccordion
                                 ||| wideAccordion

myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
-- myWorkspaces = [" CLI ", " WEB ", " EDIT ", " SYS ", " VM ", " CHAT ", " MUS ", " VLC ", " GIMP "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out the full
     -- name of my workspaces and the names would be very long if using clickable workspaces.
     [ className =? "confirm"         --> doFloat
     , className =? "file_progress"   --> doFloat
     , className =? "dialog"          --> doFloat
     , className =? "download"        --> doFloat
     , className =? "error"           --> doFloat
     , className =? "Gimp"            --> doFloat
     , className =? "notification"    --> doFloat
     , className =? "pinentry-gtk-2"  --> doFloat
     , className =? "splash"          --> doFloat
     , className =? "toolbar"         --> doFloat
     , className =? "mpv"	      --> doFloat
     , title =? "Oracle VM VirtualBox Manager"  --> doFloat
     , title =? "Mozilla Firefox"     --> doShift ( myWorkspaces !! 1 )
     , className =? "Firefox Developer Edition"   --> doShift ( myWorkspaces !! 1 )
     , className =? "telegram-desktop"     --> doShift ( myWorkspaces !! 6 )
     , className =? "telegram-desktop"     --> doShift ( myWorkspaces !! 6 )
     , className =? "vlc"             --> doShift ( myWorkspaces !! 3 )
     , className =? "Gimp"            --> doShift ( myWorkspaces !! 9 )
     , className =? "VirtualBox Manager" --> doShift  ( myWorkspaces !! 4 )
     , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     , isFullscreen -->  doFullFloat
     ] <+> namedScratchpadManageHook myScratchPads

myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [  ("M-S-x", spawn "xmonad --recompile")  -- Recompiles xmonad
        --, ("M-S-q", spawn "arcolinux-logout")              -- Quits xmonad
        --, ("M-S-v", spawn "virt-manager")
        --, ("M-t", spawn "thunar")
        --, ("M-S-t", spawn "telegram-desktop")

    -- Run Prompt
        , ("C-M1-e", spawn "rofi -show drun") -- Rofi
        --, ("M-S-d-<Return>", spawn "j4-dmenu-desktop") -- Dmenu
        , ("S-M1-d", spawn "dmenu_run -i -nb '#191919' -nf '#5fb3b3' -sb '#5fb3b3' -sf '#191919' -fn 'NotoMonoRegular:bold:pixelsize=14'") -- Dmenu with custom color and font
        --, ("M-q", spawn "nitrogen --restore") -- Refresh nitrogen
    
    -- Useful programs to have a keybinding for launch
        , ("M-S-<Return>", spawn (myTerminal))
        , ("C-M1-b", spawn (myBrowser))
        --, ("M-C-<Return>", spawn ("edex-ui"))
        --, ("M-s", spawn ("spotify"))
        --, ("M-S-d", spawn ("discord"))
        , ("C-M1-p", spawn ("flameshot gui"))
        , ("C-M1-t", spawn ("tint2"))
        , ("C-M1-o", spawn ("obs"))
        , ("C-M1-r", spawn ("rofi -show window"))
		, ("C-M1-c", spawn ("parcellite"))

    -- Kill windows
        , ("M-p", spawn ("killall parcellite")) -- Kill the active clipboard parcellite
        , ("C-M1-q", kill1)     -- Kill the currently focused client
        , ("C-M1-0", killAll)   -- Kill all windows on current workspace

    -- Workspaces
        , ("M-S-.", nextScreen)  -- Switch focus to next monitor
        , ("M-S-,", prevScreen)  -- Switch focus to prev monitor
        , ("M-C-.", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("M-C-,", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

    -- Floating windows
        , ("M-f", sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout
        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
        , ("C-S-t", sinkAll)                       -- Push ALL floating windows to tile

    -- Increase/decrease spacing (gaps)
        , ("C-M1-k", decWindowSpacing 4)         -- Decrease window spacing
        , ("C-M1-l", incWindowSpacing 4)         -- Increase window spacing
        , ("C-M1-h", decScreenSpacing 4)         -- Decrease screen spacing
        , ("C-M1-j", incScreenSpacing 4)         -- Increase screen spacing

    -- Grid Select (CTR-g followed by a key)
        , ("C-g g", spawnSelected' myAppGrid)                 -- grid select favorite apps
        , ("C-g t", goToSelected $ mygridConfig myColorizer)  -- goto selected window
        , ("C-g b", bringSelected $ mygridConfig myColorizer) -- bring selected window

    -- Windows navigation
        , ("M-C-m", windows W.focusMaster)  -- Move focus to the master window
        , ("M-C-j", windows W.focusDown)    -- Move focus to the next window
        , ("M-C-k", windows W.focusUp)      -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)   -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)     -- Swap focused window with prev window
        , ("M-<Backspace>", promote)      -- Moves focused window to master, others maintain order
        , ("M-S-<Tab>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
        , ("M-C-<Tab>", rotAllDown)       -- Rotate all the windows in the current stack

    -- Layouts
        , ("M-<Tab>", sendMessage NextLayout)           -- Switch to next layout
        , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full

    -- Increase/decrease windows in the master pane or the stack
        , ("M-S-<Up>", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
        , ("M-S-<Down>", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane
        , ("M-C-<Up>", increaseLimit)                   -- Increase # of windows
        , ("M-C-<Down>", decreaseLimit)                 -- Decrease # of windows

    -- Window resizing
        , ("M-h", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                   -- Expand horiz window width
        , ("M-j", sendMessage MirrorShrink)          -- Shrink vert window width
        , ("M-k", sendMessage MirrorExpand)          -- Expand vert window width

    -- Sublayouts
    -- This is used to push windows to tabbed sublayouts, or pull them out of it.
        , ("M-M1-h", sendMessage $ pullGroup L)
        , ("M-M1-l", sendMessage $ pullGroup R)
        , ("M-M1-k", sendMessage $ pullGroup U)
        , ("M-M1-j", sendMessage $ pullGroup D)
        , ("M-m", withFocused (sendMessage . MergeAll))
        , ("M-u", withFocused (sendMessage . UnMerge))
        , ("M-y", withFocused (sendMessage . UnMergeAll))
        , ("C-M1-.", onGroup W.focusUp')    -- Switch focus to next tab
        , ("C-M1-,", onGroup W.focusDown')  -- Switch focus to prev tab

    
    -- Controls for mocp music player (SUPER-u followed by a key)
        , ("M-v <Up>", spawn "mocp --play")
        , ("M-v <Right>", spawn "mocp --next")
        , ("M-v <Left>", spawn "mocp --previous")
        , ("M-v <Space>", spawn "mocp --toggle-pause")

    
    -- Sound And Brightness
          , ("<XF86MonBrightnessUp>", spawn "lux -a 10%")
          , ("<XF86MonBrightnessDown>", spawn "lux -s 10%")
          
          , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
          , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -10%")
          , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +10%")
        ]
    -- The following lines are needed for named scratchpads.
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

main :: IO ()
main = do
    -- Launching three instances of xmobar on their monitors.
    --xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc0"
    --xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobarrc0"
    --xmproc2 <- spawnPipe "xmobar -x 2 $HOME/.config/xmobar/xmobarrc0"
    -- the xmonad, ya know...what the WM is named after!
    xmonad $ ewmh def
        { manageHook         = myManageHook <+> manageDocks
        , handleEventHook    = docksEventHook
                               -- Uncomment this line to enable fullscreen support on things like YouTube/Netflix.
                               -- This works perfect on SINGLE monitor systems. On multi-monitor systems,
                               -- it adds a border around the window if screen does not have focus. So, my solution
                               -- is to use a keybinding to toggle fullscreen noborders instead.  (M-<Space>)
                               <+> fullscreenEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
       -- , logHook = dynamicLogWithPPbb $ namedScratchpadFilterOutWorkspacePP $ xmobarPP
              -- the following variables beginning with 'pp' are settings for xmobar.
             -- { ppOutput = \x -> hPutStrLn xmproc0 x                          -- xmobar on monitor 1
             --                 >> hPutStrLn xmproc1 x                          -- xmobar on monitor 2
             --                 >> hPutStrLn xmproc2 x                          -- xmobar on monitor 3
             -- , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]"           -- Current workspace
             -- , ppVisible = xmobarColor "#98be65" "" . clickable              -- Visible but not current workspace
             -- , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" "" . clickable -- Hidden workspaces
             -- , ppHiddenNoWindows = xmobarColor "#c792ea" ""  . clickable     -- Hidden workspaces (no windows)
             -- , ppTitle = xmobarColor "#b3afc2" "" . shorten 50               -- Title of active window
             -- , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
             -- , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
              --, ppExtras  = [windowCount]                                     -- # of windows current workspace
             -- , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
             -- }
        } `additionalKeysP` myKeys


