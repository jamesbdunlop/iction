local iction = iction
iction.ictVoidData = {  uiType = "Frame",
                        uiName = "iction_voidFrame",
                        nameAttr = "iction_voidFrame",
                        uiInherits = nil,
                        userPlaced = true,
                        movable = true,
                        enableMouse = false,
                        SetClampedToScreen = true,
                        w = iction.bw*1.25,
                        h = iction.bh*1.25,
                        bgCol = {r = 0, g = 0, b= 0, a = 1},
                        strata = "MEDIUM",
                        pointPosition = {point = "BOTTOM",
                                         relativeTo = nil,
                                         relativePoint = "CENTER",
                                         x = 0, y = 80},
                        textures = {[1] = {name = "VOIDMOVEFRAME", allPoints = true, level = "ARTWORK",
                                           texture= "Interface\\ChatFrame\\ChatFrameBackground",
                                           vr = 1, vg = 1, vb = 1, va = 0 }},
                      }