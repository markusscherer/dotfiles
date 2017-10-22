{-# LANGUAGE DeriveDataTypeable #-}
import XMonad
import XMonad.Hooks.DynamicLog hiding (pprWindowSet)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName 
import XMonad.Hooks.FadeInactive
import XMonad.Actions.Commands
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Util.NamedWindows
import XMonad.Util.WorkspaceCompare
import XMonad.Util.NamedScratchpad
import qualified XMonad.Util.ExtensibleState as XS
import XMonad.Actions.CycleWS
import qualified XMonad.StackSet as S
import Data.List
import Data.Maybe
import Control.Monad
import Codec.Binary.UTF8.String (encodeString)

data MyState = MyState {
  transparency :: Rational
} deriving (Show)

instance ExtensionClass MyState where
  initialValue = MyState {transparency = 0.95}

scratchpadLayout = (customFloating $ S.RationalRect (1/4) (1/4) (1/2) (1/2))

scratchpads = [
    NS "htop" "termite -e htop -t htop-scratchpad" (title =? "htop-scratchpad") scratchpadLayout
  , NS "alot" "termite -e 'sh -c \"TERM=screen-256color alot\"' -t alot-scratchpad" (title =? "alot-scratchpad") scratchpadLayout
  , NS "ncmpcpp" "termite -e ncmpcpp -c ~/.ncmpcpp/minimalconfig  -t ncmpcpp-scratchpad" 
      (title =? "ncmpcpp-scratchpad") scratchpadLayout
  , NS "wiki" "termite -e 'vim /home/markus/docs/vimwiki/index.wiki' -t wiki-scratchpad"
      (title =? "wiki-scratchpad") scratchpadLayout
  ]


myManageHook = composeAll
    [ className =? "Eclipse"      --> doFloat
    , namedScratchpadManageHook scratchpads
    , manageHook defaultConfig
    ]
 
nb = "#f4f4f4"
nf = "#2e3436"
sb = "#2e3436"
sf = nb

c1 = "#494b4f" -- leere Batterie
c2 = "#666666" -- schrift für inaktive screens

b1 = "#cccccc"  -- window border
b2 = "#cd8b00"  -- selected window border 

buildOptionsGeneral :: String -> [(String, String)] -> String
buildOptionsGeneral sep = foldl' f ""
  where f s (a,b) = s ++ " " ++ sep ++ a ++ " '" ++b++"'"

buildOptions' :: [(String, String)] -> String
buildOptions' = buildOptionsGeneral "-"

dmenuOptions = [("fn", "Cantarell:pixelsize=14"), 
                ("nb", nb),
                ("nf", nf),
                ("sb", sb),
                ("sf", sf)]

launcherOptions = ("p", "Launch") : dmenuOptions
termLauncherOptions = ("p", "Launch in Terminal") : dmenuOptions

launcher = "/home/markus/bin/dmenu_app_launcher" ++ buildOptions' launcherOptions 
termLauncher = "/home/markus/bin/dmenu_launch_term" ++ buildOptions' termLauncherOptions

volup="pulseaudio-ctl up" 
voldn="pulseaudio-ctl down"
volmu="pulseaudio-ctl mute"
micmu="pulseaudio-ctl mute-input"

musicvolup="mpc volume +5"
musicvoldn="mpc volume -5"

brightdn="xbacklight -dec 10"
brightup="xbacklight -inc 10"

musicNext = "mpc next"
musicPrev = "mpc prev"
musicToggle = "mpc toggle"

tmuxcopy = "tmux show-buffer | xclip -i -selection primary"

myXmobarPP = defaultPP {
              ppHiddenNoWindows = \x -> "<fc=gray>" ++ x ++ "</fc>"
            , ppVisible  = \x -> "<fn=2>" ++ x ++ "</fn>"
            , ppCurrent = \x -> "<fn=2>[" ++ x ++ "]</fn>"
            , ppTitle   = ((++) " " ) . shorten 80
            , ppLayout  = \x -> "<fn=1>" ++ x ++ "</fn>" 
            , ppSep = "  \x25A1  "
            }

myLog :: ScreenId -> PP -> X String
myLog sid pp = do
  winset <- gets windowset
  urgents <- readUrgents
  sort' <- ppSort pp
  let mscr = find ((==sid).S.screen) $ (\x -> S.current x : S.visible x) $ winset

  case mscr of
    Just scr -> do
      let ws = pprWindowSet sort' urgents pp (S.tag . S.workspace $ scr) winset
      let ld = description . S.layout . S.workspace $ scr
      let cur = if ((S.screen . S.current) winset == sid) then "CUR" else ""
      wt <-fromMaybe (return "") $ (fmap show)  <$> getName 
                                                <$> S.focus <$> (S.stack . S.workspace $ scr)
      return $ encodeString . sepBy (ppSep pp) . ppOrder pp $
                          [ ws
                          , cur
                          , ppLayout pp ld
                          , ppTitle  pp wt
                          ]
    Nothing -> return "Screen not Found"

myLayout = avoidStruts (smartSpacing 3 tiled ||| tiled ||| Mirror tiled ||| Full) ||| noBorders Full
   where tiled = Tall 1 (4/100) (1/2)

ints = (map show $ [1..9 :: Int ])

main = do
    xmonad $ docks $ ewmh defaultConfig
        { manageHook = myManageHook
        , terminal  = "termite"
        , borderWidth = 3
        , normalBorderColor  = "#cccccc"
        , focusedBorderColor = "#e06c75"
        , layoutHook = myLayout
        , startupHook = setWMName "LG3D"
        , modMask = mod4Mask  
        -- , handleEventHook = fadeWindowsEventHook
        , logHook = --mapM_ (\x -> myLog x myXmobarPP >>= xmonadPropLog) ((gets windowset) >>= S.screens) --mapM (\x -> myLog x myXmobarPP >>= xmonadPropLog)
          composeAll [
                      do
                        x <- gets windowset
                        let s = map (S.screen) $ S.screens x
                        mapM_ (\x -> myLog x myXmobarPP >>= xmonadPropLog' ("_XMONAD_LOG_" ++ (drop 2 $ show x))) s
                     -- , fadeWindowsLogHook $ composeAll [opaque, isUnfocused --> transparency 0.10]
                     , do
                        let windowsInCurrentWS = S.integrate' . S.stack . S.workspace . S.current
                        let isScratchPadWindow = (liftM ((isSuffixOf "-scratchpad") . show)) . getName
                        b <- or <$> ((sequence . (map isScratchPadWindow)) =<<
                                     (windowsInCurrentWS <$> gets windowset))
                        t <- if b then return 0.1 else XS.gets transparency
                        fadeInactiveCurrentWSLogHook t
                     ]
        } 
         `additionalKeys` (
        [
          ((mod4Mask .|. controlMask, xK_h), prevWS)
        , ((mod4Mask, xK_Escape), spawn "urxvt")
        , ((mod4Mask .|. controlMask, xK_l), nextWS)
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((mod4Mask, xK_F3), namedScratchpadAction scratchpads "wiki")
        , ((mod4Mask, xK_F4), namedScratchpadAction scratchpads "ncmpcpp")
        , ((mod4Mask, xK_F5), namedScratchpadAction scratchpads "alot")
        , ((mod4Mask, xK_F6), spawn "firefox")
        , ((mod4Mask, xK_r),  spawn launcher )
        , ((mod4Mask, xK_e),  spawn "select-emoji" )
        , ((mod4Mask, xK_x), namedScratchpadAction scratchpads "htop")
        , ((mod4Mask .|. shiftMask,   xK_r), spawn termLauncher )
        , ((mod4Mask .|. controlMask, xK_i), spawn musicNext)
        , ((mod4Mask .|. controlMask, xK_y), spawn musicPrev)
        , ((mod4Mask .|. controlMask, xK_u), spawn musicToggle)
        , ((mod4Mask, xK_v), myLog 1 myXmobarPP >>= xmonadPropLog' "MYDEBUG")
        , ((mod4Mask, xK_c), spawn "/home/markus/bin/recompile-start-xmonad")
        , ((0, stringToKeysym "XF86AudioNext"),         spawn musicNext)
        , ((0, stringToKeysym "XF86AudioPrev"),         spawn musicPrev)
        , ((0, stringToKeysym "XF86AudioPlay"),         spawn musicToggle)
        , ((0, stringToKeysym "XF86AudioLowerVolume"),  spawn voldn)
        , ((0, stringToKeysym "XF86AudioMute"),         spawn volmu)
        , ((0, stringToKeysym "XF86AudioRaiseVolume"),  spawn volup)
        , ((0, stringToKeysym "XF86AudioMicMute"),      spawn micmu)
        , ((0, stringToKeysym "XF86MonBrightnessUp"),   spawn brightup)
        , ((0, stringToKeysym "XF86MonBrightnessDown"), spawn brightdn)
        , ((mod4Mask, stringToKeysym "XF86AudioLowerVolume"), spawn musicvoldn)
        , ((mod4Mask, stringToKeysym "XF86AudioRaiseVolume"), spawn musicvolup)
        ]
        ++
          [((mod4Mask, k), windows $ S.view i)   -- view instead of greedyView
            | (i, k) <- zip ints [xK_1 .. xK_9]])
        `additionalMouseBindings` (
        [ ((0, 12), const $ spawn musicToggle)
        , ((0, 11), const $ spawn musicNext)
        -- , ((0, 10), const $ spawn tmuxcopy)
        , ((mod4Mask, 11), const $ spawn musicPrev)
        , ((mod4Mask, 4),  const $ spawn volup)
        , ((mod4Mask, 5),  const $ spawn voldn)
        , ((mod4Mask .|. controlMask, 4),  const $ spawn musicvolup)
        , ((mod4Mask .|. controlMask, 5),  const $ spawn musicvoldn)
        , ((mod4Mask .|. shiftMask, 4),  const $ (XS.modify $ onTransparency $ increaseToMax 1.0 0.05) >>
                                                 (XS.gets transparency >>= fadeInactiveCurrentWSLogHook)
          )
        , ((mod4Mask .|. shiftMask, 5),  const $ (XS.modify $ onTransparency $ decreaseToMin 0.0 0.05) >>
                                                 (XS.gets transparency >>= fadeInactiveCurrentWSLogHook)
          )
        ]
        )

onTransparency :: (Rational -> Rational) -> MyState -> MyState
onTransparency f s = s {transparency = (f . transparency) s}

increaseToMax m inc x = min (x + inc) m
decreaseToMin m dec x = max (x - dec) m

-- Copied and modified from XMonad.Hooks.DynamicLog

-- | Format the workspace information, given a workspace sorting function,
--   a list of urgent windows, a pretty-printer format, and the current
--   WindowSet.
pprWindowSet :: WorkspaceSort -> [Window] -> PP -> WorkspaceId -> WindowSet -> String
pprWindowSet sort' urgents pp this s = sepBy (ppWsSep pp) . map fmt . sort' $
            map S.workspace (S.current s : S.visible s) ++ S.hidden s
   where visibles = S.currentTag s : map (S.tag . S.workspace) (S.visible s)

         fmt w = printer pp (S.tag w)
          where printer | any (\x -> maybe False (== S.tag w) (S.findTag x s)) urgents  = ppUrgent
                        | S.tag w == this                                               = ppCurrent
                        | S.tag w `elem` visibles                                       = ppVisible
                        | isJust (S.stack w)                                            = ppHidden
                        | otherwise                                                     = ppHiddenNoWindows

-- | Output a list of strings, ignoring empty ones and separating the
--   rest with the given separator.
sepBy :: String   -- ^ separator
      -> [String] -- ^ fields to output
      -> String
sepBy sep = concat . intersperse sep . filter (not . null)
