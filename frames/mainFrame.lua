local iction = iction
iction.ictMainFrameData = { uiType = "Frame",
                            uiName = "iction_MF",
                            nameAttr = "iction_MF",
                            uiInherits = nil,
                            userPlaced = true,
                            movable = true,
                            enableMouse = false,
                            SetClampedToScreen = true,
                            w = iction.ictionMFW,
                            h = iction.ictionMFH,
                            bgCol = {r = 0, g = 1, b= 0, a = 0},
                            strata = "LOW",
                            pointPosition = {point = "CENTER",
                                             relativeTo = UIParent,
                                             relativePoint = "CENTER",
                                             x = 0, y = 0},
                            textures = { [1] = {name = "iction_MF_TEXTURE", allPoints = true, level = "ARTWORK",
                                                texture= "Interface\\ChatFrame\\ChatFrameBackground",
                                                vr = 0, vg = 0, vb = 0, va = 0 } },
                            }