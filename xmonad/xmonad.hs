import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName 
import XMonad.Actions.Commands
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig
import XMonad.Actions.CycleWS
import qualified XMonad.StackSet as S
import Data.List

myManageHook = composeAll
    [ className =? "Eclipse"      --> doFloat
    , manageDocks
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

termnb="urxvt -e " --TODO
termsu="urxvt -cr red -e su" 
volup="pulseaudio-ctl up" 
voldn="pulseaudio-ctl down"
volmu="pulseaudio-ctl mute"

musicNext = "mpc next"
musicPrev = "mpc prev"
musicToggle = "mpc toggle"

commands = defaultCommands

myXmobarPP = defaultPP {
              ppHiddenNoWindows = \x -> "<fc=gray>" ++ x ++ "</fc>"
            , ppVisible  = id
            , ppCurrent = \x -> "<fn=2>" ++ x ++ "</fn>"
            , ppTitle   = ((++) " " ) . shorten 80
            , ppLayout  = \x -> "<fn=1>" ++ x ++ "</fn>" 
            , ppSep = "  \x25A1  "
            }

myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full) ||| noBorders Full 
   where tiled = Tall 1 (4/100) (1/2)

ints = (map show $ [1..9 :: Int ])

main = do
    xmonad $ defaultConfig  
        { manageHook = manageDocks  <+> myManageHook 
                        <+> manageHook defaultConfig
        , terminal  = "urxvt"
        , normalBorderColor  = b1
        , focusedBorderColor = b2
        , layoutHook = myLayout
        , startupHook = setWMName "LG3D"
        , modMask = mod4Mask  
        , logHook = dynamicLogString myXmobarPP >>= xmonadPropLog
        } 
         `additionalKeys` (
        [
          ((mod4Mask .|. controlMask, xK_h), prevWS)
        , ((mod4Mask, xK_Escape), spawn "urxvt")
        , ((mod4Mask .|. controlMask, xK_l), nextWS)
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((mod4Mask, xK_F4), spawn (termnb ++ "ncmpcpp"))
        , ((mod4Mask, xK_F5), spawn "thunderbird")
        , ((mod4Mask, xK_F6), spawn "firefox")
        , ((mod4Mask, xK_r),  spawn launcher )
        , ((mod4Mask .|. shiftMask,   xK_r), spawn termLauncher )
        , ((mod4Mask .|. controlMask, xK_i), spawn musicNext)
        , ((mod4Mask .|. controlMask, xK_y), spawn musicPrev)
        , ((mod4Mask .|. controlMask, xK_u), spawn musicToggle)
        , ((0,            0x1008ff17), spawn musicNext)
        , ((0,            0x1008ff16), spawn musicPrev)
        , ((0,            0x1008ff14), spawn musicToggle)
        , ((0,            0x1008ff11), spawn voldn)
        , ((0,            0x1008ff12), spawn volmu)
        , ((0,            0x1008ff13), spawn volup)
        ]
        ++
          [((mod4Mask, k), windows $ S.view i)   -- view instead of greedyView
            | (i, k) <- zip ints [xK_1 .. xK_9]])
        `additionalMouseBindings` (
        [ ((0, 12), const $ spawn musicToggle)
        , ((0, 11), const $ spawn musicNext)
        , ((mod4Mask, 11), const $ spawn musicPrev)
        , ((mod4Mask, 4),  const $ spawn volup)
        , ((mod4Mask, 5),  const $ spawn voldn)
        ]
        )
