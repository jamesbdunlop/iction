local iction = iction
iction.ictSWDData = {  uiType = "Frame",
                        uiName = "iction_SWDFrame",
                        nameAttr = "iction_SWDFrame",
                        uiInherits = nil,
                        userPlaced = true,
                        movable = true,
                        enableMouse = false,
                        SetClampedToScreen = true,
                        w = iction.bw*2,
                        h = iction.bh*2,
                        bgCol = {r = 0, g = 0, b= 0, a = 0},
                        strata = "MEDIUM",
                        pointPosition = {point = "BOTTOM",
                                         relativeTo = nil,
                                         relativePoint = "CENTER",
                                         x = 0, y = 80},
                        textures = { [1] = {name = "SWDMOVEFRAME", allPoints = true, level = "ARTWORK",
                                            texture= "Interface\\ChatFrame\\ChatFrameBackground",
                                            vr = 1, vg = 1, vb = 1, va = 0 } },
                     }